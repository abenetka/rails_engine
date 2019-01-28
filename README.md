# Rails Engine



Welcome to our Little Shop of Dog Costumes!  We hope you enjoy our app!

Rails Engine is a project for backend students at [Turing School of Software & Design](https://turing.io/) during their first week of Module 3 where we're learning to build Professional Rails Applications.  The learning goals for the project were:
- Learn how to to build Single-Responsibility controllers to provide a well-designed and versioned API.
- Learn how to use controller tests to drive your design.
- Use Ruby and ActiveRecord to perform more complicated business intelligence.

### Rails Engine Project Spec:

http://backend.turing.io/module3/projects/rails_engine

### Rails Engine - Database Schema:

![Image description](https://cdn1.imggmi.com/uploads/2019/1/28/2587b40f9a834117264784af76e3f8b4-full.png)

### Rails Engine - Relationship Endpoints
Merchants
- GET /api/v1/merchants/:id/items returns a collection of items associated with that merchant
- GET /api/v1/merchants/:id/invoices returns a collection of invoices associated with that merchant from their known orders
Invoices
- GET /api/v1/invoices/:id/transactions returns a collection of associated transactions
- GET /api/v1/invoices/:id/invoice_items returns a collection of associated invoice items
- GET /api/v1/invoices/:id/items returns a collection of associated items
- GET /api/v1/invoices/:id/customer returns the associated customer
- GET /api/v1/invoices/:id/merchant returns the associated merchant
Invoice Items
- GET /api/v1/invoice_items/:id/invoice returns the associated invoice
- GET /api/v1/invoice_items/:id/item returns the associated item
Items
- GET /api/v1/items/:id/invoice_items returns a collection of associated invoice items
-  GET /api/v1/items/:id/merchant returns the associated merchant
Transactions
- GET /api/v1/transactions/:id/invoice returns the associated invoice
Customers
- GET /api/v1/customers/:id/invoices returns a collection of associated invoices
- GET /api/v1/customers/:id/transactions returns a collection of associated transactions

### Rails Engine- Business Intelligence Endpoints

All Merchants
- GET /api/v1/merchants/most_revenue?quantity=x returns the top x merchants ranked by total revenue
- GET /api/v1/merchants/most_items?quantity=x returns the top x merchants ranked by total number of items sold
- GET /api/v1/merchants/revenue?date=x returns the total revenue for date x across all merchants
Assume the dates provided match the format of a standard ActiveRecord timestamp.

Single Merchant
- GET /api/v1/merchants/:id/revenue returns the total revenue for that merchant across successful transactions
- GET /api/v1/merchants/:id/revenue?date=x returns the total revenue for that merchant for a specific invoice date x
- GET /api/v1/merchants/:id/favorite_customer returns the customer who has conducted the most total number of successful transactions.
- BOSS MODE: GET /api/v1/merchants/:id/customers_with_pending_invoices returns a collection of customers which have pending (unpaid) invoices. A pending invoice has no transactions with a result of success. This means all transactions are failed. Postgres has an EXCEPT operator that might be useful. ActiveRecord also has a find_by_sql that might help.
 
Items
- GET /api/v1/items/most_revenue?quantity=x returns the top x items ranked by total revenue generated
- GET /api/v1/items/most_items?quantity=x returns the top x item instances ranked by total number sold
- GET /api/v1/items/:id/best_day returns the date with the most sales for the given item using the invoice date. If there are multiple days with equal number of sales, return the most recent day.
Customers
- GET /api/v1/customers/:id/favorite_merchant returns a merchant where the customer has conducted the most successful transactions

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

