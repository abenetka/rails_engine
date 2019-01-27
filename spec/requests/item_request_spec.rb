require 'rails_helper'
require 'time'

describe "Items API" do
  it "shows a list of items" do
    create_list(:item, 3)

    get '/api/v1/items'

    expect(response).to be_successful

    item = JSON.parse(response.body)

    expect(item["data"].count).to eq(3)
  end

  it "can show a item" do
    item_id = create(:item).id

    get "/api/v1/items/#{item_id}"

    item = JSON.parse(response.body)

    expect(response).to be_successful
    expect(item["data"]["id"]).to eq(item_id.to_s)
  end

  it "can find a item by id" do
    item_id = create(:item).id

    get "/api/v1/items/find?id=#{item_id}"

    item = JSON.parse(response.body)
    expect(response).to be_successful
    expect(item["data"]["id"]).to eq(item_id.to_s)
  end

  it "can find a item by name" do
    item_name = create(:item).name

    get "/api/v1/items/find?name=#{item_name}"
    item = JSON.parse(response.body)

    expect(response).to be_successful
    expect(item["data"]["attributes"]["name"]).to eq(item_name)
  end

  it "can find a item by name" do
    item_description = create(:item).description

    get "/api/v1/items/find?description=#{item_description}"
    item = JSON.parse(response.body)

    expect(response).to be_successful
    expect(item["data"]["attributes"]["description"]).to eq(item_description)
  end

  it "can find a item by unit_price" do
    item_unit_price = create(:item).unit_price

    get "/api/v1/items/find?unit_price=#{item_unit_price}"
    item = JSON.parse(response.body)

    expect(response).to be_successful
    expect(item["data"]["attributes"]["unit_price"]).to eq(item_unit_price)
  end

  it "can find a item by created at" do
    date = "2012-03-27 14:54:09 UTC"
    item = create(:item, created_at: date)

    get "/api/v1/items/find?created_at=#{date}"
    returned_item = JSON.parse(response.body)

    expect(response).to be_successful
    expect(returned_item["data"]["id"]).to eq(item.id.to_s)
  end

  it "can find a item by updated at" do
    date = "2012-03-29 02:54:10 UTC"
    item = create(:item, updated_at: date)

    get "/api/v1/items/find?updated_at=#{date}"
    returned_item = JSON.parse(response.body)

    expect(response).to be_successful
    expect(returned_item["data"]["id"]).to eq(item.id.to_s)
  end
end

describe 'items stats' do
  before :each do
    @merchant_1 = create(:merchant)
    @merchant_2 = create(:merchant)
    @merchant_3 = create(:merchant)

    @customer_1 = create(:customer)
    @customer_2 = create(:customer)
    @customer_3 = create(:customer)

    @item_1 = create(:item, merchant: @merchant_1)
    @item_2 = create(:item, merchant: @merchant_2)
    @item_3 = create(:item, merchant: @merchant_3)

    @invoice_1 = create(:invoice, merchant: @merchant_1, customer: @customer_1, updated_at: '2012-03-27 14:54:09 UTC')
    @invoice_item_1 = create(:invoice_item, item: @item_1, invoice: @invoice_1, quantity: 1, unit_price: 2000)

    @invoice_2 = create(:invoice, merchant: @merchant_2, customer: @customer_1,  updated_at: '2012-03-24 14:54:09 UTC')
    @invoice_item_2 = create(:invoice_item, item: @item_2, invoice: @invoice_2, quantity: 3, unit_price: 300)

    @invoice_3 = create(:invoice, merchant: @merchant_3, customer: @customer_2,  updated_at: '2012-03-23 14:54:09 UTC')
    @invoice_item_3 = create(:invoice_item, item: @item_3, invoice: @invoice_3, quantity: 5, unit_price: 200)

    @invoice_4 = create(:invoice, merchant: @merchant_1, customer: @customer_2,  updated_at: '2012-03-23 14:54:09 UTC')
    @invoice_item_4 = create(:invoice_item, item: @item_1, invoice: @invoice_4, quantity: 1, unit_price: 200)

    @transaction_1 = create(:transaction, invoice: @invoice_1, result: 'success', updated_at: '2012-03-27 14:54:09 UTC')
    @transaction_2 = create(:transaction, invoice: @invoice_2, result: 'success', updated_at: '2012-03-27 14:54:09 UTC')
    @transaction_3 = create(:transaction, invoice: @invoice_3, result: 'success', updated_at: '2012-03-26 14:54:09 UTC')
  end

  it 'returns the top x items ranked by total revenue generated' do
    count =  3
    item_id = @item_1.id

    get "/api/v1/items/most_revenue?quantity=#{count}"
    returned_item = JSON.parse(response.body)

    expect(response).to be_successful
    expect(returned_item["data"][0]["id"]).to eq(item_id.to_s)
  end

  it 'returns the top x items ranked by total number items sold' do
    count =  3
    item_id = @item_3.id

    get "/api/v1/items/most_items?quantity=#{count}"
    returned_item = JSON.parse(response.body)

    expect(response).to be_successful
    expect(returned_item["data"][0]["id"]).to eq(item_id.to_s)
  end

  it 'returns the date with the most sales for the given item by invoice date' do
    invoice_date = '2012-03-27 14:54:09 UTC'
    item_id = @item_3.id

    get "/api/v1/items/#{item_id}/best_day"
    returned_item = JSON.parse(response.body)

    expect(response).to be_successful
    expect(returned_item["data"]["best_day"][0..9]).to eq(invoice_date[0..9])
  end
end
