FROM ubuntu:18.04

ENV TZ=Europe/Warsaw
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone 

RUN apt update && apt install -y \
  unzip \
  wget \
  vim \
  git \
	curl \
  graphviz


#Java8

RUN apt-get update && \
	apt-get install -y openjdk-8-jdk && \
	apt-get install -y ant && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/* && \
	rm -rf /var/cache/oracle-jdk8-installer;

RUN apt-get update && \
	apt-get install -y ca-certificates-java && \
	apt-get clean && \
	update-ca-certificates -f && \
	rm -rf /var/lib/apt/lists/* && \
	rm -rf /var/cache/oracle-jdk8-installer;

ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/
RUN export JAVA_HOME


#Scala 2.12.8

RUN wget https://downloads.lightbend.com/scala/2.12.8/scala-2.12.8.deb
RUN dpkg -i scala-2.12.8.deb

#sbt

ARG SBT_VERSION=1.3.8

RUN \
  curl -L -o sbt-$SBT_VERSION.deb https://dl.bintray.com/sbt/debian/sbt-$SBT_VERSION.deb && \
  dpkg -i sbt-$SBT_VERSION.deb && \
  rm sbt-$SBT_VERSION.deb && \
  apt-get update && \
  apt-get install sbt && \
  sbt sbtVersion

#npm 6.8

RUN apt-get install -y nodejs
RUN curl -L https://www.npmjs.com/install.sh | sh

RUN npm install -g npm@6.8.0


EXPOSE 9000
EXPOSE 8000
EXPOSE 5000
EXPOSE 8888


RUN useradd -ms /bin/bash achwastek
RUN adduser achwastek sudo

USER achwastek
WORKDIR /home/achwastek/
RUN mkdir /home/achwastek/projekt/

#volume

VOLUME /home/achwastek/projekt/


CMD ["/bin/bash"]
