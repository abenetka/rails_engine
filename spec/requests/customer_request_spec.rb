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

end
