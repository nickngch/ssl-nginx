if [ $# -eq 0 ]
  then
    echo "No arguments supplied"
    echo "Usage: self_sign_tls.sh DOMAIN_NAME IP"
    exit 1
fi

domain=$1
ip=$2

create_ca_key() {
	openssl genrsa -des3 -out rootCA.key 4096
}

create_ca_cert() {
	openssl req -x509 -new -nodes -key rootCA.key -sha256 -days 1024 -out rootCA.crt
}

create_tls_key() {
	openssl genrsa -out $domain.key 2048
}

create_tls_csr() {
cat <<EOF >> certificate.conf
[req]
default_bits = 2048
prompt = no
default_md = sha256
req_extensions = req_ext
distinguished_name = dn
[dn]]
C = SG
ST = Singapore
L = Singapore
O = ABC Pte Ltd
OU = Support
emailAddress = nick.ng@rancher.com
CN = $domain
[req_ext]
subjectAltName = @alt_names
[alt_names]
DNS.1 = $domain
IP.1 = $ip
EOF
openssl req -new -key $domain.key -out $domain.key.csr -config certificate.conf
}

create_tls_cert() {
	openssl x509 -req -in $domain.key.csr -CA rootCA.crt -CAkey rootCA.key -CAcreateserial -out $domain.key.crt -days 500 -sha256
}

main() {
	create_ca_key
	create_ca_cert
	create_tls_key
	create_tls_csr
	create_tls_cert
}

main
