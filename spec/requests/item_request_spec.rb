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
    expect(item["data"]["attributes"]["unit_price"]).to eq(item_unit_price.to_f.to_s)
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

  it "can find all items by id" do
    item_id_1 = create(:item).id
    item_id_2 = create(:item).id
    item_id_3 = create(:item).id

    get "/api/v1/items/find_all?id=#{item_id_1}"

    item = JSON.parse(response.body)

    expect(response).to be_successful
    expect(item["data"][0]["id"]).to eq(item_id_1.to_s)
  end

  it "can find all items by name" do
    item_name_1 = create(:item, name: "Item 1").name
    item_name_2 = create(:item, name: "Item 2").name
    item_name_3 = create(:item, name: "Item 1").name

    get "/api/v1/items/find_all?name=#{item_name_1}"

    item = JSON.parse(response.body)

    expect(response).to be_successful
    expect(item["data"].count).to eq(2)
    expect(item["data"][0]["attributes"]["name"]).to eq(item_name_1.to_s)
    expect(item["data"][1]["attributes"]["name"]).to eq(item_name_3.to_s)
  end

  it "can find all items by description" do
    item_description_1 = create(:item, description: "This is an item").description
    item_description_2 = create(:item, description: "This is an item").description
    item_description_3 = create(:item, description: "This is another item").description

    get "/api/v1/items/find_all?description=#{item_description_1}"

    item = JSON.parse(response.body)

    expect(response).to be_successful
    expect(item["data"].count).to eq(2)
    expect(item["data"][0]["attributes"]["description"]).to eq(item_description_1.to_s)
    expect(item["data"][1]["attributes"]["description"]).to eq(item_description_2.to_s)
  end

  it "can find all items by unit_price" do
    item_unit_price_1 = create(:item, unit_price: 2).unit_price
    item_unit_price_2 = create(:item, unit_price: 3).unit_price
    item_unit_price_3 = create(:item, unit_price: 2).unit_price

    get "/api/v1/items/find_all?unit_price=#{item_unit_price_1}"

    item = JSON.parse(response.body)

    expect(response).to be_successful
    expect(item["data"].count).to eq(2)
    expect(item["data"][0]["attributes"]["unit_price"]).to eq(item_unit_price_1.to_f.to_s)
    expect(item["data"][1]["attributes"]["unit_price"]).to eq(item_unit_price_3.to_f.to_s)
  end

  it "can find all items by created_at" do
    date = "2012-03-29 02:54:10 UTC"
    item_created_at_1 = create(:item, created_at: "2012-03-30 02:54:10 UTC")
    item_created_at_2 = create(:item, created_at: "2012-03-29 02:54:10 UTC")
    item_created_at_3 = create(:item, created_at: "2012-03-29 02:54:10 UTC")

    get "/api/v1/items/find_all?created_at=#{date}"

    returned = JSON.parse(response.body)

    expect(response).to be_successful
    expect(returned["data"][0]["id"]).to eq(item_created_at_2.id.to_s)
    expect(returned["data"][1]["id"]).to eq(item_created_at_3.id.to_s)
    expect(returned["data"].count).to eq(2)
  end

  it "can find all items by updated_at" do
    date = "2012-03-25 02:54:10 UTC"
    item_updated_at_1 = create(:item, updated_at: "2012-03-25 02:54:10 UTC")
    item_updated_at_2 = create(:item, updated_at: "2012-03-29 02:54:10 UTC")
    item_updated_at_3 = create(:item, updated_at: "2012-03-29 02:54:10 UTC")

    get "/api/v1/items/find_all?updated_at=#{date}"

    returned = JSON.parse(response.body)

    expect(response).to be_successful
    expect(returned["data"][0]["id"]).to eq(item_updated_at_1.id.to_s)
    expect(returned["data"].count).to eq(1)
  end

  it "can return a random item" do
    item_1 = create(:item)
    item_2 = create(:item)
    item_3 = create(:item)

    get "/api/v1/items/random"

    returned = JSON.parse(response.body)

    expect(response).to be_successful
    expect(returned["data"]["type"]).to eq("item")
    expect(returned.count).to eq(1)
  end
end

describe 'items stats and relationship endpoints' do
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

  it 'returns a collection of associated invoice items' do
    item_id = @item_1.id
    invoice_item_id_1 = @invoice_item_1.id
    invoice_item_id_2 = @invoice_item_4.id

    get "/api/v1/items/#{item_id}/invoice_items"
    returned = JSON.parse(response.body)

    expect(response).to be_successful
    expect(returned["data"][0]["type"]).to eq("invoice_item")
    expect(returned["data"][0]["id"]).to eq(invoice_item_id_1.to_s)
    expect(returned["data"][1]["id"]).to eq(invoice_item_id_2.to_s)
    expect(returned["data"].count).to eq(2)
  end

  it 'returns the associated merchant' do
    item_id = @item_1.id
    merchant_id_1 = @merchant_1.id

    get "/api/v1/items/#{item_id}/merchant"
    returned = JSON.parse(response.body)

    expect(response).to be_successful
    expect(returned["data"]["type"]).to eq("merchant")
    expect(returned["data"]["id"]).to eq(merchant_id_1.to_s)
  end

end
