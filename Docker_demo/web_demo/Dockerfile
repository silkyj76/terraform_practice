FROM ubuntu:18.04
MAINTAINER Dylan Galland dylan.galland@pearson.com

RUN apt-get -y update
RUN apt-get -y install apache2

COPY . /web 

WORKDIR /web/

EXPOSE 8080

CMD ["/etc/init.d/apache2","-D","FOREGROUND"]
