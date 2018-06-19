# Package Tracking API

This is a Rails app to track drugs around a hospital. Drugs must always be in some type of package but the package they are in can change over time.

To create a package example:
```
curl -H "Content-Type: application/json" -X POST -d '{"package":{"drugs":[{"name":"Lidocaine","expiration_dates":["2013/10/11","2013/01/30"]},{"name":"Epinephrine","expiration_dates":["2014/10/11"]}]}}' localhost:3000/api/v1/packages
```

To update a package example: (Make sure to include the id of the package that you want to update)
localhost:3000/api/v1/packages/7 => id is 7 in this example
```
curl -H "Content-Type: application/json" -X PUT -d '{"package": {"drugs": [{"name": "Epinephrine", "expiration_dates": ["2011/10/11"]}]}}' localhost:3000/api/v1/packages/7
```

To get a list of packages example:
```
curl -H "Content-Type: application/json" -X GET localhost:3000/api/v1/packages
```

This should result in:

```
{
  "packages": [{
    "id": 1,
    "drugs": ["Lidocaine", "Ephinephrine"],
    "expiration": "2013/01/30"
  }]
}
```
### Setup
```
- Download into your directory of your choice.
- \curl -sSL https://get.rvm.io  => Install RVM if you don't have one
- rvm install "ruby-2.5.0" => install ruby 2.5.0
- gem install bundler
- bundle install
- rake db:create && rake db:migrate
- Run 'rails s -p 3000'
- Once the server is running, open another Terminal window on Mac
- Run the curl commmand above to create, update and get packages


```
## Running the tests

```
rails test test/controllers/packages_controller_test.rb
```

