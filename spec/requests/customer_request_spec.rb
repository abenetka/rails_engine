require 'rails_helper'

describe "Customers API" do
  it "shows a list of customers" do
    create_list(:customer, 3)

    get '/api/v1/customers'

    expect(response).to be_successful

    customers = JSON.parse(response.body)

    expect(customers["data"].count).to eq(3)
  end

  it "can show a customer" do
    customer_id = create(:customer).id

    get "/api/v1/customers/#{customer_id}"

    customer = JSON.parse(response.body)

    expect(response).to be_successful
    expect(customer["data"]["id"]).to eq(customer_id.to_s)
  end

  it "can find a customer by id" do
    customer_id = create(:customer).id

    get "/api/v1/customers/find?id=#{customer_id}"

    customer = JSON.parse(response.body)
    expect(response).to be_successful
    expect(customer["data"]["id"]).to eq(customer_id.to_s)
  end

  it "can find a customer by first name" do
    customer_name = create(:customer).first_name

    get "/api/v1/customers/find?first_name=#{customer_name}"
    customer = JSON.parse(response.body)

    expect(response).to be_successful
    expect(customer["data"]["attributes"]["first_name"]).to eq(customer_name.to_s)
  end

  it "can find a customer by last name" do
    customer_last = create(:customer).last_name

    get "/api/v1/customers/find?last_name=#{customer_last}"
    customer = JSON.parse(response.body)

    expect(response).to be_successful
    expect(customer["data"]["attributes"]["last_name"]).to eq(customer_last.to_s)
  end

  it "can find a customer by created at" do
    date = "2012-03-27 14:54:09 UTC"
    customer = create(:customer, created_at: date)

    get "/api/v1/customers/find?created_at=#{date}"
    returned_customer = JSON.parse(response.body)

    expect(response).to be_successful
    expect(returned_customer["data"]["id"]).to eq(customer.id.to_s)
  end

  it "can find a customer by updated at" do
    date = "2012-03-29 02:54:10 UTC"
    customer = create(:customer, updated_at: date)

    get "/api/v1/customers/find?updated_at=#{date}"
    returned_customer = JSON.parse(response.body)

    expect(response).to be_successful
    expect(returned_customer["data"]["id"]).to eq(customer.id.to_s)
  end
end
