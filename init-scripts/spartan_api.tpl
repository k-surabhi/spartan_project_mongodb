#!/bin/bash
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

echo $file > ../init-scripts/spartan_api
