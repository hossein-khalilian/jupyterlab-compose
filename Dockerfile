FROM quay.io/jupyter/minimal-notebook:2025-03-03

# Switch to root
USER root

# Install needed system packages
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
        sudo \
        telnet \
        iputils-ping \
        gcc \
        pipx \
        ffmpeg \
        sqlite3 \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# Copy install script and requirement files
COPY requirements.txt /tmp/requirements.txt
COPY themes /themes

# Install Python dependencies in single layer
RUN pip install /themes/*.whl \
 && pip install -r /tmp/requirements.txt

# Configure sudo access for jovyan
RUN usermod -aG sudo jovyan \
 && echo 'jovyan ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/jovyan \
 && chmod 440 /etc/sudoers.d/jovyan

# Switch back to default user
USER jovyan
WORKDIR /home/jovyan

RUN pipx ensurepath
