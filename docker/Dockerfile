FROM continuumio/miniconda3
# Use bash instead of sh
SHELL ["/bin/bash", "-c"]
# Install sudo and git
RUN apt-get update && apt-get -y install sudo git-core vim nano
# Copy env file
ADD environment.yml environment.yml
# Copy notebook config file
ADD notebook_config.py notebook_config.py
# Install conda packages
RUN conda env update -n base --file environment.yml
# Install HiMAT
RUN git clone https://github.com/NASA-Planetary-Science/HiMAT.git
RUN cd HiMAT && pip install -e .
# Switch to non-root user
RUN useradd --create-home -s /bin/bash jupyter && adduser jupyter sudo
WORKDIR /home/jupyter
# USER jupyter
