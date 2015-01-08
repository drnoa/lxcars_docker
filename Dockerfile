FROM drnoa/kivitendo-docker:latest

MAINTAINER Daniel Binggeli <db@xbe.ch>

#Packages 
RUN apt-get update
RUN apt-get -y upgrade

RUN DEBIAN_FRONTEND=noninteractive apt-get -y install libphp-snoopy libpqxx3-dev  postgresql-contrib

# Kivitendo Git Repo clonen
RUN git clone https://github.com/Ciatronical/lxcars.git /var/www/kivitendo-erp/lxcars

RUN chown -R www-data:www-data /var/www
RUN chmod u+rwx,g+rx,o+rx /var/www
RUN find /var/www -type d -exec chmod u+rwx,g+rx,o+rx {} +
RUN find /var/www -type f -exec chmod u+rw,g+rw,o+r {} +

#Kivitendo rights
RUN chown -R www-data /var/www/kivitendo-erp/users /var/www/kivitendo-erp/spool /var/www/kivitendo-erp/webdav
RUN chown www-data /var/www/kivitendo-erp/templates /var/www/kivitendo-erp/users
RUN chmod -R +x /var/www/kivitendo-erp/

RUN    /etc/init.d/postgresql start && cd /var/www/kivitendo-erp/lxcars && ./scripts/install.sh 

RUN chmod +x /usr/local/bin/*.sh
# By default, simply start apache & postgres.
CMD ["/usr/local/bin/start.sh"]
