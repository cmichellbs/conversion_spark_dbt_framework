FROM python:3.9.16-bullseye

USER root

RUN apt-get -y upgrade && apt-get -y update 

RUN apt-get install -y wget

RUN apt-get update && apt-get install -y git libpq-dev python-dev python3-pip libpq5

RUN apt-get install -y apt-utils

RUN cd /opt

RUN wget http://archive.ubuntu.com/ubuntu/pool/main/g/glibc/multiarch-support_2.27-3ubuntu1.6_amd64.deb

RUN apt-get install ./multiarch-support_2.27-3ubuntu1.6_amd64.deb

RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -

RUN curl https://packages.microsoft.com/config/debian/10/prod.list > /etc/apt/sources.list.d/mssql-release.list

RUN apt-get install -y unixodbc

RUN apt-get install -y libodbc1

RUN apt-get install -y odbcinst1debian2

RUN apt-get install -y unixodbc-dev

RUN apt-get install -y libgssapi-krb5-2

RUN echo msodbcsql18 msodbcsql/ACCEPT_EULA boolean true | debconf-set-selections

RUN apt-get -y update 

RUN apt-get -y install manpages-dev

RUN apt-get install -y default-jdk

RUN apt-get install -y msodbcsql18 

# optional: for bcp and sqlcmd
RUN ACCEPT_EULA=Y apt-get install -y mssql-tools18 

RUN  echo 'export PATH="$PATH:/opt/mssql-tools18/bin"' >> ~/.bashrc 

# optional: for unixODBC development headers

# optional: kerberos library for debian-slim distributions

RUN echo 'export DBT_PROFILES_DIR=/opt/migration/.dbt' >> /root/.bashrc

RUN echo 'export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64' >> /root/.bashrc

RUN pip install --upgrade pip

RUN mkdir /opt/migration

ADD ./ /opt/migration/

RUN pip install -r /opt/migration/requirements.txt


ENTRYPOINT ["tail", "-f", "/dev/null"]