#!/usr/bin/env bash
sudo rm /etc/nginx/sites-available/default
sudo rm /etc/nginx/sites-enabled/default
sudo tee -a /etc/nginx/sites-available/spartan > /dev/null <<EOT
file="upstream spartan_server{
        server {IP0}:8080
	      server {IP1}:8080
        server {IP2}:8080
}

server{
		listen 80;
		server_name _;
		location / {
            proxy_set_header HOST $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_pass http://spartan_server;
				}
}"
EOT
sudo ln -s /etc/nginx/sites-available/spartan /etc/nginx/sites-enabled/spartan



#echo $file > ../init-scripts/spartan_api
