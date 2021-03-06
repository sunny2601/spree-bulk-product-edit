Spree Bulk Product Edit
====================

Edit multiple products at once, either by selecting products and applying changes interactively, 
or by uploading a spreadsheet containing the product identifiers and new data.

Installation
------------

Add spree_bulk_product_edit to your Gemfile:

```ruby
gem 'spree_bulk_product_edit'
```

Bundle your dependencies and run the installation generator:

```shell
bundle
bundle exec rails g spree_bulk_product_edit:install
```

Testing
-------

First bundle your dependencies, then run `rake`. `rake` will default to building the dummy app if it does not exist, then it will run specs. The dummy app can be regenerated by using `rake test_app`.

```shell
bundle
bundle exec rake
```

When testing your applications integration with this extension you may use it's factories.
Simply add this require statement to your spec_helper:

```ruby
require 'spree_bulk_product_edit/factories'
```

Copyright (c) 2017 Astek Wallcovering, Inc., released under the New BSD License
