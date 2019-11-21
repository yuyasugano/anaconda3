FROM debian:buster-slim

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

RUN apt-get update --fix-missing && \
    apt-get install -y wget bzip2 ca-certificates libglib2.0-0 libxext6 libsm6 libxrender1 git mercurial subversion gcc make && \
    apt-get clean

RUN wget --quiet https://repo.anaconda.com/archive/Anaconda3-2019.07-Linux-x86_64.sh -O ~/anaconda.sh && \
    /bin/bash ~/anaconda.sh -b -p /opt/conda && \
    rm ~/anaconda.sh && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate base" >> ~/.bashrc && \
    find /opt/conda/ -follow -type f -name '*.a' -delete && \
    find /opt/conda/ -follow -type f -name '*.js.map' -delete && \
    /opt/conda/bin/conda clean -afy
RUN wget --quiet http://prdownloads.sourceforge.net/ta-lib/ta-lib-0.4.0-src.tar.gz -O ~/ta-lib-0.4.0-src.tar.gz && \
    tar xvf ~/ta-lib-0.4.0-src.tar.gz && \
    cd ta-lib && \
    ./configure --prefix=/usr && \
    make && make install
SHELL ["/bin/bash", "-l", "-c"]
RUN pip install git+https://github.com/bitbankinc/python-bitbankcc.git TA-Lib backtesting pandas-highcharts mpl_finance optuna && \
    mkdir /opt/notebooks && /opt/conda/bin/conda install jupyter -y --quiet && /opt/conda/bin/conda install -c anaconda py-xgboost -y --quiet
ADD docker-entrypoint.sh ./
RUN ["chmod", "+x", "/docker-entrypoint.sh"]
VOLUME /opt/notebooks
ENTRYPOINT ["/docker-entrypoint.sh"]

