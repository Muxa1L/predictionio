FROM java:openjdk-8-jdk-alpine
MAINTAINER Mikhail Davydenko

ENV PIO_VERSION 0.12.0
ENV SPARK_VERSION 2.1.1
#ENV ELASTICSEARCH_VERSION 1.4.4
#ENV HBASE_VERSION 1.0.0

ENV PIO_HOME /PredictionIO-${PIO_VERSION}-incubating
ENV PATH=${PIO_HOME}/bin:$PATH
ENV JAVA_HOME /usr/lib/jvm/java-1.8-openjdk
RUN apk --no-cache add curl bash coreutils
RUN apk --no-cache add mariadb mariadb-client

RUN curl -O http://apache-mirror.rbc.ru/pub/apache/incubator/predictionio/${PIO_VERSION}-incubating/apache-predictionio-${PIO_VERSION}-incubating.tar.gz \
    && mkdir ${PIO_HOME} \
    && tar -xzf apache-predictionio-${PIO_VERSION}-incubating.tar.gz -C ${PIO_HOME} \
    && rm apache-predictionio-${PIO_VERSION}-incubating.tar.gz \
    && cd ${PIO_HOME} \
    && ./make-distribution.sh
#RUN tar zxvf /apache-predictionio-${PIO_VERSION}-incubating/PredictionIO-${PIO_VERSION}-incubating.tar.gz -C /
#RUN rm -r /apache-predictionio-${PIO_VERSION}-incubating
RUN mkdir /${PIO_HOME}/vendors
COPY files/pio-env.sh ${PIO_HOME}/conf/pio-env.sh

RUN curl -O http://d3kbcqa49mib13.cloudfront.net/spark-${SPARK_VERSION}-bin-hadoop2.6.tgz \
    && tar -xzf spark-${SPARK_VERSION}-bin-hadoop2.6.tgz -C ${PIO_HOME}/vendors \
    && rm spark-${SPARK_VERSION}-bin-hadoop2.6.tgz

#COPY files/hbase-site.xml ${PIO_HOME}/vendors/hbase-${HBASE_VERSION}/conf/hbase-site.xml
#RUN sed -i "s|VAR_PIO_HOME|${PIO_HOME}|" ${PIO_HOME}/vendors/hbase-${HBASE_VERSION}/conf/hbase-site.xml \
#    && sed -i "s|VAR_HBASE_VERSION|${HBASE_VERSION}|" ${PIO_HOME}/vendors/hbase-${HBASE_VERSION}/conf/hbase-site.xml
