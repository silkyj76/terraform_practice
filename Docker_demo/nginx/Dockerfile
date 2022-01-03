 FROM ubuntu:latest
 MAINTAINER Dylan Galland dylan.galland@pearson.com

 RUN apt-get -qq update && apt-get install -qq -y software-properties-common
 RUN add-apt-repository -y ppa:nginx/stable && apt-get -qq -y update
 RUN apt-get install -qq -y nginx
 