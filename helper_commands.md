# [Rails Annotate](https://github.com/ctran/annotate_models)
- Create model annotations `annotate --models --exclude fixtures --show-foreign-keys --show-indexes --classified-sort`
- Delete annotations `annotate --delete`

# Rails
- `rake db:create` for creating the db
- `rake db:drop` for dropping the db
- `rake db:migrate` for doing the database migrations
- `rake db:seed` for seeding the db
- `rake db:drop && rake db:create && rake db:migrate && rake db:seed` - for resetting the database
- `bundle exec puma` for running the Rails Server in multi threading mode (for echo feature)
- `rspec spec/ -fd` for running RSpec in verbose mode


## Caching
- Caching is done using Redis
- Redis database can be opened using `redis-cli -n 1`
- The keys can be viewed using `keys *`
- Use the command `FLUSHALL` to remove all the keys

## Load testing
- Load testing can be done using [Artillery](https://github.com/artilleryio/artillery)
- Sample Quick Command eg
```
artillery quick --count 10 -n 20 "http://localhost:3000/webhooks/ticket-tracking-echo/" -p '{"echo": "is loud and clear!"}'

```
