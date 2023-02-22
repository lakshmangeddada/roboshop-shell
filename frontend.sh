source common.sh

print_head "Installing nginx"
yum install nginx -y &>>${log_file}
status_check $?

print_head "clearing the old content"
rm -rf /usr/share/nginx/html/* &>>${log_file}
status_check $?

print_head "downloading artifacts"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>${log_file}
cd /usr/share/nginx/html
status_check $?

print_head "Extracting the files"
unzip /tmp/frontend.zip &>>${log_file}
status_check $?

print_head "copying config files"
cp ${code_dir}/config/nginx.conf /etc/nginx/default.d/roboshop.conf &>>${log_file}
status_check $?

print_head "Enabling nginx service"
systemctl enable nginx &>>${log_file}
status_check $?

print_head "restarting nginx service"
systemctl restart nginnx &>>${log_file}
status_check $?


