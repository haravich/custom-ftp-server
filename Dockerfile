# Use the Alpine base image
FROM alpine:latest

LABEL Maintainer="Hariprasath Ravichandran" 

# Install vsftpd and other necessary packages
RUN apk update && apk add --no-cache openssl vsftpd bash && rm -rf /var/cache/apk/*

# Create an FTP user and set their password
RUN adduser -D ftpuser
RUN echo "ftpuser:admin" | chpasswd

RUN mkdir -p /home/vsftpd/
RUN mkdir -p /var/log/vsftpd
RUN chown -R ftp:ftp /home/vsftpd/

# Copy vsftpd configuration files
COPY *.conf /etc/vsftpd/

# Copy the password change script
COPY run-vsftpd.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/run-vsftpd.sh
RUN mkdir -p /var/log/vsftpd && chown ftp:ftp /var/log/vsftpd

# Expose FTP port
EXPOSE 20 21 21100-21110

# Start vsftpd service
ENTRYPOINT ["/usr/local/bin/run-vsftpd.sh"]
