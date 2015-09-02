# Stormpath-Rails-Gem

Stormpath is the first easy, secure user management and authentication service for developers. This is the Rails gem to ease integration of its features with any Rails-based application.

stormpath makes it incredibly simple to add users and user data to your application. It aims to completely abstract away all user registration, login, authentication, and authorization problems, and make building secure websites painless.

## INSTALL

To get started, add Stormpath to your `Gemfile`, `bundle install`, and run the
`install generator`:

generates inital config and setup files
```sh
$ rails generate stormpath:install
```

The generator:

* Inserts `Stormpath::Controller` into your `ApplicationController`
* Creates an initializer to allow further configuration.
* Creates a migration that either creates a users table or adds any necessary
  columns to the existing table.

# CONFIGURE
Override any of these defaults in config/initializers/stormpath.rb

```ruby
Stormpath::Rails.configure do |config|
  config.api_key.file = ENV['STORMPATH_API_KEY_FILE_LOCATION']
  config.application.href = ENV['STORMPATH_SDK_TEST_APPLICATION_URL']
end
```

# USAGE

### Helper Methods

Use `current_user`, `signed_in?`, `signed_out?` in controllers, views, and helpers. For example:
```erb
<% if signed_in? %>
  <%= current_user.email %>
  <%= button_to "Sign out", sign_out_path, method: :delete %>
<% else %>
  <%= link_to "Sign in", sign_in_path %>
<% end %>
```

### ID Site

If you'd like to not worry about building your own registration and login screens at all, you can use Stormpath's new [ID site](https://docs.stormpath.com/guides/using-id-site/) feature. This is a hosted login subdomain which handles authentication for you automatically.

To make ID Site work in Rails, you need to change stormpath configuration file:

```ruby
Stormpath::Rails.configure do |config|
  config.id_site do |c|
    c.enabled = true
    c.uri = "/redirect"
  end
end
```

### Social Login

Stormpath Rails supports social login as well. Currently only Facebook is supported,  Providers for: Google, Github and Linkedin are currently in development. 

In order to enable Facebook login you first you need to create a Facebook application and create a Facebook directory in your stormpath account. More info can be found [here](https://docs.stormpath.com/rest/product-guide/#integrating-with-facebook). After that you need to enable id from storm paths configuration file and provide facebook app_id and app_secret which is provided to you after Facebook app creation.

```ruby
Stormpath::Rails.configure do |config|
  config.facebook do |c|
    c.app_id = 'app_id'
    c.app_secret = 'app_secret'
  end
end
```
