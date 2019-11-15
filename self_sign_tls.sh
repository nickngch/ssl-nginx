#if [ $# -eq 0 ]
#  then
#    echo "No arguments supplied"
#    echo "Usage: self_sign_tls.sh DOMAIN_NAME"
#    exit 1
#fi

domain=$1

#openssl req -new -newkey rsa:4096 -nodes -keyout www.example.com.key -out www.example.com.csr -subj "/C=US/ST=Denial/L=Springfield/O=Dis/CN=www.example.com"

openssl req -new -newkey rsa:4096 -days 365 -nodes -x509 -subj "/C=SG/ST=Singapore/L=Singapore/O=ABC/CN=$domain" -keyout nginx.key  -out nginx.crt
