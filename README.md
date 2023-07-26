# utils

## Makefile usage

> dependency:  
> 1. hypershift source code in $GOPATH/src/github.com/openshift/hypershift  
> 2. tools go,aws,git,oc with $KUBECONFIG to an active OCP

### ENV configuration
The default env config file for the Makefile is ./makefile_config/default_aws.mk  
You can change it using `make switch-config` e.g.
```shell
$ make switch-config 
Enter config file name: 
$ ./makefile_config/heli_aws.mk
Switched to config file ./makefile_config/heli_aws.mk
```

### Example
* create a hosted cluster automatically
```shell
make create
```
* destory cluster and related resources
```shell
make clean
```
* create one s3 bucket
```shell
make create-s3
```
* delete one s3 bucket
```shell
make delete-s3
```
* hypershift install
```shell
make hypershift-install
```
* uninstall hypershift operator
```shell
make hypershift-uninstall
```
* hypershift create an aws hosted cluster
```shell
make hypershift-create-aws
```
*  destroy an aws hosted cluster
```shell
make hypershift-destroy-aws
```
* build the latest hypershift cli
```shell
make build-cli
```
* build a release-4.13 hypershift cli
```shell
BRANCH=release-4.13 make build-cli 
```
* build a hypershift cli based on PR 1234
```shell
PR_NUMBER=1234 make build-cli-pr
```
* delete all s3 buckets created by this repo (be careful!)
```shell
make  clean-s3-all
```