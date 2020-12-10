# GeyserList

A Minecraft server list exclusively for servers running Geyser.

## Installing

In case you want to install or help develop, you'll need the following information. If you just want to access the site, go here: https://servers.geysermc.org.

* Ruby version

GeyserList requires Ruby 2.7.2, this can be installed via [rvm](https://rvm.io) on UNIX systems, and RubyForWindows for Windows.

* System dependencies

You'll need the latest version of Node and Yarn installed to install JS dependencies. You'll need Bundler gem to install Ruby dependencies.

To install either respectively, run the following:
```
yarn install --check-files
bundle install
```

* Configuration

Each login needs an integration setup and a key. This is required for all the services we offer and can be managed in the respective credentials files.

Obviously, the credentials stored here are encrypted and secured, so you'll have to wipe them and make your own credentials.

The credentials file is as such:

```yml
db:
  host: 
  user: 
  pass: 

crypt:
  key: 
  salt: 

discord: 
google: 
github: 
xbox: 

apple:
  client_id:
  private_key: ""
  key_id: 
  team_id: 
```

DB is required to be filled out (see below). Crypt is for database encryption, and everything else is for signing in with service credentials. Public information is stored in the file directly at this time.

* Database creation

The database used is MariaDB (but MySQL works fine as well). Run `rake db:schema:load` to load the schema into the "geyserlist_dev" database after it is configured in the previous step.

* Database initialization

There are currently no seeds, everything is blank by default.

* How to run the test suite

There are currently no test sset up.

* Services (job queues, cache servers, search engines, etc.)

There are currently no special services at this time.

* Deployment instructions

If you use pm2, run the ecosystem file to boot up the server once everything is setup.
