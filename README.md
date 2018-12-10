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

#### Cognito

* `COGNITO_USER_POOL_SITE`
  * If this is not set in development, both Cognito & DfE Signin
    are configured to use OmniAuth test mode.
* `COGNITO_USER_POOL_ID`
* `COGNITO_CLIENT_ID`
* `COGNITO_CLIENT_SECRET`
* `COGNITO_AWS_REGION`

#### DfE Signin

* `DFE_SIGNIN_URL`
* `DFE_SIGNIN_CLIENT_ID`
* `DFE_SIGNIN_CLIENT_SECRET`
* `DFE_SIGNIN_REDIRECT_URI`
* `DFE_SIGNIN_WHITELISTED_EMAIL_ADDRESSES`
  * Comma-separated list of email addresses allowed access via DfE Signin
  * Defaults to an empty list, i.e. nobody has access

#### Google Analytics

* `GA_TRACKING_ID`
  * Google Analytics is disabled if this is not set

#### Credentials protecting data upload URLs

HTTP Basic Authentication credentials. Only needed in production environments.
See the [Importing data section](#importing-data) below.

* `HTTP_BASIC_AUTH_NAME`
* `HTTP_BASIC_AUTH_PASSWORD`

#### Database

The following are used to configure the database, but only in
production environments:

* `CCS_DEFAULT_DB_HOST`
* `CCS_DEFAULT_DB_PORT`
* `CCS_DEFAULT_DB_NAME`
* `CCS_DEFAULT_DB_USER`
* `CCS_DEFAULT_DB_PASSWORD`

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

You can import data for a given framework using the following command where `FRAMEWORK_NAME` is one of `supply-teachers`, `facilities-management` or `management-consultancy`; `SCHEME` is one of `http` (local development) or `https` (other environments); `HTTP_BASIC_AUTH_NAME` & `HTTP_BASIC_AUTH_PASSWORD` credentials (only needed for production environments):

```
$ git clone git@github.com:Crown-Commercial-Service/crown-marketplace-data.git
$ cd crown-marketplace-data/$FRAMEWORK_NAME
$ curl --user $HTTP_BASIC_AUTH_NAME:$HTTP_BASIC_AUTH_PASSWORD --request POST --header "Content-Type: application/json" --data @output/data.json $SCHEME://$HOST/$FRAMEWORK_NAME/uploads
```

### Audit trail

The application keeps a record of each *successful* upload in the database. So, for example, the time of the most recent upload for a framework can be obtained using the Rails console with one of the following commands:

* `FacilitiesManagement::Upload.order(:created_at).last.created_at`
* `ManagementConsultancy::Upload.order(:created_at).last.created_at`
* `SupplyTeachers::Upload.order(:created_at).last.created_at`

### Regenerating Error Pages

We use [juice](juice) to generate HTML error pages from the live service, inlining all css, images, webfonts, etc.

A rake task makes this easier:
```
$ rake 'error_pages[http://localhost:3000]'
```

This will pull down /errors/404.html, for example, and save an inlined copy in public/404.html

[geocoding-key]: https://console.developers.google.com/flows/enableapi?apiid=geocoding_backend&keyType=SERVER_SIDE
[juice]: https://www.npmjs.com/package/juice
