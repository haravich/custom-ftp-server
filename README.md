# FTP Server in Docker based on Alpine Linux

[![custom-ftp-server build](https://github.com/haravich/custom-ftp-server/actions/workflows/docker-publish.yml/badge.svg)](https://github.com/haravich/custom-ftp-server/actions/workflows/docker-publish.yml) ![Docker pulls](https://img.shields.io/docker/pulls/haravich/custom-ftp-server)

This repository contains a Docker configuration to set up an FTP server using the Alpine Linux base image. The FTP server supports the following modes
* FTP (Port 21)
* FTPS (Port 21) AKA Explicit
* FTPS Implicit (Port 990)
* FTPS TLS (Port 21) AKA Explicit with strong cipher

## Prerequisites

Before you begin, ensure you have the following installed:

- Docker: Follow the official [Docker installation guide](https://docs.docker.com/get-docker/) to install Docker on your system.

## Getting Started

1. **Clone the Repository**:

   Clone this repository to your local machine:

   ```bash
   git clone https://github.com/haravich/custom-ftp-server.git
   cd custom-ftp-server
   ```

2. **Customize Configuration**:

    Configure FTP Server:
    - Modify the `vsftpd-<FTP_MODE>.conf` file to customize the FTP server configuration. You can adjust settings such as user accounts, directory permissions, passive ports range, and security options.

    Default:
    - By default the `vsftpd.conf` is enabled with required configuration for specific modes.

3. **Generate SSL Certificate:**

    Generate an SSL certificate and private key for FTPS if you plan to use secure connections. We do apply a default certficate if the environment variable `SSL_SUBJECT` not provided.

    ```bash
    SSL_SUBJECT="/C=IN/O=haravich/CN=freeops.dev"
    ```

    If you have your own certificate, you can provide it. The file should contain the full certificate chain starting from the leaf and ending with the CA certificate, followed by the private key in PEM format.
    ```bash
    ... -e FTP_PEM=/tmp/tls/ftp.pem -v /tmp/tls:/tmp/tls ...
    ```
    (or)
    ```bash
    ... -e FTP_PEM="<value_of_pem> | $(cat /tmp/tls/*.pem)" ...
    ```
4. **Build and Run**:

    Build the Docker image and run the container:

    ```bash
    docker build -t custom-ftp-server .
    docker run -d -p 2222:22 -p 20-22:20-22 -p 21100-21110:21100-21110 -p 990:990 custom-ftp-server

    (or)

    docker run -d -p 2222:22 -e FTP_MODE=ftps -e -p 20-22:20-22 -p 21100-21110:21100-21110 -p 990:990 custom-ftp-server


    (or)

    docker run -d -p 2222:22 -e FTP_MODE=ftps -e SSL_SUBJECT="/C=IN/O=haravich/CN=freeops.dev" -p 20-22:20-22 -p 21100-21110:21100-21110 -p 990:990 custom-ftp-server
    ```

    ### Environment Variables

    | Variable | Default Value | Available Options |
    |----------|----------|----------|
    | FTP_USER | `ftpuser` | (string) `name` |
    | FTP_PASSWORD | `admin` | (string) `password` |
    | PASV_ENABLE | `YES` | (bool) `YES`/`NO` | 
    | PASV_ADDRESS | - |  (Valid IP Address) `x.x.x.x` |
    | PASV_ADDRESS_INTERFACE | `eth0` | (Vlaid ETH interface) `xth1` |
    | PASV_ADDR_RESOLVE | `YES` | (bool) `YES`/`NO` |
    | PASV_MIN_PORT | `21100` | (Port) `Any valid port` |
    | PASV_MAX_PORT | `21110` | (Port) `Any valid port` |
    | FTP_MODE | `ftp` | (string) `ftp`/`ftps`/`ftps_implicit`/`ftps_tls` |
    | LOG_STDOUT | `YES` | (bool) `YES`/`NO` |
    | SSL_SUBJECT | - | (string) `/C=IN/O=haravich/CN=freeops.dev` |
    | PEM_FILE | - | (string) `/tmp/tls/ftp.pem` |

## Access FTP Server:

Connect to the FTP server using an FTP client. Use the ftpuser username and the password. For secure FTPS connections, connect to port 21 and choose "FTP with TLS/SSL" or "FTPES" as the protocol.

```bash
ftp -p 22 <ftp_user>@localhost
```
Replace <ftp_user> with appropriate values.

## Customization
* Adjust the FTP server settings in the vsftpd file.
* Customize the run-vsftpd.sh script to modify for further configs.

## License
This project is licensed under the [MIT License](LICENSE.md). See the [LICENSE.md](LICENSE.md) file for details.
```
Copy and paste this Markdown content into a file named README.md in the root of your repository. Feel free to adjust the formatting and content as needed for your project.
```

## Credits

### lhauspie/docker-vsftpd-alpine

The core config files is created and maintained by [Logan HAUSPIE](https://github.com/lhauspie). The source code can be found in [Github](https://github.com/lhauspie/docker-vsftpd-alpine).

The original LICENSE can be found in [lhauspie/docker-vsftpd-alpine](https://github.com/lhauspie/docker-vsftpd-alpine/blob/develop/LICENCE)
