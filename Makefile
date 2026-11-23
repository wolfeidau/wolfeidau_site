APPNAME := wolfeidau-website
STAGE ?= dev
BRANCH ?= master
HUGO_ENVIRONMENT ?= development
# e.g. make deploy-waf CFN_FLAGS=--no-execute-changeset to create a change set for review
CFN_FLAGS ?=
WAF_REPUTATION_LIST_EFFECT ?= Block

# Fail fast if any named variable is empty; an empty parameter override would
# silently change prod (e.g. detach the WAF or rewrite DNS records).
require = $(foreach v,$(1),$(if $(strip $($(v))),,$(error $(v) is empty or unset)))

.PHONY: deploy-acm 
deploy-acm:
	$(call require,PRIMARY_SUB_DOMAIN_NAME HOSTED_ZONE_NAME HOSTED_ZONE_ID)
	@aws cloudformation deploy \
		--region us-east-1 \
		--no-fail-on-empty-changeset \
		$(CFN_FLAGS) \
		--template-file sam/website/acm.cfn.yaml \
		--capabilities CAPABILITY_IAM \
		--stack-name $(APPNAME)-$(STAGE)-$(BRANCH)-acm-certificate \
		--tags "environment=$(STAGE)" "branch=$(BRANCH)" "application=$(APPNAME)" \
		--parameter-overrides \
			AppName=$(APPNAME) \
			Stage=$(STAGE) \
			Branch=$(BRANCH) \
			PrimarySubDomainName=$(PRIMARY_SUB_DOMAIN_NAME) \
			HostedZoneName=$(HOSTED_ZONE_NAME) \
			HostedZoneId=$(HOSTED_ZONE_ID)

.PHONY: deploy-logging 
deploy-logging:
	@aws cloudformation deploy \
		--no-fail-on-empty-changeset \
		$(CFN_FLAGS) \
		--template-file sam/website/cloudfront-logging.cfn.yaml \
		--capabilities CAPABILITY_IAM \
		--stack-name $(APPNAME)-$(STAGE)-$(BRANCH)-cloudfront-logging \
		--tags "environment=$(STAGE)" "branch=$(BRANCH)" "application=$(APPNAME)" \
		--parameter-overrides \
			AppName=$(APPNAME) \
			Stage=$(STAGE) \
			Branch=$(BRANCH)

.PHONY: deploy-waf
deploy-waf:
	@aws cloudformation deploy \
		--region us-east-1 \
		--no-fail-on-empty-changeset \
		$(CFN_FLAGS) \
		--template-file sam/website/wafv2.cfn.yaml \
		--capabilities CAPABILITY_IAM \
		--stack-name $(APPNAME)-$(STAGE)-$(BRANCH)-wafv2 \
		--tags "environment=$(STAGE)" "branch=$(BRANCH)" "application=$(APPNAME)" \
		--parameter-overrides \
			AppName=$(APPNAME) \
			Stage=$(STAGE) \
			Branch=$(BRANCH) \
			ReputationListEffect=$(WAF_REPUTATION_LIST_EFFECT)

.PHONY: deploy-logging-v2
deploy-logging-v2:
	$(eval DISTRIBUTION_ARN := $(shell aws --region us-west-2 ssm get-parameter --name '/config/${STAGE}/${BRANCH}/${APPNAME}/website_cloudfront_distribution_arn' --query 'Parameter.Value' --output text))
	$(call require,DISTRIBUTION_ARN)

	@aws cloudformation deploy \
		--region us-east-1 \
		--no-fail-on-empty-changeset \
		$(CFN_FLAGS) \
		--template-file sam/website/cloudfront-logging-v2.cfn.yaml \
		--capabilities CAPABILITY_IAM \
		--stack-name $(APPNAME)-$(STAGE)-$(BRANCH)-cloudfront-logging-v2 \
		--tags "environment=$(STAGE)" "branch=$(BRANCH)" "application=$(APPNAME)" \
		--parameter-overrides \
			AppName=$(APPNAME) \
			Stage=$(STAGE) \
			Branch=$(BRANCH) \
			DistributionArn=$(DISTRIBUTION_ARN)

.PHONY: deploy-cloudfront-website
deploy-cloudfront-website:
	$(eval ACM_CERTIFICATE_ARN := $(shell aws --region us-east-1 ssm get-parameter --name '/config/${STAGE}/${BRANCH}/${APPNAME}/acm_certificate' --query 'Parameter.Value' --output text))
	$(eval LOGGING_BUCKET_DOMAIN := $(shell aws ssm get-parameter --name '/config/${STAGE}/${BRANCH}/${APPNAME}/logging_bucket_regional_domain' --query 'Parameter.Value' --output text))
	$(eval WEB_ACL_ARN := $(shell aws --region us-east-1 ssm get-parameter --name '/config/${STAGE}/${BRANCH}/${APPNAME}/web_acl_arn' --query 'Parameter.Value' --output text))
	$(call require,PRIMARY_SUB_DOMAIN_NAME HOSTED_ZONE_NAME HOSTED_ZONE_ID ACM_CERTIFICATE_ARN LOGGING_BUCKET_DOMAIN WEB_ACL_ARN)

	@aws cloudformation deploy \
		--no-fail-on-empty-changeset \
		$(CFN_FLAGS) \
		--template-file sam/website/cloudfront-static-website.cfn.yaml \
		--capabilities CAPABILITY_IAM \
		--stack-name $(APPNAME)-$(STAGE)-$(BRANCH)-static-website \
		--tags "environment=$(STAGE)" "branch=$(BRANCH)" "application=$(APPNAME)" \
		--parameter-overrides \
			AppName=$(APPNAME) \
			Stage=$(STAGE) \
			Branch=$(BRANCH) \
			PrimarySubDomainName=$(PRIMARY_SUB_DOMAIN_NAME) \
			HostedZoneName=$(HOSTED_ZONE_NAME) \
			HostedZoneId=$(HOSTED_ZONE_ID) \
			AcmCertificateArn=$(ACM_CERTIFICATE_ARN) \
			LoggingBucketDomain=$(LOGGING_BUCKET_DOMAIN) \
			WebAclArn=$(WEB_ACL_ARN)

.PHONY: deploy-oidc-role
deploy-oidc-role:
	$(eval ASSETS_BUCKET := $(shell aws ssm get-parameter --name '/config/${STAGE}/${BRANCH}/${APPNAME}/assets_bucket' --query 'Parameter.Value' --output text))
	$(eval WEBSITE_CLOUDFRONT_ARN := $(shell aws ssm get-parameter --name '/config/${STAGE}/${BRANCH}/${APPNAME}/website_cloudfront_distribution_arn' --query 'Parameter.Value' --output text))
	$(call require,ASSETS_BUCKET WEBSITE_CLOUDFRONT_ARN)
	@aws cloudformation deploy \
		--no-fail-on-empty-changeset \
		$(CFN_FLAGS) \
		--template-file sam/website/oidc-roles.cfn.yaml \
		--capabilities CAPABILITY_IAM \
		--stack-name $(APPNAME)-$(STAGE)-$(BRANCH)-deploy-oidc-role \
		--tags "environment=$(STAGE)" "branch=$(BRANCH)" "application=$(APPNAME)" \
		--parameter-overrides \
			AppName=$(APPNAME) \
			Stage=$(STAGE) \
			Branch=$(BRANCH) \
			StaticWebsiteBucketName=$(ASSETS_BUCKET) \
			WebsiteCloudfrontArn=$(WEBSITE_CLOUDFRONT_ARN)

.PHONY: build
build:
	@hugo --environment $(HUGO_ENVIRONMENT) --gc --logLevel info --minify

.PHONY: docker-build
docker-build:
	@echo "building docker image..."
	docker build -t hugo-website .
	docker run --rm -t \
		-e HUGO_ENVIRONMENT=$(HUGO_ENVIRONMENT) \
		-e HUGO_PARAMS_POSTHOG_TOKEN \
		-e HUGO_PARAMS_POSTHOG_APIHOST \
		-v $(shell pwd):/src \
		hugo-website build \
		--environment $(HUGO_ENVIRONMENT) --gc --minify

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
