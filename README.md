# commit-bridge

## Feature List
- [x] Roadmap - [PR #1](https://github.com/darth-dodo/commit-bridge/pull/1)
- [x] Setup RVM and Ruby - [PR #2](https://github.com/darth-dodo/commit-bridge/pull/2)
- [x] Setup commit flow hooks using [OverCommit](https://github.com/sds/overcommit)  - [PR #3](https://github.com/darth-dodo/commit-bridge/pull/3)
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
- [x] Active Admin and Devise Setup (basic) - [PR #6](https://github.com/darth-dodo/commit-bridge/pull/6)
- [x] Schema Modelling - [PR #7](https://github.com/darth-dodo/commit-bridge/pull/7)
    - [x] `User`
    - [x] `Event`
    - [x] `Commit`
    - [x] `EventCommit`
    - [x] `Project`
    - [x] `Ticket`
    - [x] `TicketCommit`
    - [x] `Release`
    - [x] `Repository`
    - [x] Generate the Entity Relationship Diagram using [`rails-erd`](https://github.com/voormedia/rails-erd)
- [x] Incoming Webhook - [PR #8](https://github.com/darth-dodo/commit-bridge/pull/8)
    - [x] Base API Controller
    - [x] Base Webhook Controller
    - [x] Webhook API
- [x] Base Service - [PR #9](https://github.com/darth-dodo/commit-bridge/pull/9
- [x] Demo Service - [PR #9](https://github.com/darth-dodo/commit-bridge/pull/9
- [ ] Event Delegator Service
- [ ] Exception Middlewares
- [ ] Pull Request Parser Service
- [ ] Push Request Parser Service
- [ ] Release Request Parser Service
- [ ] Commit Creation
- [ ] Model Test Cases
- [ ] Controller Test Cases
- [ ] Service Test Cases
- [ ] HTTP Adapter Layer using [HTTParty](https://github.com/jnunemaker/httparty)
- [ ] Outgoing Webhook
    - [ ] Payload generator
    - [ ] Requester
- [ ] Immutability Concern
- [ ] API Client Authentication


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
- The Active Admin related seed data can be generated using the command `rake db:seed`
- You can start the server using `rails s` or use the Rails console `rails c`
- ActiveAdmin is installed for having a visual representation of the data. Log in the admin panel at
`localhost:3000/admin` using the `secure` credentials
```
username: admin@commit-bridge.com
password: commit-bridge-123
```

---
## Application Details
- The Entity relationship diagram is present [over here](https://github.com/darth-dodo/commit-bridge/blob/master/erd.pdf)
- The ERD is autogenerated after every `rails db:migrate`

### Models
Generating models based on the Payload requirements

- User
- Event
- Commit
- EventCommit
- Project
- Ticket
- TicketCommit
- Release
- Repository

---
- A `User` generates an `Event`
- An `Event` contains `Commits`
- `Commit` is a part of one or more `Tickets`
- `Tickets` belong to a `Project`
- `Release` is a special `Event` which is made by a `User` by submitting multiple `Commits`
- `Events` and `Commit` are attached to a `Repository`

### Services
- Validations can be broadly categories as two types: Business Related and Data Integrity related
- For Non CRUD operations, sometimes a series of business rules need to be followed to make persistent changes in the application
- Complex business processing logic is stored in service containers
- Service containers are not a replace for model and data integrity logic
- This Application works on a MVSC design paradigm
- The Base Service is classified as [`ApplicationService`](https://github.com/darth-dodo/commit-bridge/blob/master/app/services/application_service.rb)
- A [`DemoService`](https://github.com/darth-dodo/commit-bridge/blob/master/app/services/mock/demo_service.rb) showcasing how services work in the application layer
- Some of the key benefits of adding Service are:
    - Consistent interface for service consumers
    - Cross component Pluggable eg. Using in Models, Rake tasks, Controllers, other Services
    - Consistent API modelled similar to ActiveRecord
    - Extendability allows for more powerful abstractions

### Good to haves:
- Using [`JSON validator`](https://github.com/mirego/activerecord_json_validator) to validate the payload before saving in the model
- PaperTrail in case of changing the data
- Cleaner module/namespace specific routing and controller policy as the application grows
