# Crown Marketplace

![Test Status](https://github.com/Crown-Commercial-Service/crown-marketplace/actions/workflows/rubyonrails.yml/badge.svg)
[![Maintainability](https://api.codeclimate.com/v1/badges/37cd5c1a9986ca396884/maintainability)](https://codeclimate.com/github/Crown-Commercial-Service/crown-marketplace/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/37cd5c1a9986ca396884/test_coverage)](https://codeclimate.com/github/Crown-Commercial-Service/crown-marketplace/test_coverage)

## Prerequisites

### Ubuntu

#### Install PostGIS


sudo apt install postgresql
sudo apt install postgresql-{postgresql-version}-postgis-{postgis-version}

Ensure the default Ports are correct (/etc/postgres/11/main/postgresql.conf)

Follow this:
https://www.cyberciti.biz/faq/how-to-install-setup-postgresql-9-6-on-debian-linux-9/
https://tutorials.technology/tutorials/How-to-change-postgresql-database-encoding-to-UTF8-from-SQL_ASCII.html
https://dev.to/ironfroggy/wsl-tips-starting-linux-background-services-on-windows-login-3o98

Also, sudo service postgresql start|stop


Install PhantomJS by following the instructions [in this gist](https://gist.github.com/julionc/7476620)

Install Redis (for Sidekiq background jobs)

wget http://download.redis.io/redis-stable.tar.gz
tar xvzf redis-stable.tar.gz
cd redis-stable
make


### MacOS

#### Check the Ruby version
##### N.B. The project currently runs on 2.7.7 (November 2022) 

Ensure that a ruby version manager (e.g. rvm or rbenv) is installed and set up properly, using 2.7.7 as the Ruby version before trying anything else. 

#### Install Postgres and PostGIS
`brew install postgres` (this will install the latest (HEAD) version, currently 12.  The server runs 11!)  
`brew install postgis` (this is the latest (HEAD) and has postgres12 as a dependency - problematic)

#### Look at these pages for building postgis:  
* http://www.concept47.com/austin_web_developer_blog/rails/best-way-to-install-postgis-for-postgres-versions-lower-than-9-6-x-from-source/

* https://github.com/petere/pex/issues/8

* https://gist.github.com/skissane/0487c097872a7f6d0dcc9bcd120c2ccd

They amount to: 
* brew install pcre
* download the tar from https://postgis.net/source/ (https://download.osgeo.org/postgis/source/postgis-2.5.4.tar.gz)
* ln -s /usr/local/include/pcre*.h /usr/local/opt/postgresql@11/include
* ./configure CFLAGS=-I/usr/local/include
* PG_CPPFLAGS='-DACCEPT_USE_OF_DEPRECATED_PROJ_API_H -I/usr/local/include' CFLAGS='-DACCEPT_USE_OF_DEPRECATED_PROJ_API_H -I/usr/local/include' make
* make install

Install PhantomJS (for Javascript tests)

`brew install phantomjs`

Install Redis (for Sidekiq background jobs)

`brew install redis`

## Set up

To install dependencies:

`yarn install`

`bundle` (make sure the bundler gem is installed first)

To create, migrate & seed the database:  

`rake db:setup` 

### Adding address data
To seed your database with address data run the following command

`rake db:sample_address_import`

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

#### Google Analytics

* `GA_TRACKING_ID`
  * Google Analytics is disabled if this is not set

#### Database

The following are used to configure the database, but only in production
environments:

* `CCS_DEFAULT_DB_HOST`
* `CCS_DEFAULT_DB_PORT`
* `CCS_DEFAULT_DB_NAME`
* `CCS_DEFAULT_DB_USER`
* `CCS_DEFAULT_DB_PASSWORD`

#### Log level

* `LOG_LEVEL` can be used to manipulate the log level in production. Set to `'debug'` to see debug output; the default (if not set) is `:info`

## Run

Execute the following commands:

```
redis-server /usr/local/etc/redis.conf
bundle exec sidekiq
rails s
```

Visit [localhost:3000](http://localhost:3000).
## Development

### Design & frontend

* The design of the app is closely based on the [GOV.UK Design System][] with
  some minor CCS-related variations.
* The project uses and extends the [GOV.UK Frontend][] npm package.
* The npm package dependencies are listed in `package.json`, installed using
  [yarn][], and the exact versions of all dependencies direct/indirect are
  locked in `yarn.lock`.
* The CSS follows [Block Element Modifier][] conventions.
* We use `TypeScript` to write our frontend code (in `app/typescript`)

### Code

The project is a fairly standard Rails web app. However, there are a few aspects
which are somewhat non-standard:

* The framework-specific routes and code are all isolated from each other using
  namespaces with some code shared across frameworks. In some ways the code for
  each framework could be considered as a mini web app in its own right and the
  intention is that it should be relatively easy to extract the code for one
  framework into a separate Rails app if that was deemed appropriate down the
  line.

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
* We use the [Cucumber][] testing framework to test the frontend functionality with a subset of the test run as part of the CI.
* We use [Axe Cucumber][] to run accessibility tests but these are not run as part of the CI.
* All the specs are run as part of the default Rake task, but the standard
  RSpec-provided Rake tasks also exist for running sub-groups of the specs.

#### Code coverage

Code coverage is measured by [simplecov](https://github.com/colszowka/simplecov)

After running the Rspec tests, open [coverage/index.html](coverage/index.html) in a browser to see the code coverage percentage.

Note that some lines are excluded from simplecov with the `# :nocov:` instruction.

### Continuous integration & deployment

* When a branch is pushed or pull request is raised GitHub actions will run
  the rspec and cucumber test suites.
* When the PR is merged to a main branch GitHub actions will run the test suites
  again before triggering the AWS pipeline using the [CCS AWS Pipeline action][].
* Before the code is deployed to the environment,
  you will be asked to review the deployment.
  Once you approve the deployment, the action will trigger the AWS Pipeline.
* If something goes wrong during this phase you should:
  - [investigate the action][]
  - If the test section failed, try re-running them
  - If the deployment section failed, try re-running them
  - If that does not work and you have to release the code you can still do it within [AWS CodePipeline][]
* We use [AWS CodePipeline][] and [AWS CodeBuild][] to build and deploy the application.
* A container is built using the `Dockerfile` in this repo,
  uploaded to the [AWS Elastic Container Registry][], and deployed
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
[Cucumber]: https://cucumber.io/
[Axe Cucumber]: https://www.deque.com/axe/
[CCS AWS Pipeline action]: https://github.com/Crown-Commercial-Service/ccs-aws-codepipeline-action
[investigate the action]: https://github.com/Crown-Commercial-Service/crown-marketplace/actions/workflows/setup_deployment.yml
