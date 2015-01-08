FROM drnoa/kivitendo_docker

MAINTAINER Daniel Binggeli <db@xbe.ch>

#Packages 
RUN apt-get update
RUN apt-get -y upgrade

RUN DEBIAN_FRONTEND=noninteractive apt-get -y install libphp-snoopy libpqxx3-dev  postgresql-contrib

# Kivitendo Git Repo clonen
RUN git clone https://github.com/Ciatronical/lxcars /var/www/kivitendo-erp/

 



