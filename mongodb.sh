source common.sh

print_head "Setting up mongo repo"
cp config/mongodb.repo /etc/yum.repos.d/mongo.repo &>>${log_file}
status_check $?

print_head "installing mongodb"
yum install mongodb-org -y &>>${log_file}
status_check $?

print_head "enabling mongodb"
systemctl enable mongod &>>${log_file}
status_check $?

print_head "changing the listening address"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>>${log_file}
status_check $?

#Update listen address from 127.0.0.1 to 0.0.0.0 in /etc/mongod.conf
print_head "Setting up mongo repo"
systemctl restart mongod &>>${log_file}
status_check $?