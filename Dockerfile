FROM ubuntu:20.04
RUN apt update -y

RUN apt install wget gnupg lsb-release -y
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" | tee  /etc/apt/sources.list.d/pgdg.list

RUN apt update -y

ENV TZ=Africa/Nairobi
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt install -y vim less build-essential postgresql-12 postgresql-plperl-12 libdbix-safe-perl libdbd-pg-perl

RUN mkdir -p /var/run/bucardo
RUN mkdir -p /var/log/bucardo

RUN wget https://bucardo.org/downloads/Bucardo-5.6.0.tar.gz
RUN tar -xvf Bucardo-5.6.0.tar.gz
RUN cd Bucardo-5.6.0 && perl Makefile.PL && make install

RUN bucardo --version

ADD startup.sh /startup.sh
ADD commands.sql /commands.sql
ADD pg_hba.conf /etc/postgresql/12/main/pg_hba.conf
RUN chown postgres:postgres /etc/postgresql/12/main/pg_hba.conf

# for bucardo to connect to the db
#ADD bucardorc /etc/bucardorc

CMD ["/startup.sh"]
