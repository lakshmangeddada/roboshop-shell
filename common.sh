code_dir=$(pwd)
log_file=/tmp/roboshop.log
rm -f ${log_file}

print_head() {
  echo -e "\e[33m$1\e[0m"
}

#----------------------------------------
status_check() {
  if [ $? -eq 0 ]; then
    echo SUCCESS
  else
    echo FAILURE
    echo "Read the log file ${log_file}"
    exit 1
  fi
}
#-----------------------------------------
schema_setup() {
  print_head "setup mongodb"
  cp ${code_dir}/config/mongodb.repo /etc/yum.repos.d/mongo.repo &>>${log_file}
  status_check $?

  print_head "install mongodb"
  yum install mongodb-org-shell -y &>>${log_file}
  status_check $?

  print_head "load schema"
  mongo --host mongodb.devops71.tech </app/schema/catalogue.js &>>${log_file}
  status_check $?
}
#-------------------------------------------