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

format() {
   if [ ${PT_json} -eq "true" ]; then
      printf \"%s\"' "$1" | sed -E ':a;N;$!ba;s/\r{0,1}\n/\\n/g;s/\"/\\"/g;s/\t/\\t/g'
   else
      printf '\n\"%s\"\n' "%1"
   fi
}

if [[ $# -eq 1 ]]; then
   PT_directory=${1}
fi

if [ ! -d "${PT_directory}" ]; then
   echo "Directory ${PT_directory} does not exit"
   exit 2
fi

# declare variables
dir_df=$(format "$(df -Ph ${PT_directory})")
kernel_rpms=$(format "$(rpm -qa | grep ^kernel-[1-4])")
directory_files=$(format "$(ls -al ${PT_directory})")
directory_usage=$(format "$(du -a -d 1 ${PT_directory} | sort -n)")
percentage_used="$(df -Ph ${PT_directory} | awk 'NR==2 {print substr($5, 1, length($5)-1)}')"

success "{\"percentage_used\":${percentage_used}, \
          \"dir_df\":${dir_df}, \
          \"kernel_rpms\":${kernel_rpms}, \
          \"directory_files\":${directory_files}, \
          \"directory_usage\":${directory_usage}}"

exit 0
