# Rails Engine



Welcome to our Little Shop of Dog Costumes!  We hope you enjoy our app!

Rails Engine is a project for backend students at [Turing School of Software & Design](https://turing.io/) during their first week of Module 3 where we're learning to build Professional Rails Applications.  The learning goals for the project were:
- Learn how to to build Single-Responsibility controllers to provide a well-designed and versioned API.
- Learn how to use controller tests to drive your design.
- Use Ruby and ActiveRecord to perform more complicated business intelligence.

### Rails Engine Project Spec:

http://backend.turing.io/module3/projects/rails_engine#evaluation

### Rails Engine - Database Schema:

![Image description](https://imggmi.com/full/2019/1/28/2587b40f9a834117264784af76e3f8b4-full.png.html)


## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.

#### Prerequisites:

* Install Ruby (Version 2.4.5)
* Install Rails (Version 5.1)



#### Installing:

To run this application locally, clone this [repo](https://github.com/abenetka/rails_engine) and follow the steps below:

1) Install gems:
```
$ bundle
```


2) Create, migrate, & seed database:
```
$ rake db:{create,migrate,seed}
```


3) Import CSV data
```
$ rake import:all

```
or individually
```
$ rake import:<table name>
```

4) Run Rails Server
```
$ rails s
```

5) Open browser and navigate to:

```
localhost:3000
```


## Running the RSpec Test Suite

Rails Engine has a full RSpec suite of feature and model tests for every piece of functionality in the app.

#### Running the Full Test Suite:

From the root of the rails_enginer directory, type the below command to run the full test suite:

```
$ rspec
```

## Built With

* [Ruby - Version 2.4.5](https://ruby-doc.org/core-2.4.5/) - Base code language
* [Rails - Version 5.1](https://guides.rubyonrails.org/v5.1/) - Web framework used
* [RSpec](http://rspec.info/documentation/) - Testing Suite


## Authors

* **Ali Benetka** - [Ali's Github](https://github.com/abenetka)

