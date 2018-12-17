# Crown Marketplace

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

```
$ yarn install
$ bundle
```

To create the database:

```
$ rake db:create
```

### Environment variables

The application uses the [`dotenv-rails` gem][dotenv-rails] to manage
environment variables in `development` and `test` Rails environments which are
stored in `.env.*` files in the project's root directory. See the gem's
documentation for an explanation of the precedence of the various files.

Environment variables for the `production` Rails environment are currently
obtained from the [AWS Systems Manager Parameter Store][aws-parameter-store].

* `GOOGLE_GEOCODING_API_KEY`
  * You can obtain an API key for development [from Google][geocoding-key]

#### Cognito

* `COGNITO_USER_POOL_SITE`
  * Obtained from "App integration > Domain name" of the AWS Cognito User Pool
  * Leave this blank in development to configure both Cognito & DfE Sign-in to
    use OmniAuth test mode.
* `COGNITO_USER_POOL_ID`
  * Obtained from the "General settings" of the AWS Cognito User Pool
* `COGNITO_CLIENT_ID`
  * Obtained from the "General settings > App clients" of the AWS Cognito User
    Pool
* `COGNITO_CLIENT_SECRET`
  * Obtained from the "General settings > App clients" of the AWS Cognito User
    Pool
* `COGNITO_AWS_REGION`
  * The AWS region the Cognito User Pool was created in
* `SUPPLY_TEACHERS_COGNITO_ENABLED`
  * If present, enable the Cognito sign-in link on the Supply Teachers gateway
    page

#### DfE Sign-in

* `DFE_SIGNIN_URL`
  * Obtained from DfE Sign-in. Should have just `/` as a path component, e.g.
    `https://signin.example.com/`.
* `DFE_SIGNIN_CLIENT_ID`
  * Obtained from DfE Sign-in.
* `DFE_SIGNIN_CLIENT_SECRET`
  * Obtained from DfE Sign-in.
* `DFE_SIGNIN_REDIRECT_URI`
  * A link to the authentication callback in this application, i.e.
    `https://marketplace.service.crowncommercial.gov.uk/auth/dfe/callback` for
    the live service
* `DFE_SIGNIN_WHITELISTED_EMAIL_ADDRESSES`
  * Comma-separated list of email addresses allowed access via DfE Sign-in
  * If this variable is not present, DfE Sign-in is not protected by
    whitelisting

#### Google Analytics

* `GA_TRACKING_ID`
  * Google Analytics is disabled if this is not set

#### Upload URL protection

HTTP Basic Authentication credentials. Only needed in production environments.
See the [Uploading data section](#uploading-data) below.

* `HTTP_BASIC_AUTH_NAME`
* `HTTP_BASIC_AUTH_PASSWORD`

If the following environment variable is set then the app exposes routes for
uploading supplier data JSON. Otherwise those routes do not exist and users
receive a 404.

* `APP_HAS_UPLOAD_PRIVILEGES`

#### Database

The following are used to configure the database, but only in production
environments:

* `CCS_DEFAULT_DB_HOST`
* `CCS_DEFAULT_DB_PORT`
* `CCS_DEFAULT_DB_NAME`
* `CCS_DEFAULT_DB_USER`
* `CCS_DEFAULT_DB_PASSWORD`

## Run

Execute the following command:

```
$ rails s
```

Visit [localhost:3000](http://localhost:3000).

## Uploading data

You can upload data for a given framework using the following command where
`FRAMEWORK_NAME` is one of `supply-teachers`, `facilities-management` or
`management-consultancy`; `SCHEME` is one of `http` (local development) or
`https` (other environments); `HTTP_BASIC_AUTH_NAME` &
`HTTP_BASIC_AUTH_PASSWORD` credentials (only needed for production
environments):

```
$ git clone git@github.com:Crown-Commercial-Service/crown-marketplace-data.git
$ cd crown-marketplace-data/$FRAMEWORK_NAME
$ curl --user $HTTP_BASIC_AUTH_NAME:$HTTP_BASIC_AUTH_PASSWORD --request POST \
  --header "Content-Type: application/json" --data @output/data.json \
  $SCHEME://$HOST/$FRAMEWORK_NAME/uploads
```

### Audit trail

The application keeps a record of each *successful* upload in the database. So,
for example, the time of the most recent upload for a framework can be obtained
using the Rails console with one of the following commands:

* `FacilitiesManagement::Upload.order(:created_at).last.created_at`
* `ManagementConsultancy::Upload.order(:created_at).last.created_at`
* `SupplyTeachers::Upload.order(:created_at).last.created_at`

## Regenerating error pages

We use the [juice][] npm package to generate HTML error pages from the live
service, inlining all CSS, images, web fonts, etc. A Rake task makes this
easier:

```
$ rake 'error_pages[http://localhost:3000]'
```

This will pull down /errors/404.html, for example, and save an inlined copy in
public/404.html

## Development

### Linting

* The [rubocop][] & [rubocop-rspec][] gems are used to enforce standard coding
  styles.
* Some custom "cops" have been defined in [`lib/cop`][lib-cop].
* Some "cops" in the standard configuration have been disabled or adjusted in
  [`.rubocop.yml`][rubocop-yml].
* Rubocop linting is run as part of the default Rake task, but can be run
  individually using `rake rubocop`.

### Testing

* There is an automated RSpec-based test suite.
* The [factory_bot_rails][] gem is used to build valid models for testing.
* The [faker][] gem is used to generate realistic, but random test data of
  various types.
* I18n translations are used in specs to reduce their sensitivity to copy
  changes.
* [RSpec feature specs][feature-specs] are used for acceptance testing.
* All the specs are run as part of the default Rake task, but the standard
  RSpec-provided Rake tasks also exist for running sub-groups of the specs.

[geocoding-key]: https://console.developers.google.com/flows/enableapi?apiid=geocoding_backend&keyType=SERVER_SIDE
[juice]: https://www.npmjs.com/package/juice
[dotenv-rails]: https://github.com/bkeepers/dotenv
[aws-parameter-store]: https://docs.aws.amazon.com/systems-manager/latest/userguide/systems-manager-paramstore.html
[rubocop]: https://github.com/rubocop-hq/rubocop
[rubocop-rspec]: https://github.com/rubocop-hq/rubocop-rspec
[lib-cop]: https://github.com/Crown-Commercial-Service/crown-marketplace/tree/master/lib/cop
[rubocop-yml]: https://github.com/Crown-Commercial-Service/crown-marketplace/blob/master/.rubocop.yml
[feature-specs]: https://github.com/Crown-Commercial-Service/crown-marketplace/tree/master/spec/features
[factory_bot_rails]: https://github.com/thoughtbot/factory_bot_rails
