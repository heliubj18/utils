CONFIG_FILE := ./makefile_config/default_aws.mk
# CONFIG_FILE := ${CONFIG_FILE:-"./makefile_config/default_aws.mk"}
include $(CONFIG_FILE)

TOOL_DIR := ./hypershift
HYPERSHIFT_CLI_TOOL := $(TOOL_DIR)/build_cli.sh
HYPERSHIFT_S3_TOOL := $(TOOL_DIR)/create_s3.sh
HYPERSHIFT_INSTALL_TOOL := $(TOOL_DIR)/hypershift_install.sh
HYPERSHIFT_CREATE_AWS_TOOL := $(TOOL_DIR)/hypershift_create_aws.sh
HYPERSHIFT_CLEAN_S3_TOOL := $(TOOL_DIR)/clean_s3.sh

ifeq ($(RELEASE_IMAGE),)
RELEASE_IMAGE := $(shell oc get clusterversion -o jsonpath='{.items[0].status.desired.version}')
endif

.PHONY: create
create:
	@$(MAKE) create-s3
	@$(MAKE) hypershift-install
	@$(MAKE) hypershft-create-aws

.PHONY: switch-config
switch-config:
    @read -r -p "Enter config file name: " config; \
    $(eval CONFIG_FILE := $$config); \
    echo "Switched to config file $(CONFIG_FILE)"

.PHONY: build-cli
build-cli: $(HYPERSHIFT_CLI_TOOL)
	sh $(HYPERSHIFT_CLI_TOOL) branch

.PHONY: update-cli-pr
update-cli-pr: $(HYPERSHIFT_CLI_TOOL)
ifeq ($(strip $(PR_NUMBER)),)
	$(error PR_NUMBER is not set)
endif
	sh $(HYPERSHIFT_CLI_TOOL) pr

.PHONY: create-s3
create-s3: $(HYPERSHIFT_S3_TOOL)
	sh $(HYPERSHIFT_S3_TOOL) $(BUCKET_NAME)

.PHONY: hypershift-install
hypershift-install: $(HYPERSHIFT_INSTALL_TOOL)
	sh $(HYPERSHIFT_INSTALL_TOOL)

.PHONY: hypershift-create-aws
hypershift-create-aws: $(HYPERSHIFT_CREATE_AWS_TOOL)
	sh $(HYPERSHIFT_CREATE_AWS_TOOL)

.PHONY: hypershift-uninstall
hypershift-uninstall:
	hypershift install  render --format=yaml | oc delete -f -

.PHONY: hypershift-destroy-aws
hypershift-uninstall:
	hypershift destroy cluster aws \
      --aws-creds $(AWS_CREDS) \
      --name $(CLUSTER_NAME) \
      --region $(HYPERSHIFT_AWS_REGION)

.PHONY: delete-s3
delete-s3:
	aws s3api delete-bucket --bucket $(BUCKET_NAME)

.PHONY: clean-s3-all
clean-s3-all: $(HYPERSHIFT_CLEAN_S3_TOOL)
	sh $(HYPERSHIFT_CLEAN_S3_TOOL)

.PHONY: clean
clean:
	@$(MAKE) hypershift-destroy-aws
	@$(MAKE) hypershift-uninstall
	@$(MAKE) delete-s3
