FROM debian:latest
MAINTAINER "Dongliang Mu" <dzm91@hust.edu.cn>
RUN apt-get -y update && apt-get -y upgrade && apt-get install -y make git
RUN git clone https://gitee.com/dzm91_hust/hustmirror-cli
WORKDIR hustmirror-cli
RUN make; ./output/hustmirror.sh
RUN apt-get clean
CMD apt-get -y update
