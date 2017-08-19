# encoding: UTF-8
Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_bulk_product_edit'
  s.version     = '0.1.1'
  s.summary     = 'Edit multiple products at once.'
  s.description = 'Edit multiple products at once, either by selecting products and applying changes interactively,
    or by uploading a spreadsheet containing the product identifiers and new data.'
  s.required_ruby_version = '>= 2.0.0'

  s.author    = 'Edwin Horneij'
  s.email     = 'edwin@astekwallcovering.com'
  s.homepage  = 'http://www.astekwallcovering.com'

  #s.files       = `git ls-files`.split("\n")
  #s.test_files  = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_dependency 'spree_core', '~> 3.1.6'
  s.add_dependency 'roo'
  s.add_dependency 'roo-xls'

  s.add_development_dependency 'capybara', '~> 2.4'
  s.add_development_dependency 'coffee-rails'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'factory_girl', '~> 4.5'
  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'rspec-rails',  '~> 3.1'
  s.add_development_dependency 'sass-rails', '~> 5.0.0.beta1'
  s.add_development_dependency 'selenium-webdriver'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'sqlite3'
end
