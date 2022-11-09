#!/bin/sh
tdir=${1:-$TDIR}
echo $tdir

# It is just used to remove HyperShiftGUEST label and add NonHyperShiftHOST on the test cases without HyperShiftGUEST
# It is better to run in the openshift-test-private, otherwise use a abs dir below
# sh replace.sh ./test/extended/apiserverauth/apiserver.go true
# sh replace.sh ./test/extended/networking true
# sh replace.sh ./test/extended/workloads/ true
# sh replace.sh ./test/extended/workloads/ true

# only print sed result without real change by default
execute=$2
result_file="result-$RANDOM.txt"

function print_sed() {
    local file=$1
    sed  '/HyperShiftGUEST/!s/g.It("/g.It("NonHyperShiftHOST-/g' $file | sed 's/HyperShiftGUEST-//g' $file
}

function sed_linux() {
    local file=$1
    sed -i  '/HyperShiftGUEST/!s/g.It("/g.It("NonHyperShiftHOST-/g' $file
    sed -i  's/HyperShiftGUEST-//g' $file
}

function sed_mac() {
    local file=$1
    sed -i  "" '/HyperShiftGUEST/!s/g.It("/g.It("NonHyperShiftHOST-/g' $file
    sed -i  "" 's/HyperShiftGUEST-//g' $file
}

for file in `find $tdir -type f -name "*.go" `; do
    echo $file

    if [[ $tdir == *"networking"* ]]; then
      echo "It's for networking sdn by default!"

      # There are not only SDN testcases in networking dir, find them by [sig-networking] SDN
      res=$(grep "\"\[sig-networking\] SDN\"" $file)
      if [ -z "$res" ] ; then
        continue
      fi
    fi

    echo "$file" >> $result_file

    if [ -z $execute ] ; then
        print_sed $file
        continue
    fi

    os="$(uname -s)"
    case "${os}" in
        Linux*)
          sed_linux $file
          ;;
        Darwin*)
          sed_mac $file
          ;;
        *)
          echo "unknown system exit!"
          exit 1
    esac
done

