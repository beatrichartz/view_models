Feature: integrate with Rails

  Background:
    When I generate a new rails application
    And  I copy the generic app files from the support folder into the generated app
    And  I configure the application to use the view_models gem from this project
    And  I configure the application to use the following gems
      | Name               | Version   | Require | Condition               |
      | factory_girl_rails | ~> 4.3.0  |         |                         |
      | factory_girl       | ~> 4.3.0  |         |                         |
      | cucumber-rails     | ~> 1.4.0  | false   |                         |
      | rspec-rails        | ~> 2.14.1 |         |                         |
      | capybara           | ~> 2.2.0  |         |                         |
      | slim-rails         | >= 2.1.0  |         |                         |
      | rubysl             | ~> 2.0    |         | if RUBY_ENGINE == 'rbx' |
      | rubysl-test-unit   | ~> 2.0    |         | if RUBY_ENGINE == 'rbx' |
      | racc               | ~> 1.4    |         | if RUBY_ENGINE == 'rbx' |

    And  I successfully run `bundle install`
    And  I successfully run `bundle exec rake db:migrate`

  Scenario:
    When I successfully run `bundle exec rake cucumber`
    Then the output should contain "2 scenarios (2 passed)"
    And the output should contain "17 steps (17 passed)"
