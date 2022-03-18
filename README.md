# [Tempcast](https://tempcast.herokuapp.com) ------

### Extended weather forecasts.

#### Overview
Tempcast is a simple weather forecasting app built using Ruby on Rails that returns the current temperature,
the low/high temp, the weather description and icon, and a full 16 day extended forecast by address. In order
to perform the forecast, an address is converted into latitude/longitude coordinates and zipcode 
via the Positionstock geocding API. These coordinates are then fed into the Tomorrow.io weather API which
returns the extended weather forecast. Forecasts are cached by zipcode for 30 minutes using a
PostgreSQL database.

This app tends to follow the [Airbnb Ruby Styleguide](https://github.com/airbnb/ruby#commenting)
when it comes to comments. Boilerplate Rails code is left more or less uncommented, where service objects
and other less obvious bits of code are explained with concise comments.

### Todos
* Testing coverage for APIs incomplete
* Testing coverage for Forecasts controller incomplete

### Notes
* In Chrome the JS console will likely warn `Failed to resolve module specifier "controllers".` This is a [known issue](https://github.com/rails/importmap-rails#expected-errors-from-using-the-es-module-shim).

#### Future improvements
* The app does not currently take day/night into account when displaying weather icons.
* Currently all API queries are synchronous.
* JavaScript has not been used to dynamically display content after a query.
* The DB is never swept of the cache.
* Only US addresses with zipcodes are currently valid.
* Geocoding results mapping lat/long to zipcode are not cached.
* AJAX spinners when queries are performed.

#### System details
* [Ruby on Rails](https://rubyonrails.org): 7.0.2
* [Ruby](https://www.ruby-lang.org): 3.1.1

#### APIs
* Geocoding API: [Positionstack](https://positionstack.com/documentation)
* Weather API: [Tomorrow.io](https://www.tomorrow.io/weather-api)

#### Setup
* Use [Bundler](https://bundler.io) for required gems: `bundle`
* Create DB: `rake db:create`
* DB schema migration: `rake db:migrate`
* Run test suite: `rspec`
* Deploy a branch to Heroku: `git push heroku <branch>`