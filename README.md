# GeyserList

A Minecraft server list exclusively for servers running [Geyser](https://github.com/GeyserMC/Geyser).

## Installing

In case you want to install or help develop, you'll need the following information. If you wish to access the site, go here: https://servers.geysermc.org.

### Ruby version

GeyserList requires Ruby 2.7.2, which can be installed via [rvm](https://rvm.io) on UNIX systems or RubyForWindows for Windows.

### System dependencies

You'll need the latest version of Node and Yarn installed to install JS dependencies. You'll need Bundler gem to install Ruby dependencies.

To install either, respectively, run the following:
```
yarn install --check-files
bundle install
```

## Configuration

Each login needs an integration setup and a key. This is required for all the services we offer and can be managed in the respective credentials files.

The credentials stored here are encrypted and secured, so you'll have to wipe them to keep your credentials.

The credentials file is as such:

```yml
db: # Database information (Required)
  host: # URL for your Database
  user: # Username
  pass: # Password

crypt: # Database encryption (Required)
  key: # Encryption key
  salt: # Encryption salt

# Oauth Secrets - Optional (unless you need to sign in)
discord: # Discord Oauth Secret
google: # Google Oauth Secret
github: # GitHub Client Secret
xbox: # Xbox Secret

# Apple information, bit complicated - Optional (requires an Apple developer membership)
apple:
  private_key: "" # Private key (with --BEGIN PRIVATE KEY-- and --END PRIVATE KEY--)
  key_id: # The Key ID (found in your certificates area)
  team_id: # The Team ID (located next to your name in the top right)
```

Additionally, to edit integration OAuth configuration, navigate to `config/integrations.yml`.

```yaml
shared:
  discord:
    client_id: # Discord Client ID
    client_secret: <%= Rails.application.credentials.discord %> # Leave blank, fills in from credentials
  google:
    client_id: # Google Client ID
    client_secret: <%= Rails.application.credentials.google %> # Leave blank, fills in from credentials
  apple:
    client_id: # Apple Client ID
    # Other Apple credentials are in config/initializers/apple_auth.rb & the credentials
  xbox:
    client_id: # Xbox Client ID
    client_secret: <%= Rails.application.credentials.xbox %> # Leave blank, fills in from credentials

development:
  github:
    client_id: # Development environment GitHub Client ID
    client_secret: <%= Rails.application.credentials.github %> # Leave blank, fills in from credentials

production:
  github:
    client_id: # Production environment GitHub Client ID
    client_secret: <%= Rails.application.credentials.github %> # Leave blank, fills in from credentials
```

### Database creation

The database used is MariaDB (but MySQL works fine as well). Run `rake db:schema:load` to load the schema into the "geyserlist_dev" database after being configured in the previous step.

### Database initialization

There are currently no seeds. Everything is blank by default.

## How to run the test suite

There is currently no test suite set up.

## Services (job queues, cache servers, search engines, etc.)

There are currently no special services at this time.

## Deployment instructions

If you use pm2, run the ecosystem file to boot up the server once everything is setup.
