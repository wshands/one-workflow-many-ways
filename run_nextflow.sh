#!/bin/bash

set -eo pipefail

#get the directory that this script is in
#no matter where it's called from
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# requires Java JDK8
# https://stackoverflow.com/questions/7334754/correct-way-to-check-java-version-from-bash-script
JAVA_VER=$(java -version 2>&1 | sed -n ';s/.* version "\(.*\)\.\(.*\)\..*"/\1\2/p;')
if [ ! "$JAVA_VER" -ge 18 ]; then 
    sudo apt-get install -qq oracle-java8-installer oracle-java8-set-default
fi

if [ ! -f nextflow ]; then
    curl -s https://get.nextflow.io | bash
fi

./nextflow run "${DIR}/nextflow-workflow/main.nf" -c "${DIR}/nextflow-workflow/local_nextflow.config"
