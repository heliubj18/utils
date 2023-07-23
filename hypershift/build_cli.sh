#!/bin/sh
set -eo pipefail
source $(dirname "$0")/pre_check.sh

# shellcheck disable=SC2112
function usage()
{
  echo '
  # usage
  # sh build_cli : build main branch latest hypershift cli
  # sh build_cli branch release-4.13 : build release-4.13 branch latest hypershift cli
  # sh build_cli pr 1234 : build hypershift cli based on hypershift project PR 1234
  '
}

# shellcheck disable=SC2112
function check_hypershift_dir()
{
  if [ ! -d "${HYPERSHIFT_DIR}" ]; then
    echo "Could not find hypershift project from ${HYPERSHIFT_DIR}"
    echo "Please download hypershift project from github.com/openshift/hypershift"
    exit 1
  fi
}

# shellcheck disable=SC2112
function build_hypershift_cli()
{
  local branch="${BRANCH:-main}"
  pushd ${HYPERSHIFT_DIR}
  local current_branch=$(git rev-parse --abbrev-ref HEAD)

  git checkout ${BRANCH}
  if ! git diff --quiet HEAD origin/"${BRANCH}"; then
    git pull origin ${BRANCH}
  fi

  git -P log -1

  echo
  make hypershift
  echo "Build hypershift client for branch ${BRANCH} successfully! You can find it in ${HYPERSHIFT_DIR}/bin"
  echo
  hypershift -v
  echo

  git checkout "$current_branch"
  popd
}

# shellcheck disable=SC2112
function build_hypershift_cli_with_PR()
{
  local pr=${PR_NUMBER}
  [ -z "$pr" ] && echo -e "ERROR: PR number needed" && exit 1

  pushd ${HYPERSHIFT_DIR}
  local current_branch=$(git rev-parse --abbrev-ref HEAD)

  echo "Tring to fetch PR $pr codes and checkout to pr-$pr"
  git fetch origin pull/$pr/head:pr-$pr
  git checkout pr-$pr
  echo "Now we are in the branch pr-$pr with commit id"
  git -P log -1

  echo
  make hypershift
  echo "Build hypershift client for PR $pr successfully! You can find it in ${HYPERSHIFT_DIR}/bin"
  echo
  hypershift -v
  echo
  git checkout "$current_branch"
  popd
}

HYPERSHIFT_DIR="$GOPATH/src/github.com/openshift/hypershift"
check_cli_dependency
check_hypershift_dir
build_mod="${1:-branch}"
case $build_mod in
  "branch")
    build_hypershift_cli
    ;;
  "pr")
    build_hypershift_cli_with_PR
    ;;
  *)
    usage
    ;;
esac