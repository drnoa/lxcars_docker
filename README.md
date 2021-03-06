lxcars_docker
================

Docker Build for Kivitendo with lxcars a erp solution for car repair business


# Table of Contents

- [Introduction](#introduction)
- [Changelog](Changelog.md)
- [Contributing](#contributing)
- [Reporting Issues](#reporting-issues)
- [Installation](#installation)
- [Quick Start](#quick-start)
- [Creating User and Database at Launch](creating-user-and-database-at-launch)
- [Configuration](#configuration)
    - [Data Store](#data-store)
- [Upgrading](#upgrading)

# Introduction

Dockerfile to build a Lxcars container image which can be linked to other containers.
Lxcars is based on Kivitendo. The docker image inherits from kivitendo_docker.
Will install Postgres and Apache2 and all the necessary packages for Kivitendo and lxcars.

# Contributing

If you find this image useful here's how you can help:

- Send a Pull Request with your awesome new features and bug fixes
- Help new users with [Issues](https://github.com/drnoa/lxcars_docker/issues) they may encounter

# Reporting Issues

Docker is a relatively new project and is active being developed and tested by a thriving community of developers and testers and every release of docker features many enhancements and bugfixes.

Given the nature of the development and release cycle it is very important that you have the latest version of docker installed because any issue that you encounter might have already been fixed with a newer docker release.

For ubuntu users I suggest [installing docker](https://docs.docker.com/installation/ubuntulinux/) using docker's own package repository since the version of docker packaged in the ubuntu repositories are a little dated.

Here is the shortform of the installation of an updated version of docker on ubuntu.

```bash
sudo apt-get remove docker docker-engine docker.io
sudo apt-get update
sudo apt-get install docker-ce
```


# Installation

Pull the latest version of the image from the docker index. This is the recommended method of installation as it is easier to update image in the future. These builds are performed by the **Docker Trusted Build** service.

```bash
docker pull drnoa/lxcars_docker:latest
```

Alternately you can build the image yourself.

```bash
git clone https://github.com/drnoa/lxcars_docker.git
cd kivitendo_docker
docker build -t="$USER/lxcars_docker" .
```

# Quick Start

Run the Kivitendo image

```bash
docker run --name lxcars_docker -d drnoa/lxcars_docker:latest
```
Check the ip of your docker container
```
```

Got to the administrative interface of kivitendo using the password: admin123 and configure the database. All database users (kivitendo and docker) use docker as password.


The webserver is configured to use port 80
Postgres is reachable on port 5432

Last steps to complete the installation:
Under CRM->Admin create the groups Admin and Werkstatt and add one user to each of them.

Alternately you can fetch the password set for the `postgres` user from the container logs.

```bash
docker logs postgresql
```

In the output you will notice the following lines with the password:

```bash
|------------------------------------------------------------------|
| PostgreSQL User: postgres, Password: xxxxxxxxxxxxxx              |
|                                                                  |
| To remove the PostgreSQL login credentials from the logs, please |
| make a note of password and then delete the file pwfile          |
| from the data store.                                             |
|------------------------------------------------------------------|
```

To test if the postgresql server is working properly, try connecting to the server.

```bash
psql -U postgres -h $(docker inspect --format {{.NetworkSettings.IPAddress}} postgresql)
```

# Configuration

## Data Store

For data persistence a volume should be mounted at `/var/lib/postgresql`.

The updated run command looks like this.

```bash
docker run --name postgresql -d \
  -v /opt/postgresql/data:/var/lib/postgresql drnoa/lxcars_docker:latest
```

This will make sure that the data stored in the database is not lost when the image is stopped and started again.

## Securing the server

By default 'docker' is assigned as password for the postgres user. 

You can change the password of the postgres user
```bash
psql -U postgres -h $(docker inspect --format {{.NetworkSettings.IPAddress}} postgresql)
\password postgres
```


# Upgrading

To upgrade to newer releases, simply follow this 3 step upgrade procedure.

- **Step 1**: Stop the currently running image

```bash
docker stop $USER/lxcars_docker
```

- **Step 2**: Update the docker image.

```bash
docker pull drnoa/lxcars_docker:latest
```

- **Step 3**: Start the image

```bash
docker run --name lxcars_docker -d [OPTIONS] drnoa/lxcars_docker:latest
```
