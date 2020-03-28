# commit-bridge

## Feature List
- [x] Roadmap - [PR #1](https://github.com/darth-dodo/commit-bridge/pull/1)
- [x] Setup RVM and Ruby - [PR #2](https://github.com/darth-dodo/commit-bridge/pull/2)
- [x] Setup precommit hooks using [OverCommit](https://github.com/sds/overcommit)  - [PR #3](https://github.com/darth-dodo/commit-bridge/pull/3)
    - [x] Standard OverCommit Hooks
    - [x] [Rubocop](https://github.com/rubocop-hq/rubocop) and [Shopify Rubocop yaml](https://github.com/Shopify/ruby-style-guide/blob/master/rubocop.yml) - Static Code Analyzer
    - [x] [rails_best_practices](https://github.com/flyerhzm/rails_best_practices) - Code quality metric tool (downside checks whole project on every commit)
    - [x] rails_schema_up_to_date
    - [x] [Brakeman](https://github.com/presidentbeef/brakeman) - Security vulnerabilities spotter
    - [x] [Fasterer](https://github.com/DamirSvrtan/fasterer) - Speed improvement suggestions
    - [x] Forbidden Branches
    - [x] PostCheckout Hooks
- [x] Setup Rails 5 API app - [PR #4](https://github.com/darth-dodo/commit-bridge/pull/4)
- [x] Setup Testing  - [PR #5](https://github.com/darth-dodo/commit-bridge/pull/5)
    - [x] [RSpec](https://github.com/rspec/rspec-rails)
    - [x] [Factory Bot](https://github.com/thoughtbot/factory_bot)
    - [x] [Faker](https://github.com/faker-ruby/faker)
    - [x] [Database Cleaner](https://github.com/DatabaseCleaner/database_cleaner)
    - [x] [Shoulda Matchers](https://github.com/thoughtbot/shoulda-matchers)
- [x] Active Admin and Devise Setup (basic) - [PR #5](https://github.com/darth-dodo/commit-bridge/pull/5)
- [ ] Schema Modelling
    - [ ] `User`
    - [x] `Event`
    - [x] `Commit`
    - [x] `EventCommit`
    - [ ] `Repository`
    - [ ] `Release`
    - [ ] `Ticket`
    - [ ] `Project`
- [ ] Incoming Webhook
    - [ ] Base API Controller
    - [ ] Webhook API
- [ ] Service Layer
    - [ ] Base Service
    - [ ] Event Delegator Service
- [ ] Exception Middlewares
- [ ] Pull Request Parser Service
- [ ] Push Request Parser Service
- [ ] Release Request Parser Service
- [ ] Commit Creation
- [ ] Service Test Cases
- [ ] HTTP Adapter Layer using [HTTParty](https://github.com/jnunemaker/httparty)
- [ ] Outgoing Webhook
    - [ ] Payload generator
    - [ ] Requester


---
## Local Setup
- Use RVM to create a gemset across Ruby version 2.6.0 using the command `rvm use 2.6.0@commit-bridge --create`
- Clone the repo
- Install the dependencies using the command `bundle install`
- Install the precommit hooks using
```
overcommit --install
overcommit --sign
```
- The database can be created using the command `rake db:create`
- generate the schema using `rake db:migrate`
- The Active Admin related seed data can be generated using the command `   `
- You can start the server using `rails s` or use the Rails console `rails c`
- ActiveAdmin is installed for having a visual representation of the data. Log in the admin panel at
`localhost:3000/admin` using the `secure` credentials
```
username: admin@commit-bridge.com
password: commit-bridge-123
```


### Good to haves:
- Using [`JSON validator`](https://github.com/mirego/activerecord_json_validator) to validate the payload before saving in the model
