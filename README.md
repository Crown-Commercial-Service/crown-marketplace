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

This will pull down `/errors/404.html`, for example, and save an inlined copy in
`public/404.html`.

## Development

### Design & frontend

* The design of the app is closely based on the [GOV.UK Design System][] with
  some minor CCS-related variations.
* The project uses and extends the [GOV.UK Frontend][] npm package.
* The npm package dependencies are listed in `package.json`, installed using
  [yarn][], and the exact versions of all dependencies direct/indirect are
  locked in `yarn.lock`.
* The CSS follows [Block Element Modifier][] conventions.

### Code

The project is a fairly standard Rails web app. However, there are a few aspects
which are somewhat non-standard:

* The framework-specific routes and code are all isolated from each other using
  namespaces with some code shared across frameworks. In some ways the code for
  each framework could be considered as a mini web app in its own right and the
  intention is that it should be relatively easy to extract the code for one
  framework into a separate Rails app if that was deemed appropriate down the
  line.

* The supplier-related data for each framework is bulk uploaded over HTTPS to be
  stored in the database; the data is then effectively regarded as read-only.

* A bunch of other less-variable data is stored in CSV files in the code
  repository and made available to the application via classes including the
  `StaticRecord` concern, e.g. `Nuts3Region` which loads its data from
  `data/nuts3_regions.csv`.

* The user journey for each framework is made up of a series of questions which
  lead the user to an appropriate outcome. This workflow is modelled by a
  journey class which inherits from `GenericJourney`, a series of step
  classes which include the `Steppable` concern, and view templates
  corresponding to each step.

    * In conjunction with its steps, the journey is responsible for interpreting
      the query string parameters (generated by the answers to previous
      questions) and determining which is the current step.

    * Each step is responsible for determining which step comes next in the
      journey.

    * Most steps correspond to a question page with an HTML form and one or more
      HTML input elements; a few steps correspond to outcome pages, i.e. the
      final step in a journey.

    * Question-related step classes use the [virtus][] gem to define attributes
      matching the parameters supplied by the HTML form and
      [ActiveModel::Validations][] to define validation rules to constrain the
      values of those inputs.

### Authentication and authorisation

Authentication is implemented using
[OmniAuth](https://github.com/omniauth/omniauth), with two configured
providers:

* [Amazon Cognito](https://aws.amazon.com/cognito/)
* [DfE Sign-in](https://help.signin.education.gov.uk/contact)

Both of these require configuration using environment variables listed above.

Authorisation is implemented by the `Login::DfeLogin` and `Login::CognitoLogin`
classes.

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
* RSpec matchers from the [capybara][] gem are used throughout the specs to
  make assertions about rendered HTML.
* All the specs are run as part of the default Rake task, but the standard
  RSpec-provided Rake tasks also exist for running sub-groups of the specs.

### Continuous integration & deployment

* Continuous integration and deployment is implemented on the new AWS-based CCS
  infrastructure.
* The tests are run automatically when a new commit is pushed to a triggering
  branch of this repository on GitHub. This is achieved using
  [AWS CodePipeline][] and [AWS CodeBuild][].
* The `pipeline_pre_build_tests.sh` script is run to install everything that's
  needed to run the tests on the fairly vanilla CodeBuild container.
* The `pipeline_run_build_tests.sh` script is what actually runs the tests.
* If all the tests pass, then a container is built using the `Dockerfile` in
  this repo, uploaded to the [AWS Elastic Container Registry][], and deployed
  using [AWS Elastic Container Service][].
* Environment variables for the various containers running on the AWS
  infrastructure are obtained from the
  [AWS Systems Manager Parameter Store][aws-parameter-store].
* See the [CMpDevEnvironment][] repository, particularly the
  [Developer Guide][CMp Developer Guide], for more details.

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
[GOV.UK Frontend]: https://github.com/alphagov/govuk-frontend
[yarn]: https://github.com/yarnpkg/yarn
[GOV.UK Design System]: https://design-system.service.gov.uk/
[Block Element Modifier]: http://getbem.com/
[virtus]: https://github.com/solnic/virtus
[ActiveModel::Validations]: https://guides.rubyonrails.org/active_record_validations.html
[capybara]: https://github.com/teamcapybara/capybara
[AWS CodeBuild]: https://aws.amazon.com/codebuild/
[AWS CodePipeline]: https://aws.amazon.com/codepipeline/
[AWS Elastic Container Registry]: https://aws.amazon.com/ecr/
[AWS Elastic Container Service]: https://aws.amazon.com/ecs/
[CMpDevEnvironment]: https://github.com/Crown-Commercial-Service/CMpDevEnvironment
[CMp Developer Guide]: https://github.com/Crown-Commercial-Service/CMpDevEnvironment/blob/develop/docs/ccs_aws_v1-developer_guide.md
[faker]: https://github.com/stympy/faker
