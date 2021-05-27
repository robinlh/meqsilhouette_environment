FROM kernsuite/base:dev

# create user and application directory
RUN useradd --create-home --shell /bin/bash meqsil_user
WORKDIR /home/meqsil_user

# to avoid interaction when installing software
ENV DEBIAN_FRONTEND=noninteractive

# install utility packages and repositories
RUN apt-get update -y
RUN apt-get install -y wget vim python-pip gcc python unzip git time
     
RUN apt-get install -y build-essential cmake gfortran g++ libncurses5-dev \
        libreadline-dev flex bison libblas-dev liblapacke-dev libcfitsio-dev \
        wcslib-dev libfftw3-dev libhdf5-serial-dev \
        libboost-python-dev libboost-program-options-dev libboost-program-options1.65.1 \
        libboost-program-options1.65-dev libpython2.7-dev libxml2-dev libxslt1-dev \
        texlive-latex-extra texlive-fonts-recommended dvipng

# build aatm manually
RUN wget -c https://launchpad.net/aatm/trunk/0.5/+download/aatm-0.5.tar.gz
RUN tar -xzf aatm-0.5.tar.gz
RUN cd aatm-0.5 && ./configure && make && make install

# install kern 6
RUN apt-get install -y software-properties-common
RUN add-apt-repository -s ppa:kernsuite/kern-6
RUN apt-add-repository multiverse
RUN apt-add-repository restricted

# install required packages in order specified by documentation (simms manual install in the middle)
RUN apt-get install -y \
    meqtrees \
    meqtrees-timba \
    tigger \
    tigger-lsm \
    python-astro-tigger \
    python-astro-tigger-lsm \
    casalite \
    wsclean \
    pyxis \
    python-casacore

RUN apt-get clean
    
# install non-standard python libraries
RUN pip install --no-cache-dir --upgrade \
        mpltools \
        seaborn \
        astLib \
        astropy \
        termcolor \
        numpy \
        matplotlib \
        pyfits \
        simms

USER meqsil_user

# to get variables from docker-compose
ARG INPUT_FILE
ENV INPUT_FILE ${INPUT_FILE}

# clone meqSil repo
RUN git clone --depth 1 --branch v2.6.1 https://github.com/rdeane/MeqSilhouette.git
COPY ./data/ /home/meqsil_user/data


# environment    
ENV MEQTREES_CATTERY_PATH=/usr/lib/python2.7/dist-packages/Cattery
ENV PATH=/usr/local/bin:$PATH
ENV PYTHONPATH=/home/meqsil_user/MeqSilhouette:/usr/lib/python2.7/dist-packages 
ENV MEQS_DIR=/home/meqsil_user/MeqSilhouette
ENV LC_ALL=C

# TESTING
# COPY test_input.py ${MEQS_DIR}/

# ENTRYPOINT ["python", "/home/meqsil_user/MeqSilhouette/test_input.py", "/home/meqsil_user/data/test.json"]
# ENTRYPOINT ["/bin/bash", "-c", "python ${MEQS_DIR}/test_input.py /home/meqsil_user/data/${INPUT_FILE}"]
ENTRYPOINT ["/bin/bash", "-c", "python ${MEQS_DIR}/driver/run_meqsilhouette.py /home/meqsil_user/data/${INPUT_FILE}"]