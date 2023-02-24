source common.sh

print_head "Setting up nodejs repo"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log_file}
status_check $?

print_head "install nodejs"
yum install nodejs -y &>>${log_file}
status_check $?

print_head "add app user"
if [ $? -ne 0 ]; then
  useradd roboshop &>>${log_file}
fi
status_check $?

print_head "create app directory"
mkdir /app &>>${log_file}
status_check $?
rm -rf /app/*

print_head "download artifacts"
curl -L -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>${log_file}
status_check $?
cd /app

print_head "extract files"
unzip /tmp/catalogue.zip &>>${log_file}
status_check $?

print_head "install dependencies"
npm install &>>${log_file}
status_check $?

print_head "copy service files"
cp ${code_dir}/config/catalogue.service /etc/systemd/system/catalogue.service &>>${log_file}
status_check $?

print_head "reload"
systemctl daemon-reload &>>${log_file}
status_check $?

print_head "enable catalogue"
systemctl enable catalogue &>>${log_file}
status_check $?

print_head "start catalogue"
systemctl start catalogue &>>${log_file}
status_check $?

schema_setup

#print_head "setup mongodb"
#cp ${code_dir}/config/mongodb.repo /etc/yum.repos.d/mongo.repo
#status_check $?
#
#yum install mongodb-org-shell -y
#status_check $?
#
#mongo --host mongodb.devops71.tech </app/schema/catalogue.js
#status_check $?
