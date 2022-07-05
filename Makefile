APPNAME := wolfeidau-website
STAGE ?= dev
BRANCH ?= master

.PHONY: deploy-acm 
deploy-acm:
	@sam deploy \
		--region us-east-1 \
		--no-fail-on-empty-changeset \
		--template-file sam/website/acm.cfn.yaml \
		--capabilities CAPABILITY_IAM \
		--stack-name $(APPNAME)-$(STAGE)-$(BRANCH)-acm-certificate \
		--tags "environment=$(STAGE)" "branch=$(BRANCH)" "service=$(APPNAME)" \
		--parameter-overrides \
			AppName=$(APPNAME) \
			Stage=$(STAGE) \
			Branch=$(BRANCH) \
			PrimarySubDomainName=$(PRIMARY_SUB_DOMAIN_NAME) \
			HostedZoneName=$(HOSTED_ZONE_NAME) \
			HostedZoneId=$(HOSTED_ZONE_ID)

.PHONY: deploy-logging 
deploy-logging:
	@sam deploy \
		--no-fail-on-empty-changeset \
		--template-file sam/website/cloudfront-logging.cfn.yaml \
		--capabilities CAPABILITY_IAM \
		--stack-name $(APPNAME)-$(STAGE)-$(BRANCH)-cloudfront-logging \
		--tags "environment=$(STAGE)" "branch=$(BRANCH)" "service=$(APPNAME)" \
		--parameter-overrides \
			AppName=$(APPNAME) \
			Stage=$(STAGE) \
			Branch=$(BRANCH)

.PHONY: deploy-cloudfront-redirect
deploy-cloudfront-redirect:
	$(eval ACM_CERTIFICATE_ARN := $(shell aws --region us-east-1 ssm get-parameter --name '/config/${STAGE}/${BRANCH}/${APPNAME}/acm_certificate' --query 'Parameter.Value' --output text))
	$(eval LOGGING_BUCKET_DOMAIN := $(shell aws ssm get-parameter --name '/config/${STAGE}/${BRANCH}/${APPNAME}/logging_bucket_regional_domain' --query 'Parameter.Value' --output text))

	@sam deploy \
		--no-fail-on-empty-changeset \
		--template-file sam/website/cloudfront-redirect.cfn.yaml \
		--capabilities CAPABILITY_IAM \
		--stack-name $(APPNAME)-$(STAGE)-$(BRANCH)-redirect \
		--tags "environment=$(STAGE)" "branch=$(BRANCH)" "service=$(APPNAME)" \
		--parameter-overrides \
			AppName=$(APPNAME) \
			Stage=$(STAGE) \
			Branch=$(BRANCH) \
			PrimarySubDomainName=$(PRIMARY_SUB_DOMAIN_NAME) \
			HostedZoneName=$(HOSTED_ZONE_NAME) \
			HostedZoneId=$(HOSTED_ZONE_ID) \
			AcmCertificateArn=$(ACM_CERTIFICATE_ARN) \
			LoggingBucketDomain=$(LOGGING_BUCKET_DOMAIN)

.PHONY: deploy-cloudfront-website
deploy-cloudfront-website:
	$(eval ACM_CERTIFICATE_ARN := $(shell aws --region us-east-1 ssm get-parameter --name '/config/${STAGE}/${BRANCH}/${APPNAME}/acm_certificate' --query 'Parameter.Value' --output text))
	$(eval LOGGING_BUCKET_DOMAIN := $(shell aws ssm get-parameter --name '/config/${STAGE}/${BRANCH}/${APPNAME}/logging_bucket_regional_domain' --query 'Parameter.Value' --output text))

	@sam deploy \
		--no-fail-on-empty-changeset \
		--template-file sam/website/cloudfront-static-website.cfn.yaml \
		--capabilities CAPABILITY_IAM \
		--stack-name $(APPNAME)-$(STAGE)-$(BRANCH)-static-website \
		--tags "environment=$(STAGE)" "branch=$(BRANCH)" "service=$(APPNAME)" \
		--parameter-overrides \
			AppName=$(APPNAME) \
			Stage=$(STAGE) \
			Branch=$(BRANCH) \
			PrimarySubDomainName=$(PRIMARY_SUB_DOMAIN_NAME) \
			HostedZoneName=$(HOSTED_ZONE_NAME) \
			HostedZoneId=$(HOSTED_ZONE_ID) \
			AcmCertificateArn=$(ACM_CERTIFICATE_ARN) \
			LoggingBucketDomain=$(LOGGING_BUCKET_DOMAIN)

.PHONY: deploy-oidc-role
deploy-oidc-role:
	$(eval ASSETS_BUCKET := $(shell aws ssm get-parameter --name '/config/${STAGE}/${BRANCH}/${APPNAME}/assets_bucket' --query 'Parameter.Value' --output text))
	$(eval WEBSITE_CLOUDFRONT_ARN := $(shell aws ssm get-parameter --name '/config/${STAGE}/${BRANCH}/${APPNAME}/website_cloudfront_distribution_arn' --query 'Parameter.Value' --output text))
	@sam deploy \
		--no-fail-on-empty-changeset \
		--template-file sam/website/oidc-roles.cfn.yaml \
		--capabilities CAPABILITY_IAM \
		--stack-name $(APPNAME)-$(STAGE)-$(BRANCH)-deploy-oidc-role \
		--tags "environment=$(STAGE)" "branch=$(BRANCH)" "service=$(APPNAME)" \
		--parameter-overrides \
			AppName=$(APPNAME) \
			Stage=$(STAGE) \
			Branch=$(BRANCH) \
			StaticWebsiteBucketName=$(ASSETS_BUCKET) \
			WebsiteCloudfrontArn=$(WEBSITE_CLOUDFRONT_ARN)

.PHONY: build
build:
	@hugo --gc --verbose --minify

.PHONY: docker-build
docker-build:
	docker run --rm -t \
		-v $(shell pwd):/src \
		klakegg/hugo:ext \
		--gc --verbose --minify

.PHONY: upload
upload:
	$(eval ASSETS_BUCKET := $(shell aws ssm get-parameter --name '/config/${STAGE}/${BRANCH}/${APPNAME}/assets_bucket' --query 'Parameter.Value' --output text))
	$(eval WEBSITE_CLOUDFRONT_ID := $(shell aws ssm get-parameter --name '/config/${STAGE}/${BRANCH}/${APPNAME}/website_cloudfront_distribution' --query 'Parameter.Value' --output text))
	@echo "sync files..."
	@aws s3 sync \
		--only-show-errors \
		--delete public/ s3://$(ASSETS_BUCKET)
	@echo "create invalidation..."
	@aws cloudfront create-invalidation \
		--distribution-id $(WEBSITE_CLOUDFRONT_ID) --paths "/*"