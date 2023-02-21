code_dir=$(pwd)
log_file=/tmp/roboshop.log
rm -f ${log_file}

print_head() {
  echo -e "\e[35$*\e[0m"
}

print_head "Installing nginx"
yum install nginx -y &>>{log_file}

print_head "clearing the old content"
rm -rf /usr/share/nginx/html/* &>>{log_file}

print_head "downloading artifacts"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>{log_file}
cd /usr/share/nginx/html

print_head "Extracting the files"
unzip /tmp/frontend.zip &>>{log_file}

print_head "copying config files"
cp ${code_dir}/config/nginx.conf /etc/nginx/default.d/roboshop.conf &>>{log_file}

print_head "Enabling nginx service"
systemctl enable nginx &>>{log_file}

print_head "restarting nginx service"
systemctl restart nginx &>>{log_file}



