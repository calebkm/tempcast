# Tempcast ------

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

### Notes
* In Chrome the JS console will likely warn `Failed to resolve module specifier "controllers".` This is a [known issue](https://github.com/rails/importmap-rails#expected-errors-from-using-the-es-module-shim).

#### Future improvements
* API queries should be made asynchronously via ajax.
* JS should be used to dynamically display results after a query.
* DB cache should be swept when stale.
* Queries are currently limited to US addresses with zipcodes.
* Ajax spinners when queries are performed.
* Weather icons should adjust for day/night.

#### System details
* [Ruby](https://www.ruby-lang.org): 3.1.1
* [Ruby on Rails](https://rubyonrails.org): 7.0.2
* [Postgres](https://www.postgresql.org)

#### APIs
* Geocoding API: [Positionstack](https://positionstack.com/documentation)
* Weather API: [Tomorrow.io](https://www.tomorrow.io/weather-api)

#### Setup
* Use [Bundler](https://bundler.io) for required gems: `bundle`
* Create DB: `rake db:create`
* DB schema migration: `rake db:migrate`
* Run test suite: `rspec`

#### License
Licensed under MIT License Copyright (c) 2023 Caleb KM. See LICENSE for further details.
