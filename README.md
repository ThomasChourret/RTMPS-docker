## Installation

1. Install the dependencies
2. Clone the repository
3. Configure the server
4. Build the server
5. Run the server

### 1. Install the dependencies
```bash
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

# Install Docker:
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

### 2. Clone the repository

```bash
git clone https://github.com/ThomasChourret/RTMPS-docker.git
cd RTMPS-docker
```

### 3. Configure the server

- Set your keys in the keys.txt file.
- Set allowed IP addresses to play the stream in the ips.txt file.
- Set your SSL certificate in the ssl directory.

```bash
mkdir ssl
cp /path/to/your/certificate.crt ssl/server.crt
cp /path/to/your/private.key ssl/server.key
```
### 4. Build the server

```bash
docker build -t secure-rtmps-server .
```

### 5. Run the server

```bash
docker run -p 443:443 secure-rtmps-server
```

## Usage

- To stream to the server, use the following URL: rtmps://your-server-ip/live (Don't forget to specify the key in the stream settings)
- To view the stream, use the following URL: rtmps://your-server-ip/live/key
> Replace your-server-ip with your server's IP address and key with the key you set in the keys.txt file.

Example of configuration in OBS Studio : [https://prnt.sc/IeOOzgyZ5pXf](https://prnt.sc/IeOOzgyZ5pXf)