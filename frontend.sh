code_dir=$(pwd)

echo -e "\e[32mInstalling nginx \e[0m"
yum install nginx -y

echo -e "\e[32m clearing the old content \e[0m"
rm -rf /usr/share/nginx/html/*

echo -e "\e[32m downloading artifacts \e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip
cd /usr/share/nginx/html

echo -e "\e[32m Extracting the files \e[0m"
unzip /tmp/frontend.zip

echo -e "\e[32m copying config files \e[0m"
cp ${code_dir}/config/nginx.conf /etc/nginx/default.d/roboshop.conf

echo -e "\e[32m Enabling nginx service \e[0m"
systemctl enable nginx

echo -e "\e[32m restarting nginx service \e[0m"
systemctl restart nginx

