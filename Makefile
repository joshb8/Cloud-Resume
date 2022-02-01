SHELL:=/bin/bash

.PHONY: build
.SILENT: integration-test

build:
	sam build

deploy-infra:
	sam build && aws-vault exec sam-user --no-session -- sam deploy

deploy-site:
	aws-vault exec sam-user --no-session -- aws s3 sync ./website s3://joshscloudresume.net

invoke-put:
	sam build && aws-vault exec sam-user --no-session -- sam local invoke put-function

integration-test:
	FIRST=$$(curl -s " https://3xm01hf4y8.execute-api.us-east-1.amazonaws.com/Prod/get" | jq ".body| tonumber"); \
	curl -s " https://3xm01hf4y8.execute-api.us-east-1.amazonaws.com/Prod/put"; \
	SECOND=$$(curl -s "https://3xm01hf4y8.execute-api.us-east-1.amazonaws.com/Prod/get" | jq ".body| tonumber"); \
	echo "Comparing if first count ($$FIRST) is less than (<) second count ($$SECOND)"; \
	if [[ $$FIRST -le $$SECOND ]]; then echo "PASS"; else echo "FAIL";  fi