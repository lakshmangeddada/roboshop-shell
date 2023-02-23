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