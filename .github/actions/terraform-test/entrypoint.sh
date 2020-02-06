#!/bin/bash

function parseInputs {
  # Required inputs
  if [ "${INPUT_TF_ACTIONS_VERSION}" != "" ]; then
    tfVersion=${INPUT_TF_ACTIONS_VERSION}
  else
    echo "Input terraform_version cannot be empty"
    exit 1
  fi

  # Optional inputs
  tfWorkingDir="."
  if [ "${INPUT_TF_ACTIONS_WORKING_DIR}" != "" ] || [ "${INPUT_TF_ACTIONS_WORKING_DIR}" != "." ]; then
    tfWorkingDir=${INPUT_TF_ACTIONS_WORKING_DIR}
  fi
}

function installTerraform {
  if [[ "${tfVersion}" == "latest" ]]; then
    echo "Checking the latest version of Terraform"
    tfVersion=$(curl -sL https://releases.hashicorp.com/terraform/index.json | jq -r '.versions[].version' | grep -v '[-].*' | sort -rV | head -n 1)

    if [[ -z "${tfVersion}" ]]; then
      echo "Failed to fetch the latest version"
      exit 1
    fi
  fi

  url="https://releases.hashicorp.com/terraform/${tfVersion}/terraform_${tfVersion}_linux_amd64.zip"

  echo "Downloading Terraform v${tfVersion}"
  curl -s -S -L -o /tmp/terraform_${tfVersion} ${url}
  if [ "${?}" -ne 0 ]; then
    echo "Failed to download Terraform v${tfVersion}"
    exit 1
  fi
  echo "Successfully downloaded Terraform v${tfVersion}"

  echo "Unzipping Terraform v${tfVersion}"
  unzip -d /usr/local/bin /tmp/terraform_${tfVersion} &> /dev/null
  if [ "${?}" -ne 0 ]; then
    echo "Failed to unzip Terraform v${tfVersion}"
    exit 1
  fi
  echo "Successfully unzipped Terraform v${tfVersion}"
}

function terraformFmt {
  # Gather the output of `terraform fmt`.
  echo "fmt: info: checking if Terraform files in ${tfWorkingDir} are correctly formatted"
  fmtOutput=$(terraform fmt -check=true -write=false -diff ${fmtRecursive} ${*} 2>&1)
  fmtExitCode=${?}

  if [ ${fmtExitCode} -ne 0 ]; then
    echo "fmt: error: failed to parse Terraform files"
    echo "${fmtOutput}"
    echo
    exit ${fmtExitCode}
  fi

  echo "fmt success"
  exit ${fmtExitCode}
}

function terraformInit {
  # Gather the output of `terraform init`.
  echo "init: info: initializing Terraform configuration in ${tfWorkingDir}"
  initOutput=$(terraform init -input=false ${*} 2>&1)
  initExitCode=${?}

  # Exit code of 0 indicates success. Print the output and exit.
  if [ ${initExitCode} -eq 0 ]; then
    echo "init: info: successfully initialized Terraform configuration in ${tfWorkingDir}"
    echo "${initOutput}"
    echo
    exit ${initExitCode}
  fi
  echo "init success"
  exit ${fmtExitCode}
}

function main {
  scriptDir=$(dirname ${0})

  parseInputs

  cd ${GITHUB_WORKSPACE}/${tfWorkingDir}

  installTerraform
  terraformFmt ${*}
  terraformInit ${*}
}

main "${*}"
