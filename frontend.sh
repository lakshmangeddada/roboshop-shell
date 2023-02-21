code_dir=$(pwd)
log_file=/tmp/roboshop.log
rm -f ${log_file}

echo -e "\e[32mInstalling nginx \e[0m"
yum install nginx -y &>>log_file

echo -e "\e[32m clearing the old content \e[0m"
rm -rf /usr/share/nginx/html/* &>>log_file

echo -e "\e[32m downloading artifacts \e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>log_file
cd /usr/share/nginx/html

echo -e "\e[32m Extracting the files \e[0m"
unzip /tmp/frontend.zip &>>log_file

echo -e "\e[32m copying config files \e[0m"
cp ${code_dir}/config/nginx.conf /etc/nginx/default.d/roboshop.conf &>>log_file

echo -e "\e[32m Enabling nginx service \e[0m"
systemctl enable nginx &>>log_file

echo -e "\e[32m restarting nginx service \e[0m"
systemctl restart nginx &>>log_file


