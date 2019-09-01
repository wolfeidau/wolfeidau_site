sync:
	hugo
	s3cmd sync --delete-removed public/ s3://www.wolfe.id.au --acl-public
build:
	env GOBIN=$(shell pwd)/.bin GO111MODULE=on go install github.com/gohugoio/hugo
