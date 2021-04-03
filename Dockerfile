FROM ubuntu:20.04
RUN apt-get update && apt-get install -y \
	sudo \
	wget \
	vim

WORKDIR /opt
RUN wget https://repo.continuum.io/archive/Anaconda3-2020.02-Linux-x86_64.sh && \
	sh Anaconda3-2020.02-Linux-x86_64.sh -b -p /opt/anaconda3 && \
	rm -f Anaconda3-2020.02-Linux-x86_64.sh
ENV PATH /opt/anaconda3/bin:$PATH

RUN pip install --upgrade pip \
	dash

# plotlyを使うため、Node.jsをインストール
# https://github.com/nodesource/distributions/blob/master/README.md
RUN curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash - \
    && sudo apt-get install -y nodejs

# JupyterLabでplotlyをサポートする
ENV NODE_OPTIONS=--max-old-space-size=4096
RUN jupyter labextension install @jupyter-widgets/jupyterlab-manager@1.1 --no-build \
    && jupyter labextension install jupyterlab-plotly@1.4.0 --no-buil \
    && jupyter labextension install plotlywidget@1.4.0 --no-build \
    && jupyter lab build
ENV NODE_OPTIONS=