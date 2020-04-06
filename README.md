# commit-bridge

Rails 5 API application for acting as a bridge between Git service webhooks and external Ticket Tracking system

---
# Documentation

- [Feature List](#feature-list)
- [Handover Checklist](#handover-checklist)
- [Good to Haves](#good-to-haves)
- [Local setup](#local-setup)
- [Implementation Details](#implementation-details)
    - [Application Details](#application-details)
    - [Schema Modelling](#schema-modelling)
    - [API Details](#api-details)
    - [Service Architecture](#service-architecture)
    - [Authentication](#authentication)
    - [Incoming Webhooks](#incoming-webhooks)
    - [External APIs](#external-apis)
    - [Custom Middlewares and RESTful Errors](#custom-middlewares-and-restful-errors)
    - [Test Cases](#test-cases)
    - [Active Admin](#active-admin)
    - [Caching and API Throttling](#caching-and-api-throttling)
    - [Deployment Strategy](#deployment-strategy)
- [Mentionables](#mentionables)
    - [Application Design Mindset](#application-design-mindset)
    - [Readability](#readability)
    - [Resilience](#resilience)
    - [Security](#security)
    - [Commit History](#commit-history)
    - [Alternate Design Solutions](#alternate-design-solutions)
- [Post Script](#post-script)
- [Next Steps](#next-steps)


---
# Feature List
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
    - [x] Commit Parser Service  - [PR #25](https://github.com/darth-dodo/commit-bridge/pull/25)
    - [x] Pull Request Parser Service  - [PR #25](https://github.com/darth-dodo/commit-bridge/pull/25)
    - [ ] Push Request Parser Service - [P. S.](#post-script)
    - [ ] Release Request Parser Service - [P. S.](#post-script)
    - [ ] Event Delegator Service
    - [ ] Ticket Tracking API service
- [ ] Service Edge Cases RSpec - [P. S.](#post-script)
- [ ] Controller Test Cases
- [ ] Documentation - [PR #26](https://github.com/darth-dodo/commit-bridge/pull/26)


---
# Handover Checklist
- [x] Write Documentation
- [x] Update `.env.example`
- [x] Attach Postman collection


---
# Good to Haves
- Server error management with Sentry
- More Database Indexes (*after API profiling ;)* )
- More Application Model Validations
-  Immutability Concern
- PaperTrail in case of changing the data
- Cleaner module/namespace specific routing and controller policy as the application grows
- Writing a generator for quickstarting services
- `ActiveSerializer` for better serialization
- Avoid N+1 queries by using joins and include at appropriate places
- Using [`JSON validator`](https://github.com/mirego/activerecord_json_validator) to validate the payload before saving in the model
- More test coverage

---
# Local Setup
- Make sure you have a [Postgres](http://postgresguide.com/) version greater than 9.6
- Use RVM to create a gemset across Ruby version 2.6.0 using the command `rvm use 2.6.0@commit-bridge --create`
- Clone the repo
- Install the dependencies using the command `bundle install`
- Before development, install the precommit hooks using
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
- The defined seed values can be found over [here](https://github.com/darth-dodo/commit-bridge/blob/master/db/seeds.rb)
- If you want to test the API throttling using Redis, setup Redis and start the Redis server
- Change the `.env.example` as required to match your setup


---
# Implementation Details
## Application Details
- The application is made using Ruby 2.6 and Rails 5.2
- This is an API only application (with the exception of Active Admin)
- The Entity relationship diagram is present for the application schema is present [over here](https://github.com/darth-dodo/commit-bridge/blob/master/erd.pdf)
- The ERD is autogenerated after every `rails db:migrate`
- The application uses an Model View Controller Service Design paradigm
- Services are used as business logic containers. More information can be found over [here](#service-architecture).
- Active Admin is used for high level view of the data
- Environment variables are supported through [`dotenv-rails`](https://github.com/bkeepers/dotenv)
- Sentry is used for exception and stack trace management
- Redis and Rack Attack for API throttling
- RSpec, Factory Bot, Shoulda Matchers and Faker for writing Test cases
- Faraday for making external web requests
- Postgres as Datastore


---
## Schema Modelling
- Generating models based on the Payload requirements
- The ERD is generated through [`rails-erd`](https://github.com/voormedia/rails-erd)
```
- ApiClient
- User
- Event
- Commit
- EventCommit
- EventCommitSync
- Project
- Ticket
- TicketCommit
- EventTicket
- Release
- Repository
```

For brevity, the application journey is as follows:
- A `User` generates an `Event` through an `ApiClient` credentials
- An `Event` contains `Commits`
- `Commit` is a part of one or more `Tickets`
- `Commit` belongs to a `User`
- `Tickets` belong to a `Project`
- `Release` is a special `Event` which is made by a `User` by submitting multiple `Commits`
- `Event` is attached to a `Repository`
- An `Event` when registered belongs to one or more `Tickets` and a single `Ticket` can be across multiple `Events`

---
## API Details
- `ApplicationController` is required for making `Devise`/`Active Admin` work
- `ApiController` should be the base controller from which our all API controllers to be subclassed from
- All webhook controllers should be subclassed from `BaseWebhookController`
- The Git Cloud service consumes the controller `GitCloudWebhookController#receive`
- Exceptions are managed through `ExceptionHandler` concern
- Responses are generated through `Response` concern
- Internal custom Exceptions such as `CommitBridgeValidationError` are defied in `CommitBridgeExecptions`
- Token based authentication is used for the public facing APIs with the `api_key` present in `ApiClient` model
- The application echoes the Ticket Tracking Application API through `GitCloudWebhookController#echo` for development purposes


---
## Service Architecture

### Reasoning
- Validations can be broadly categories as two types: Business Related and Data Integrity related
- For Non CRUD operations, sometimes a series of business rules need to be followed to make persistent changes in the application
- Complex business processing logic is stored in service containers
- Service containers are **not a replacement** for model and data integrity logic
- This web service works on a MVSC design paradigm
- Services can be nested in other services
- Services can be standalone software components or common logic can be extracted into Helper Concerns
- The disadvantage of DRYing out in Helper Concerns is increased maintained complexity and coupling between multiple services through the Concerns

### Advantages
- Consistent interface for service consumers
- Cross component Pluggable eg. Using in Models, Rake tasks, Controllers, background Jobs, other Services
- Consistent API modelled similar to ActiveRecord
- Extendability allows for more powerful abstractions

### Disadvantages
- One more abstraction
- What should be a "Service" ambiguity
- Service or Helper decision
- Black boxes/holes of deeply nested logic

### Demo
- The Base Service is classified as [`ApplicationService`](https://github.com/darth-dodo/commit-bridge/blob/master/app/services/application_service.rb)
- A [`DemoService`](https://github.com/darth-dodo/commit-bridge/blob/master/app/services/mock/demo_service.rb) showcasing how services work in the application layer

### Application Services
- The `EventParserService` is the parent service used by the webhook and abstract the persistent data creation logic
- It is consumed by the controller to parse the payload and find the required payload parser service
- `PullRequestParser` is used to parse payloads for Pull Request Events
- `PushRequestParser` is used to parse payloads for Push Request Events
- `ReleaseRequestParser` is used to parse payloads for Release Request Events
- `CommitParser` is used to parse the commit payload in order to create or update commits, tickets and projects
- `SyncEventCommitsWithTrackingApi` is used to make Ticket Tracking API requests with appropriate `Communicator`


---
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

    ```json
    {
        "error_message": "API Key Expired!"
    }

    ```
    - Status code `403` when an invalid key is provided

    ```json
    {
        "error_message": "Please provide a valid token!"
    }
    ```
  - Status code `403` when no headers are provided

  ```json
    {
        "error_message": "Please provide Auth Headers!"
    }
  ```
- Future scope: Moving the authentication from simple Token based to JWT and exposing refresh token functionality over an API

### External Facing
- We are assuming the Ticket Tracking application operates on Token Based Authentication
- The `Communicator` extracts the token from the environment variables and sets it in the headers


---
## Incoming Webhooks
- Incoming webhooks should post at `localhost:3000/webhooks/git/` with valid API Key as the token
- The request headers look like
```
Content-Type:application/json
Authorization:Token token=fK2qGmQa73iH758DAuaWphtk
```
- Please import the [Postman collection](https://github.com/darth-dodo/commit-bridge/blob/master/commit-bridge.postman_collection.json) to interact with the application
- Sample response can also be found over here
    - [Pull Request Event](https://github.com/darth-dodo/commit-bridge/blob/master/.sample_responses/pull_request_event_response.json)
    - [Push Request Event](https://github.com/darth-dodo/commit-bridge/blob/master/.sample_responses/push_request_event_response.json)
    - [Release Request Event](https://github.com/darth-dodo/commit-bridge/blob/master/.sample_responses/release_request_event_response.json)


---
## External APIs
- The External API credentials should be maintained using environment variables in the `.env` file
- External API are being communicated through a facade which is used to abstract out the complexity of request creation and response parsing
- The Ticket Tracking API client is present over [here](https://github.com/darth-dodo/commit-bridge/blob/master/app/lib/ticket_tracking_api.rb)
- The [Communicator](https://github.com/darth-dodo/commit-bridge/blob/master/app/lib/ticket_tracking_communicator.rb) is used to create headers, send web request and process responses and exceptions
- We are assuming the Ticket Tracking API has token based auth and token is stored in the `.env`
- Example usage of the client
```rb
new_client = TicketTrackingApi::Client.new()
payload = {"query": "released", "issues": [{"id": 66}]}
response = new_client.update_tickets_across_commit(payload)
puts response

```
- The client is consumed through a [service] which is tasked with the payload generation and navigate code flow based on external client exception (`ExternalApiException`)


---
## Custom Middlewares and RESTful Errors
- Application layer custom exceptions are registered in [`CommitBridgeExceptions`](https://github.com/darth-dodo/commit-bridge/blob/master/app/lib/commit_bridge_exceptions.rb)
- External API Exceptions are registered in [`ExternalExceptions`](https://github.com/darth-dodo/commit-bridge/blob/master/app/lib/external_exceptions.rb) and these are based class from Application Exception `ExternalApiException`
- Status codes for parsing external requests are registered in [`HttpStatusCode`](https://github.com/darth-dodo/commit-bridge/blob/master/app/lib/external_exceptions.rb)
- Messages for client/consumer facing interface can be registered in [`Message`](https://github.com/darth-dodo/commit-bridge/blob/master/app/lib/external_exceptions.rb)
- API Exceptions, both internal and external are handled by the application [`ExceptionHandler`](https://github.com/darth-dodo/commit-bridge/blob/master/app/lib/exception_handler.rb)
- The [APIController](https://github.com/darth-dodo/commit-bridge/blob/master/app/controllers/api_controller.rb) includes the `ExceptionHandler` and entire application is subclassed from this controller


---
## Test Cases
- Test cases are written using [RSpec](https://relishapp.com/rspec/)
- A few helper RSpec utils are placed in `CommitBridgeSpecHelper`
- [FactoryBot](https://github.com/thoughtbot/factory_bot/) is used to working with models
- [Faker](https://github.com/faker-ruby/faker) is used to generate fake data instead of hardcoding values
- [Timecop](https://github.com/travisjeffery/timecop) is used for moving around time in tests


---
## Active Admin
- The intent of adding an Active Admin was to have a more visual representation of the data
- The Active Admin can be extended to cover custom use cases if required
- Currently the Active Admin has just readonly mode by purpose of keeping the data immutable.


---
## Caching and API Throttling
- API throttling is implementing using [Rack Attack](https://github.com/kickstarter/rack-attack)
- The throttling policy is present in the Rack attack [initializer](https://github.com/darth-dodo/commit-bridge/blob/master/config/initializers/rack_attack.rb)
- The limits can be controlled through the `.env` variable ` DAILY_IP_REQUEST_QUOTA`
- The data is store in the Redis cache attached to the application if not, it will use the in memory cache as the default
- Testing via [Artillery](https://github.com/artilleryio/artillery) to make sure the throttling is working as expected
- More complex throttling policies and feedbacks can be set using an approach similar to [this](https://vitobotta.com/2019/09/24/protecting-rails-app-from-small-scripted-attacks/) or [this](https://blog.bigbinary.com/2018/05/15/how-to-mitigate-ddos-using-rack-attack.html) with exponential back-offs and detailed logging
- Helper commands for loadtesting are present in the [`helper_commands`](https://github.com/darth-dodo/commit-bridge/blob/master/helper_commands.md) file
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


---
## Deployment Strategy
- The service can be deployed on Heroku or AWS EC2/RDS instances based on the requirements and financial capacity
- A Continuous Integration interface such as CircleCI or TravisCI which are hooked on to RSpec
- A Continuous Deployment can be easily achieved through Heroku pipelines or with AWS by Github Actions and AWS CodePipeline
- Any scripts that need to be run before a deployment is made can be done using a `Rake` tasks


---
# Mentionables

## Application Design Mindset
Some of the key points I keep in mind while writing software:
- APIs are like User Interfaces for Developers
- Think schemas as entities or actors
- SRP and Open/Close
- Favour composition over inheritance
- Code is as good as the tests
- Consistency matters (eg. Service objects, Rubcop, Best Practise)
- Sometimes `magic` is good (`execute!` and middlewares) (only sometimes*)
- Make it run. Then make it run faster (if required and proven by data)
- Personal Learnings: T. A. [R. O. T.] problem solving mindset - Top/Bottom, Algorithms/Steps, Refactor, Optimize, Test. *R, O, T are reordered according to priority*

## Readability
- In order to enforce coding standards, uniformity and consistency, the application uses precommit hooks with the help of `overcommit`
- The code formatted used is `Rubocop` which is used by several open source Ruby/Rails projects to maintain code guidelines and consistency eg. Shopify, Rails
- Besides this, several precommit hooks confirm that actions deemed harmful to the codebase aren't committed.
- Several more hooks as listed in the feature list are used for maintaining code quality
- The API interface is accessible using the Postman collection and is ready for client side consumption
- Specs favour fixtures, fake data and factories for operating with data

## Resilience
### Internal Facing
- Test cases are added to make the application layer more robust
- Test Suite can be hooked up to a CI interface
- In case a test case breaks, it should not move to CD interface

### External Facing
- Errors and Exceptions are managed through Sentry
- RESTful JSON payloads are returned in case of errors

## Security
- Since this application exposes Webhooks to external clients, security was of a major concern
- Client communicate using API keys for auth purposes as described above
- The API Keys can be revoked quickly and have a default expiry of 2 weeks
- In order to prevent abuse of the APIs, throttling is set into place
- The throttling limits can be configured using environment variables
- The existing keys/states of the users can be flushed out from Redis by writing a custom `rake` command
- In case of status code `429`, a custom middleware can be written to intercept such responses and fire a Sentry Alert or create a log for escalation and inspection purposes respectively

## Commit History
- A feature list/roadmap was creating in the ReadMe section and the features were developed accordingly
- Each feature is related to a group of similar things (Development environment setup) or an Individual component (Model test cases)
- Pull requests are created across the `master` branch from these `feature` branches and the PRs are attached to the corresponding Feature List element in the ReadMe
- At any point, the entire history of the project can be viewed using a tool such as `gitk` or `SourceTree` or `GitKraken`


---

## Cleaner Approach
- If the event could be posted to `slug` based params, event types delegation will be responsibility of the client which can be directly routed to the appropriate service from the `WebhookEventParser` service
```
- localhost:3000/webhooks/git/pull/
- localhost:3000/webhooks/git/push/
- localhost:3000/webhooks/git/release/
```

## Alternative Design Solutions
In increasing order of complexity
- Using [Sidekiq](https://github.com/mperham/sidekiq) or Reque to process the API payloads in background
- Background jobs for processing failed external API calls
- Extensive use of callbacks/pubsub ([Wisper](https://github.com/krisleech/wisper)) for internal event driven architecture
- FSM based external API call using gems such as [AASM](https://github.com/aasm/aasm)
- Event driven Architecture using Message Queue
- Event Driven Architecture using Message Bus


---
# Post Script
- The project was started about 9 days ago on [28th March](https://github.com/darth-dodo/commit-bridge/pull/1) and handed off on 6th April. As communicated earlier, due to personal and professional reasons I could not start it earlier. Thank for you the extension of a week! :)
- All development done on the project **after the handover** can be found on the `epic/post-handover` branch
- The project does not have complete RSpec coverage and it will be performed after codebase handover
as I ran out of time
- I have tried to cover tests for one of each family (services/models) to give an idea about how I would go about building the test suite
- I would like to explore `WebMock` and `VCR` for learning how to test better
- For more consistent and robust code, I would like to implement the following gems
    - [Sorbet](https://github.com/sorbet/sorbet) - For typechecks
    - [Apipie](https://github.com/apipie/apipie-rails) for API documentation
    - [VCR](https://github.com/vcr/vcr) - for external requests testing
    - [WebMock](https://github.com/bblimke/webmock) - for external requests testing
    - [Knock](https://github.com/nsarno/knock) - for JWT
    - [Grape](https://github.com/ruby-grape/grape) - for APIs

---
# Next Steps
- Improve the test suite
- Learn how to use WebMock and VCR
- Learn stubbing and mocking use cases
- Explore ActionCable implementation for two way binding with the Api Clients
- Explore serialization related gems such as fastjson_api, ActiveSerializer
- Explore FSM related gems
- Integrate the database with [Metabase](https://github.com/metabase/metabase) for building dashboards using native SQL
- Explore more "Production Readiness" gems to increase my Rails Project Dev -> Production Knowledge
