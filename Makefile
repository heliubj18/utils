# set default config to enable switch config
DEFAULT_CONFIG_FILE := ./makefile_config/default_aws.mk
CURRENT_CONFIG := ./.current_config
CONFIG_FILE := $(shell if [ -s "$(CURRENT_CONFIG)" ]; then cat $(CURRENT_CONFIG); else echo $(DEFAULT_CONFIG_FILE); fi)
include $(CONFIG_FILE)
# export all env
export

# global variables
TOOL_DIR := ./hypershift
HYPERSHIFT_CLI_TOOL := $(TOOL_DIR)/build_cli.sh
HYPERSHIFT_S3_TOOL := $(TOOL_DIR)/create_s3.sh
HYPERSHIFT_INSTALL_TOOL := $(TOOL_DIR)/hypershift_install.sh
HYPERSHIFT_CREATE_AWS_TOOL := $(TOOL_DIR)/hypershift_create_aws.sh
HYPERSHIFT_CLEAN_S3_TOOL := $(TOOL_DIR)/clean_s3.sh
HYPERSHIFT_CREATE_HOSTED_KUBECONFIG_TOOL := $(TOOL_DIR)/create_hosted_kubeconfig.sh
HYPERSHIFT_DEBUG_HC_TOOL := $(TOOL_DIR)/debug_hc.sh

.PHONY: test
test:
	sh $(TOOL_DIR)/test.sh

.PHONY: create
create:
	@$(MAKE) create-s3
	@$(MAKE) hypershift-install
	@$(MAKE) hypershift-create-aws

.PHONY: build-cli
build-cli: $(HYPERSHIFT_CLI_TOOL)
	sh $(HYPERSHIFT_CLI_TOOL) branch

.PHONY: build-cli-pr
build-cli-pr: $(HYPERSHIFT_CLI_TOOL)
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
	@echo RELEASE_IMAGE_SYNC_MGMT $(RELEASE_IMAGE_SYNC_MGMT) ; \
	sh $(HYPERSHIFT_CREATE_AWS_TOOL)

.PHONY: hypershift-create-hosted-kubeconfig
hypershift-create-hosted-kubeconfig: $(HYPERSHIFT_CREATE_HOSTED_KUBECONFIG_TOOL)
	sh $(HYPERSHIFT_CREATE_HOSTED_KUBECONFIG_TOOL)

.PHONY: hypeshift-debug
hypershift-debug: $(HYPERSHIFT_DEBUG_HC_TOOL)
	sh $(HYPERSHIFT_DEBUG_HC_TOOL)

.PHONY: hypershift-uninstall
hypershift-uninstall:
	hypershift install  render --format=yaml | oc delete -f -

.PHONY: hypershift-destroy-aws
hypershift-destroy-aws:
	@target_hc=`oc get hc -n $(NAMESPACE) $(CLUSTER_NAME) --ignore-not-found` ; \
	if [ -n "$$target_hc" ] ; then \
		hypershift destroy cluster aws \
		  --aws-creds $(AWS_CREDS) \
		  --name $(CLUSTER_NAME) \
		  --region $(HYPERSHIFT_AWS_REGION) ; \
	else \
	  echo "hc not found, destroy successfully" ; \
	fi

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

.PHONY: switch-config
switch-config:
	@read -p "Enter config file name: " config ; \
	if [ ! -f "$$config" ]; then \
		echo "Error: $$config does not exist" ; \
		exit 1 ; \
	fi ; \
	echo "$$config" > $(CURRENT_CONFIG) ; \
	echo "Switched to config file $$config" ;

.PHONY: current-config
current-config:
	@echo "Current config file is $(CONFIG_FILE)" ; \
	echo "Current ENV: " ; \
	cat $(CONFIG_FILE) ; echo

.PHONY: switch-config-dft
switch-config-dft:
	@echo "$(DEFAULT_CONFIG_FILE)" > $(CURRENT_CONFIG) ; \
	echo "Switched to default config file $(DEFAULT_CONFIG_FILE)" ;

HELI_AWS_CONFIG := ./makefile_config/heli_aws.mk
.PHONY: switch-config-heli
switch-config-heli:
	@echo "$(HELI_AWS_CONFIG)" > $(CURRENT_CONFIG) ; \
	echo "Switched to default config file $(HELI_AWS_CONFIG)"