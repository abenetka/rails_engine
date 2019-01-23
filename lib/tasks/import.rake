require 'csv'

namespace :import do
  desc "Imports customer data from CSV"
  task customers: :environment do
    CSV.foreach('./db/data/customers.csv', :headers => true) do |row|
      Customer.create!(row.to_h)
    end
  end

  desc "Imports merchant data from CSV"
  task :merchants => :environment do
    CSV.foreach('./db/data/merchants.csv', :headers => true) do |row|
      Merchant.create!(row.to_h)
    end
  end

  desc "Imports invoice data from CSV"
  task :invoices => :environment do
    CSV.foreach('./db/data/invoices.csv', :headers => true) do |row|
      Invoice.create!(row.to_h)
    end
  end

  desc "Imports item data from CSV"
  task :items => :environment do
    CSV.foreach('./db/data/items.csv', :headers => true) do |row|
      Item.create!(row.to_h)
    end
  end

  desc "Imports invoice_item data from CSV"
  task :invoice_items => :environment do
    CSV.foreach('./db/data/invoice_items.csv', :headers => true) do |row|
      InvoiceItem.create!(row.to_h)
    end
  end

  desc "Imports transaction data from CSV"
  task :transactions => :environment do
    CSV.foreach('./db/data/transactions.csv', :headers => true) do |row|
      Transaction.create!(row.to_h)
    end
  end

  desc "Imports ALL data from CSV"
  task :all => :envirionment do
    Rake::Task[:customers].invoke
    Rake::Task[:merchants].invoke
    Rake::Task[:invoices].invoke
    Rake::Task[:items].invoke
    Rake::Task[:invoice_items].invoke
    Rake::Task[:transactions].invoke
  end

end
