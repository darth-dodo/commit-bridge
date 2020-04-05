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
- [x] Base Service - [PR #9](https://github.com/darth-dodo/commit-bridge/pull/9)
- [x] Demo Service - [PR #9](https://github.com/darth-dodo/commit-bridge/pull/9)
- [x] Event Parser Strategy Service - [PR #10](https://github.com/darth-dodo/commit-bridge/pull/10)
- [x] Exception Middlewares  - [PR #11](https://github.com/darth-dodo/commit-bridge/pull/11)
- [x] Pull Request Parser Service - [PR #13](https://github.com/darth-dodo/commit-bridge/pull/13)
- [x] Push Request Parser Service - [PR #12](https://github.com/darth-dodo/commit-bridge/pull/12)
- [x] Release Request Parser Service - [PR #14](https://github.com/darth-dodo/commit-bridge/pull/14)
- [x] Commit Creation - [PR #17](https://github.com/darth-dodo/commit-bridge/pull/17)
- [x] Refactoring Services - [PR #18](https://github.com/darth-dodo/commit-bridge/pull/18)
- [x] HTTP Facade Layer using [Faraday](https://github.com/lostisland/faraday) - [PR #19](https://github.com/darth-dodo/commit-bridge/pull/19)
    - [x] DotEnv External Token management
    - [x] External Exception Management
    - [x] Communicator Layer using Faraday
    - [x] API Client
    - [x] Echo controller for testing
- [x] Outgoing Webhook - [PR #20](https://github.com/darth-dodo/commit-bridge/pull/20)
    - [x] Payload generator module/helper
    - [x] Service calling the API Client
    - [x] State Management using `EventCommitSync` model
    - [x] Integrating `bangable` Outgoing webhook service in the controller layer
    - [x] Exception propagation to the incoming webhook
    - [x] Echo Endpoint testing using [`Puma`](https://github.com/puma/puma) for multithreading
- [x] CORS using [Rack CORS](https://github.com/cyu/rack-cors) - [PR #21](https://github.com/darth-dodo/commit-bridge/pull/21)
- [x] API throttling using [Rack Attack](https://github.com/kickstarter/rack-attack#throttling) - [PR #22](https://github.com/darth-dodo/commit-bridge/pull/22)
- [x] Incoming Webhooks Token Based Auth  - [PR #23](https://github.com/darth-dodo/commit-bridge/pull/23)
    - [x] Adding `ApiClient` model
    - [x] Adding Token based Authentication action in the `BaseWebhookController`
    - [x] Exception Management in case of invalid requests
- [x] Model RSpec  - [PR #24](https://github.com/darth-dodo/commit-bridge/pull/24)
- [ ] Service RSpec
    - [x] Commit Parser Service
    - [ ] Pull Request Parser Service
    - [ ] Push Request Parser Service
    - [ ] Release Request Parser Service
    - [ ] Event Delegator Service
    - [ ] Ticket Tracking API service
- [ ] Service Edge Cases RSpec [Future iteration]
- [ ] Controller Test Cases
- [ ] Database Indexes and Application Model Validations optimization look
    - [ ] Add Unique together indexes for M2M
    - [ ] Database level unique indexes
        - [ ] Commit SHA
        - [ ] Event Payload
    - [ ] Human readable validation errors
- [ ] Immutability Concern

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
- `bundle exec puma` for running the Rails Server in multi threading mode (for Webhook external API echo feature)
- ActiveAdmin is installed for having a visual representation of the data. Log in the admin panel at
`localhost:3000/admin` using the `secure` credentials
```
username: admin@commit-bridge.com
password: commit-bridge-123
```
- If you want to test the API throttling using Redis, setup Redis and start the Redis server
- Change the `.env.example` as required to match your setup
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
- EventTicket
- Release
- Repository

For brevity, the user journey is as follows:
- A `User` generates an `Event`
- An `Event` contains `Commits`
- `Commit` is a part of one or more `Tickets`
- `Tickets` belong to a `Project`
- `Release` is a special `Event` which is made by a `User` by submitting multiple `Commits`
- `Events` and `Commit` are attached to a `Repository`
- An `Event` when registered belongs to one or more `Tickets` and a single `Ticket` can be across multiple `Events`


---
### Controllers
- `ApplicationController` is required for making `Devise` work
- `ApiController` should be the base controller from which our all API controllers to be subclassed from
- All webhook controllers should be subclassed from `BaseWebhookController`
- The Git Cloud service consumes the controller `GitCloudWebhookCOntroller`
- Exceptions are managed through `ExceptionHandler`
- Custom Exceptions such as `CommitBridgeValidationError` can be defined as per usecase


---
### Service Architecture
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


#### Application Services
- The `EventParserService` is the parent service used by the webhook and abstract the persistent data creation logic
- It is consumed by the controller to parse the payload and find the required payload parser service
- Services can be nested in other services
- Services can be standalone software components or common logic can be extracted into Helper Concerns
- The disadvantage of DRYing out in Helper Concerns is increased maintained complexity and coupling between multiple services through the Concerns


---
### Good to haves:
- Using [`JSON validator`](https://github.com/mirego/activerecord_json_validator) to validate the payload before saving in the model
- PaperTrail in case of changing the data
- Cleaner module/namespace specific routing and controller policy as the application grows
- Writing a generator for quickstarting services
- TDD/BDD


## Project Philosophies
These were some of the things I keep in mind while writing software

- T. A. [R. O. T.] mindset - Top/Bottom, Algorithms/Steps, Refactor, Optimize, Test. *R, O, T are reordered according to priority*
- APIs are User Interface for Developers
- Think schemas as entities or actors
- SRP and Open/Close
- Consistency matters (eg. Service objects, Rubcop, Best Practise)
- Sometimes `magic` is good (`execute!` and middlewares) (only sometimes*)
- Make it run. Make it run faster (if required)
- Code is as good as the tests

## Cleaner Approach
- If the event could be posted to `slug` based params, event types delegation will be responsibility of the client which can be directly routed to the appropriate service from the `WebhookEventParser` service
```
- localhost:3000/webhooks/git/pull/
- localhost:3000/webhooks/git/push/
- localhost:3000/webhooks/git/release/
```


## Alternative Architecture Decisions
- In increasing order of complexity
- Using Sidekiq or Reque to process the API payloads in background
- Fault tolerance for the external facing API
- Event driven arch using Message Queue
- Event Driven Arch using Message Bus


## API Throttling
- API throttling is done using Rack Attack with the cache store as Redis.
- The limits can be controlled through the `.env` variable ` DAILY_IP_REQUEST_QUOTA`
- More complex throttling policies and feedbacks can be set using an approach similar to [this](https://vitobotta.com/2019/09/24/protecting-rails-app-from-small-scripted-attacks/) or [this](https://blog.bigbinary.com/2018/05/15/how-to-mitigate-ddos-using-rack-attack.html) with exponential back-offs and detailed logging
- Load testing response from `Artillery` when the request quota is set to `10/per day/ip`
```
Elapsed time: 1 second
  Scenarios launched:  10
  Scenarios completed: 10
  Requests completed:  200
  Mean response/sec: 147.06
  Response time (msec):
    min: 3.3
    max: 1206.4
    median: 10.9
    p95: 45.1
    p99: 213.6
  Codes:
    200: 10
    429: 190

All virtual users finished
Summary report @ 12:08:03(+0200) 2020-04-05
  Scenarios launched:  10
  Scenarios completed: 10
  Requests completed:  200
  Mean response/sec: 145.99
  Response time (msec):
    min: 3.3
    max: 1206.4
    median: 10.9
    p95: 45.1
    p99: 213.6
  Scenario counts:
    0: 10 (100%)
  Codes:
    200: 10
    429: 190
```

## Authentication
### Internal Facing
- Token based Authentication is considered for this application
- Incoming Webhooks need to provide token which are stored in the `ApiClient` model
- Auth needs to be provided in the request headers eg.
```
Content-Type:application/json
Authorization:Token token=fK2qGmQa73iH758DAuaWphtk
```
- API keys can be expired by changing the `expiry` value
- The authentication happens in the `BaseWebhookController` and can be customized if required
- The following scenarios are possible:
    - Status code `401` Unauthorized when the key has expired with the payload
    ```
    {
        "error_message": "API Key Expired!"
    }
    ```
    - Status code `403` when an invalid key is provided
    ```
    {
        "error_message": "Please provide a valid token!"
    }
    ```
  - Status code `403` when no headers are provided
  ```
    {
        "error_message": "Please provide Auth Headers!"
    }
  ```
- Future scope: Moving the authentication from simple Token based to JWT and exposing refresh token functionality over an API
