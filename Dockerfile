FROM quay.io/jupyter/minimal-notebook:2025-03-03

# Switch to root
USER root
RUN apt update && apt install telnet iputils-ping proxychains4 gcc sudo -y
RUN sed -i 's/^socks4[[:space:]]\+127\.0\.0\.1[[:space:]]\+9050/socks5 172.18.0.1 1081/' /etc/proxychains4.conf

# Copy install script and requirement files
COPY install.sh /tmp/install.sh
COPY requirements.txt /tmp/requirements.txt
COPY packages.txt /tmp/packages.txt
COPY themes /themes

# Run install script
RUN bash /tmp/install.sh

RUN usermod -aG sudo jovyan
RUN echo 'jovyan:changethis' | chpasswd
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Switch back to default user
USER jovyan
WORKDIR /home/jovyan
