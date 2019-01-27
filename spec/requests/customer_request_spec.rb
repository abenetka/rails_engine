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

describe 'customer stats' do
  before :each do
    @merchant_1 = create(:merchant)
    @merchant_2 = create(:merchant)
    @merchant_3 = create(:merchant)

    @customer_1 = create(:customer)
    @customer_2 = create(:customer)
    @customer_3 = create(:customer)

    @item_1 = create(:item, merchant: @merchant_1)
    @item_2 = create(:item, merchant: @merchant_1)
    @item_3 = create(:item, merchant: @merchant_2)

    @invoice_1 = create(:invoice, merchant: @merchant_1, customer: @customer_1, updated_at: '2012-03-23 14:54:09 UTC')
    @invoice_item_1 = create(:invoice_item, item: @item_1, invoice: @invoice_1, quantity: 1, unit_price: 2000)

    @invoice_2 = create(:invoice, merchant: @merchant_1, customer: @customer_1,  updated_at: '2012-03-24 14:54:09 UTC')
    @invoice_item_2 = create(:invoice_item, item: @item_2, invoice: @invoice_2, quantity: 3, unit_price: 300)

    @invoice_3 = create(:invoice, merchant: @merchant_2, customer: @customer_1,  updated_at: '2012-03-23 14:54:09 UTC')
    @invoice_item_3 = create(:invoice_item, item: @item_3, invoice: @invoice_3, quantity: 5, unit_price: 200)

    @invoice_4 = create(:invoice, merchant: @merchant_1, customer: @customer_2,  updated_at: '2012-03-24 14:54:09 UTC')
    @invoice_item_4 = create(:invoice_item, item: @item_1, invoice: @invoice_4, quantity: 1, unit_price: 200)

    @invoice_5 = create(:invoice, merchant: @merchant_1, customer: @customer_2,  updated_at: '2012-03-24 14:54:09 UTC')
    @invoice_item_5 = create(:invoice_item, item: @item_2, invoice: @invoice_5, quantity: 3, unit_price: 200)

    @invoice_6 = create(:invoice, merchant: @merchant_2, customer: @customer_2,  updated_at: '2012-03-24 14:54:09 UTC')
    @invoice_item_6 = create(:invoice_item, item: @item_3, invoice: @invoice_6, quantity: 1, unit_price: 200)

    @transaction_1 = create(:transaction, invoice: @invoice_1, result: 'success', updated_at: '2012-03-27 14:54:09 UTC')
    @transaction_2 = create(:transaction, invoice: @invoice_2, result: 'success', updated_at: '2012-03-27 14:54:09 UTC')
    @transaction_3 = create(:transaction, invoice: @invoice_3, result: 'success', updated_at: '2012-03-26 14:54:09 UTC')
    @transaction_4 = create(:transaction, invoice: @invoice_4, result: 'success', updated_at: '2012-03-26 14:54:09 UTC')
    @transaction_5 = create(:transaction, invoice: @invoice_5, result: 'failed', updated_at: '2012-03-26 14:54:09 UTC')
    @transaction_6 = create(:transaction, invoice: @invoice_6, result: 'failed', updated_at: '2012-03-26 14:54:09 UTC')
  end

  it 'returns a merchant where the customer has conducted the most successful transactions' do
    customer_id = @customer_1.id
    merchant_id = @merchant_1.id

    get "/api/v1/customers/#{customer_id}/favorite_merchant"
    returned_customer = JSON.parse(response.body)

    expect(response).to be_successful
    expect(returned_customer["data"]["favorite_merchant"][0]["id"]).to eq(merchant_id)
  end

  it 'returns a collection of associated invoices' do
    customer_id = @customer_1.id
    invoice_id_1 = @invoice_1.id
    invoice_id_2 = @invoice_2.id
    invoice_id_3 = @invoice_3.id

    get "/api/v1/customers/#{customer_id}/invoices"
    returned = JSON.parse(response.body)

    expect(response).to be_successful
    expect(returned["data"][0]["type"]).to eq("invoice")
    expect(returned["data"][0]["id"]).to eq(invoice_id_1.to_s)
    expect(returned["data"][1]["id"]).to eq(invoice_id_2.to_s)
    expect(returned["data"][2]["id"]).to eq(invoice_id_3.to_s)
    expect(returned["data"].count).to eq(3)
  end

  it 'returns a collection of associated transactions' do
    customer_id = @customer_1.id
    transaction_id_1 = @transaction_1.id
    transaction_id_2 = @transaction_2.id
    transaction_id_3 = @transaction_3.id

    get "/api/v1/customers/#{customer_id}/transactions"
    returned = JSON.parse(response.body)

    expect(response).to be_successful
    expect(returned["data"][0]["type"]).to eq("transaction")
    expect(returned["data"][0]["id"]).to eq(transaction_id_1.to_s)
    expect(returned["data"][1]["id"]).to eq(transaction_id_2.to_s)
    expect(returned["data"][2]["id"]).to eq(transaction_id_3.to_s)
    expect(returned["data"].count).to eq(3)
  end

# GET /api/v1/customers/:id/transactions returns a collection of associated transactions


end
