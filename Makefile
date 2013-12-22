REPORTER = spec

all: setup build 

setup:
	bundle install --binstubs --path vendor/bundle

build:
	./bin/jekyll build

.PHONY: build setup
