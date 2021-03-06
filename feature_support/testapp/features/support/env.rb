require ::File.expand_path('../../../config/environment',  __FILE__)

ENV["RAILS_ENV"] ||= "cucumber"
require 'capybara/rails'
require 'capybara/rspec'

include Capybara::DSL

# Capybara defaults to XPath selectors rather than Webrat's default of CSS3. In
# order to ease the transition to Capybara we set the default here. If you'd
# prefer to use XPath just remove this line and adjust any selectors in your
# steps to use the XPath syntax.
Capybara.default_selector = :css