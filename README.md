# GOV.UK Rails skeleton

## Set up

To create the (unused but required) database:

    $ rake db:create

To install dependencies:

    $ yarn install
    $ bundle

### Environment variables

* `GOOGLE_GEOCODING_API_KEY`
  * You can obtain an API key for development [from Google][geocoding-key]
  * Add it to your `.env.local` file which is ignored by git

## Run

    $ rails s

Visit [localhost:3000](http://localhost:3000).

[geocoding-key]: https://console.developers.google.com/flows/enableapi?apiid=geocoding_backend&keyType=SERVER_SIDE
