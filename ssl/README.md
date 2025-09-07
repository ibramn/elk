# SSL Certificates for elogs.aldrees.com

This directory should contain your SSL certificates for the domain `elogs.aldrees.com`.

## Required Files

You need to place the following files in this directory:

1. `elogs.aldrees.com.crt` - Your SSL certificate file
2. `elogs.aldrees.com.key` - Your private key file

## Getting SSL Certificates

### Option 1: Let's Encrypt (Recommended)
```bash
# Install certbot
sudo apt-get install certbot

# Get certificate
sudo certbot certonly --standalone -d elogs.aldrees.com

# Copy certificates to this directory
sudo cp /etc/letsencrypt/live/elogs.aldrees.com/fullchain.pem ./elogs.aldrees.com.crt
sudo cp /etc/letsencrypt/live/elogs.aldrees.com/privkey.pem ./elogs.aldrees.com.key
```

### Option 2: Self-signed Certificate (Development only)
```bash
# Generate self-signed certificate
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout elogs.aldrees.com.key \
  -out elogs.aldrees.com.crt \
  -subj "/C=SA/ST=Riyadh/L=Riyadh/O=Aldrees/CN=elogs.aldrees.com"
```

## File Permissions
Make sure the certificate files have appropriate permissions:
```bash
chmod 644 elogs.aldrees.com.crt
chmod 600 elogs.aldrees.com.key
```

## DNS Configuration
Make sure your domain `elogs.aldrees.com` points to your server's IP address:
```
elogs.aldrees.com.  IN  A  YOUR_SERVER_IP
```
