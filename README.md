# commit-bridge

## Feature List
- [ ] Roadmap
- [ ] Setup RVM and Ruby
- [ ] Setup precommit hooks using OverCommit
    - [ ] Standard OverCommit Hooks
    - [ ] [Rubocop](https://github.com/rubocop-hq/rubocop) and [Shopify Rubocop yaml](https://github.com/Shopify/ruby-style-guide/blob/master/rubocop.yml) - Static Code Analyzer
    - [ ] [rails_best_practices](https://github.com/flyerhzm/rails_best_practices) - Code quality metric tool (downside checks whole project on every commit)
    - [ ] rails_schema_up_to_date
    - [ ] [Brakeman](https://github.com/presidentbeef/brakeman) - Security vulnerabilities spotter
    - [ ] [Fasterer](https://github.com/DamirSvrtan/fasterer) - Speed improvement suggestions
- [ ] Setup Rails 5 API app
- [ ] Setup Testing
    - [ ] RSpec
    - [ ] Factory Bot
    - [ ] Faker
    - [ ] Database Cleaner
- [ ] Active Admin and Devise Setup (basic)
- [ ] Schema Modelling
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
- Install the precommit hooks using
```
overcommit --install
overcommit --sign
```