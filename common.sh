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
nodejs() {

print_head "Setting up nodejs repo"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log_file}
status_check $?

print_head "install nodejs"
yum install nodejs -y &>>${log_file}
status_check $?

print_head "add app user"
id roboshop  &>>${log_file}
if [ $? -ne 0 ]; then
  useradd roboshop &>>${log_file}
fi
status_check $?

print_head "create app directory"
if [ ! -d /app ]; then
  mkdir /app &>>${log_file}
fi
status_check $?
rm -rf /app/*

print_head "download artifacts"
curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>${log_file}
status_check $?
cd /app

print_head "extract files"
unzip /tmp/${component}.zip &>>${log_file}
status_check $?

print_head "install dependencies"
npm install &>>${log_file}
status_check $?

print_head "copy service files"
cp ${code_dir}/config/${component}.service /etc/systemd/system/${component}.service &>>${log_file}
status_check $?

print_head "reload"
systemctl daemon-reload &>>${log_file}
status_check $?

print_head "enable ${component}"
systemctl enable ${component} &>>${log_file}
status_check $?

print_head "start ${component}"
systemctl start ${component} &>>${log_file}
status_check $?

print_head "setup mongodb"
cp ${code_dir}/config/mongodb.repo /etc/yum.repos.d/mongo.repo &>>${log_file}
status_check $?

print_head "install mongodb"
yum install mongodb-org-shell -y &>>${log_file}
status_check $?

print_head "load schema"
mongo --host mongodb.devops71.tech </app/schema/${component}.js &>>${log_file}
status_check $?
}

#-------------------------------------------