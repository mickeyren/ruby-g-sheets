# Ruby Talkpush
A Sinatra based app that handles DB inserts and pushing to Talkpush for candidates applying. Driven from users submitting through a Google Form.

## Requirements

- Ruby 2.6.5

## Getting started
1. Clone the repo with `git clone git@github.com:mickeyren/ruby-g-sheets.git`
2. Run `bundle` to install the dependencies.
3. Create the Postgres DB for the app with `createdb ruby-g-sheets`
4. Run the migrations to ensure we have all the tables and fields in our DB with `rake db:migrate`
5. Start the app with `rerun 'rackup'`

## Running DB migration

```
DATABASE_URL="postgres://<username>:<password>@localhost:5432/ruby-g-sheets" rake db:migrate
```

## Technical flow

1. A [Google Form](https://docs.google.com/forms/d/e/1FAIpQLScVAYqo9rkyCoo2mgIEdBaFbOyYpojHyrd4j_wVNVb9puFyNg/viewform) is provided for user submissions.

2. Form submissions are added to a publicly viewable-only [Google Sheet](https://docs.google.com/spreadsheets/d/1sabL-v9RSVY9qQmVtN9zOls2e94f1A4N2ZuPujf1f9s/edit#gid=548306011).

3. A Google Apps Script makes a request to the Sinatra app whenever a new row is added from the Google sheet.

4. The Sinatra app internally creates a new row in the DB, and makes a request to the Talkpush API to create a new candidate.

