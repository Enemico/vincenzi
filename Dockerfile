# Latest version of ubuntu
FROM nvidia/cuda:9.0-base

# Default git repository
ENV GIT_REPOSITORY https://github.com/fireice-uk/xmr-stak.git
ENV XMRSTAK_CMAKE_FLAGS -DXMR-STAK_COMPILE=generic -DCUDA_ENABLE=ON -DOpenCL_ENABLE=OFF -DMICROHTTPD_ENABLE=OFF -DXMR-STAK_COMPILE=generic -DXMR-STAK_CURRENCY=monero

# Innstall packages
RUN apt-get update \
    && set -x \
    && apt-get install -y software-properties-common apt-utils \
    && add-apt-repository -y ppa:deadsnakes/ppa \
    && apt-get update \
    && apt-get install -qq -y python3.6 tzdata ca-certificates cmake cuda-core-9-0 git cuda-cudart-dev-9-0 libhwloc-dev libmicrohttpd-dev libssl-dev zsh \
    && rm -f /etc/localtime \
    && ln -s /usr/share/zoneinfo/Europe/Oslo /etc/localtime \
    && useradd -ms /usr/bin/zsh vincenzi

USER vincenzi
WORKDIR /home/vincenzi
COPY ./service service

RUN git clone $GIT_REPOSITORY
COPY ./service/donate-level.hpp /xmr-stak/xmr-stak/donate-level.hpp

RUN cd xmr-stak \
    && cmake ${XMRSTAK_CMAKE_FLAGS} . \
    && make


USER root
RUN apt-get purge -y -qq cmake cuda-core-9-0 git cuda-cudart-dev-9-0 libhwloc-dev libmicrohttpd-dev libssl-dev \
    && apt-get clean -qq

# ENTRYPOINT ["/usr/local/bin/xmr-stak"]

USER vincenzi
WORKDIR /home/vincenzi
RUN cat /proc/cpuinfo | grep processor
CMD [ "python3.6 -u" "./service/vincenzi.py" ]

