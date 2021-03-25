# Contributing to GeyserList

Thank you for your contributions to GeyserList! The guide below will help you become a contributor to the project.

## Environment Setup

### Installing

If you want to install or help develop, you'll need the following information. If you wish to access the site, go here: https://servers.geysermc.org.

### Ruby version

GeyserList requires Ruby 2.7.2, which can be installed via [rvm](https://rvm.io) on UNIX systems or RubyForWindows for Windows.

### System dependencies

You'll need the latest version of Node and Yarn installed to install JS dependencies. You'll need Bundler gem to install Ruby dependencies.

Yarn can be installed by running the following:
```
npm install -g yarn
```

To install the necessary dependencies, run the following:
```
yarn install --check-files
bundle install
```

### Configuration

Each login needs an integration setup and a key. This is required for all the services we offer and can be managed in the respective credentials files.

The credentials stored here are encrypted and secured, so you'll have to wipe them to keep your credentials.

To edit the credentials (you'll likely only need `development`), run the following command:

```
rails credentials:edit -e development
```
*An editor supporting the `--wait` flag may be required. Editors such as VIM, Atom, and mate support this.*
*To utilize them, run `EDITOR="editor --wait"` before the command.*

It may ask you to wipe the file and start over to generate a key, agree to this as one is not provided.

The credentials file is as such:

```yml
db: # Database information (Required)
  host: # URL for your Database, excluding port
  user: # Username
  pass: # Password

crypt: # Database encryption (Required)
  key: # Encryption key (a random set of alphanumeric characters)
  salt: # Encryption salt (a random set of alphanumeric characters)

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
    client_secret: <%= Rails.application.credentials.discord %> # Leave as is, fills in from credentials
  google:
    client_id: # Google Client ID
    client_secret: <%= Rails.application.credentials.google %> # Leave as is, fills in from credentials
  apple:
    client_id: # Apple Client ID
    # Other Apple credentials are in config/initializers/apple_auth.rb & the credentials
  xbox:
    client_id: # Xbox Client ID
    client_secret: <%= Rails.application.credentials.xbox %> # Leave as is, fills in from credentials

development:
  github:
    client_id: # Development environment GitHub Client ID
    client_secret: <%= Rails.application.credentials.github %> # Leave as is, fills in from credentials

production:
  github:
    client_id: # Production environment GitHub Client ID
    client_secret: <%= Rails.application.credentials.github %> # Leave as is, fills in from credentials
```

### Database creation

The database used is MariaDB (but MySQL works fine as well). Run `rake db:setup` to create and load the database and schema after being configured in the previous step.

### Database initialization

There are currently no seeds. Everything is blank by default.

### How to run the test suite

There is currently no test suite set up.

### Services (job queues, cache servers, search engines, etc.)

There are currently no special services at this time.

### Deployment instructions

If you use pm2, run the ecosystem file to boot up the server once everything is setup.

## Contributing

At this point, you're ready to contribute! We don't have any strict guidelines or rules to follow, but we have some:

1) Comment the code, so we know what's going on.
2) If you wish to add any files to the encrypted files (secret, for example), those must be documented in the PR.
3) Rubocop is suggested, though not everything needs to be followed exactly.

## Editing

There are many places to contribute for any user. Most of the work is done in the `app/` directory.

If you have it, it is recommended to use RubyMine as it makes development a lot easier. However, any editor is capable of editing the project.

A quick breakdown of the structure you may need to touch is below. 
If you plan on modifying anything else, you probably know what to do.

`app/views/` - This is where the HTML and JavaScript is done. The 'frontend' as it's called.
Each folder in here correspond to a controller and method (action). A folder is for the controller, and the file.html.erb is the method.

`app/controllers/` - This is where the backend occurs. Code is ran here before it's passed to the view. This is in Ruby.

`app/helpers/` - This is where "helper" methods go. Any methods here are in Ruby, for Ruby, and can be accessed in a view or controller.

`app/models/` - This is where the database tables are used and access. Typically, these can be left alone unless you plan on adding tables.

`config/routes.rb` - This is the route file. The typical structure for a line is `request_type "path", to: "controller#method"`.
