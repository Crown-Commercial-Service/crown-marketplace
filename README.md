# Crown Marketplace

[![Build Status](https://travis-ci.org/Crown-Commercial-Service/crown-marketplace.svg?branch=master)](https://travis-ci.org/Crown-Commercial-Service/crown-marketplace)

## Prerequisites

### Ubuntu

```
sudo apt install postgresql
sudo apt install postgresql-{postgresql-version}-postgis-{postgis-version}
```

### MacOS

```
brew install postgis
```

## Set up

To install dependencies:

    $ yarn install
    $ bundle

To create the database:

    $ rake db:create

### Environment variables

* `GOOGLE_GEOCODING_API_KEY`
  * You can obtain an API key for development [from Google][geocoding-key]
  * Add it to your `.env.local` file which is ignored by git

#### Production environments

Credentials for HTTP Basic Authentication:

* `HTTP_BASIC_AUTH_NAME`
* `HTTP_BASIC_AUTH_PASSWORD`

## Run

    $ rails s

Visit [localhost:3000](http://localhost:3000).

## Docker

The Dockerfile configures the Rails app to run in production.

    # Build image
    $ docker build \
    -t crown-marketplace-production \
    .

    # Run server
    $ docker run \
    -p8080:8080 \
    --env GOOGLE_GEOCODING_API_KEY=<key> \
    --env SECRET_KEY_BASE=<key> \
    --env CCS_DEFAULT_DB_HOST=<database-host> \
    --env CCS_DEFAULT_DB_PORT=<database-port> \
    --env CCS_DEFAULT_DB_NAME=<database-name> \
    --env CCS_DEFAULT_DB_USER=<database-username> \
    --env CCS_DEFAULT_DB_PASSWORD=<database-password> \
    crown-marketplace-production

NOTE. You can set `CCS_DEFAULT_DB_HOST` to `docker.for.mac.localhost` to connect to a database running on your host machine.

## Importing data

### Supply teacher data

```
$ git clone git@github.com:Crown-Commercial-Service/crown-marketplace-data.git
$ cd crown-marketplace-data/supply-teachers
$ curl --user $HTTP_BASIC_AUTH_NAME:$HTTP_BASIC_AUTH_PASSWORD --request POST --header "Content-Type: application/json" --data @output/data.json $SCHEME://$HOST/supply-teachers/uploads
```
### Facilities management data

```
$ git clone git@github.com:Crown-Commercial-Service/crown-marketplace-data.git
$ cd crown-marketplace-data/facilities-management
$ curl --user $HTTP_BASIC_AUTH_NAME:$HTTP_BASIC_AUTH_PASSWORD --request POST --header "Content-Type: application/json" --data @output/data.json $SCHEME://$HOST/facilities-management/uploads
```

### Management consultancy data

```
$ git clone git@github.com:Crown-Commercial-Service/crown-marketplace-data.git
$ cd crown-marketplace-data/management-consultancy
$ curl --user $HTTP_BASIC_AUTH_NAME:$HTTP_BASIC_AUTH_PASSWORD --request POST --header "Content-Type: application/json" --data @output/data.json $SCHEME://$HOST/management-consultancy/uploads
```

[geocoding-key]: https://console.developers.google.com/flows/enableapi?apiid=geocoding_backend&keyType=SERVER_SIDE
