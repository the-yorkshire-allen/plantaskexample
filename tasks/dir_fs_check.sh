#!/bin/sh -fu
#
# Puppet Task Name: dir_fs_check
#
# Run checks on attributes of the passed folder
#

# Define return function
success() {
  echo "${1}"
}

if [[ $# -ne 1 ]]; then
   echo "Usage: dir_fs_check <directory>"
   exit 1
fi

if [ ! -d "${1}" ]; then
   echo "Directory ${1} does not exit"
   exit 2
fi

# declare variables
dir_df="$(df -Ph ${1} | jq -Rsa .)"
kernel_rpms="$(rpm -qa | grep ^kernel-[1-4] | jq -Rsa .)"
directory_files="$(ls -al ${1} | jq -Rsa .)"
directory_usage="$(du -a -d 1 ${1} | sort -n | jq -Rsa .)"
percentage_used="$(df -Ph ${1} | awk 'NR==2 {print substr($5, 1, length($5)-1)}')"

success "{\"percentage_used\":\"${percentage_used}\",\"dir_df\":${dir_df},\"kernel_rpms\":${kernel_rpms},\"directory_files\":${directory_files},\"directory_usage\":${directory_usage}}"

exit 0
