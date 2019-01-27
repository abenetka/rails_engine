require 'rails_helper'

describe "Invoice Items API" do
  it "shows a list of invoice_item" do
    create_list(:invoice_item, 3)

    get '/api/v1/invoice_items'

    expect(response).to be_successful

    invoice_item = JSON.parse(response.body)

    expect(invoice_item["data"].count).to eq(3)
  end

  it "can show a invoice_item" do
    invoice_item_id = create(:invoice_item).id

    get "/api/v1/invoice_items/#{invoice_item_id}"

    invoice_item = JSON.parse(response.body)

    expect(response).to be_successful
    expect(invoice_item["data"]["id"]).to eq(invoice_item_id.to_s)
  end

  it "can find a invoice_item by id" do
    invoice_item_id = create(:invoice_item).id

    get "/api/v1/invoice_items/find?id=#{invoice_item_id}"

    invoice_item = JSON.parse(response.body)
    expect(response).to be_successful
    expect(invoice_item["data"]["id"]).to eq(invoice_item_id.to_s)
  end

  it "can find a invoice_item by quantity" do
    invoice_item_quantity = create(:invoice_item).quantity

    get "/api/v1/invoice_items/find?quantity=#{invoice_item_quantity}"
    invoice_item = JSON.parse(response.body)

    expect(response).to be_successful
    expect(invoice_item["data"]["attributes"]["quantity"]).to eq(invoice_item_quantity)
  end

  it "can find a invoice_item by unit_price" do
    invoice_item_unit_price = create(:invoice_item).unit_price

    get "/api/v1/invoice_items/find?unit_price=#{invoice_item_unit_price}"
    invoice_item = JSON.parse(response.body)

    expect(response).to be_successful
    expect(invoice_item["data"]["attributes"]["unit_price"]).to eq(invoice_item_unit_price)
  end

  it "can find a invoice_item by created at" do
    date = "2012-03-27 14:54:09 UTC"
    invoice_item = create(:invoice_item, created_at: date)

    get "/api/v1/invoice_items/find?created_at=#{date}"
    returned_invoice_item = JSON.parse(response.body)

    expect(response).to be_successful
    expect(returned_invoice_item["data"]["id"]).to eq(invoice_item.id.to_s)
  end

  it "can find a invoice_item by updated at" do
    date = "2012-03-29 02:54:10 UTC"
    invoice_item = create(:invoice_item, updated_at: date)

    get "/api/v1/invoice_items/find?updated_at=#{date}"
    returned_invoice_item = JSON.parse(response.body)

    expect(response).to be_successful
    expect(returned_invoice_item["data"]["id"]).to eq(invoice_item.id.to_s)
  end
end

describe "Invoice Item relationship endpoints" do
  before :each do
    @merchant_1 = create(:merchant, name: "Merchant 1")
    @customer_1 = create(:customer)
    @customer_2 = create(:customer)

    @item_1 = create(:item, merchant: @merchant_1)
    @item_2 = create(:item, merchant: @merchant_1)
    @item_3 = create(:item, merchant: @merchant_1)

    @invoice_1 = create(:invoice, merchant: @merchant_1, customer: @customer_1, updated_at: '2012-03-27 14:54:09 UTC')
    @invoice_item_1 = create(:invoice_item, item: @item_1, invoice: @invoice_1, quantity: 1, unit_price: 2000)
    @invoice_item_2 = create(:invoice_item, item: @item_2, invoice: @invoice_1, quantity: 3, unit_price: 300)

    @invoice_2 = create(:invoice, merchant: @merchant_1, customer: @customer_2, updated_at: '2012-03-24 14:54:09 UTC')
    @invoice_item_3 = create(:invoice_item, item: @item_2, invoice: @invoice_2, quantity: 3, unit_price: 300)

    @transaction_1 = create(:transaction, invoice: @invoice_1, result: 'success', updated_at: '2012-03-27 14:54:09 UTC')
    @transaction_2 = create(:transaction, invoice: @invoice_1, result: 'failed', updated_at: '2012-03-27 14:54:09 UTC')
    @transaction_3 = create(:transaction, invoice: @invoice_2, result: 'failed', updated_at: '2012-03-26 14:54:09 UTC')
  end

  it 'returns the associated invoice' do
    invoice_id = @invoice_1.id
    invoice_item_id = @invoice_item_1.id

    get "/api/v1/invoice_items/#{invoice_item_id}/invoice"
    returned = JSON.parse(response.body)

    expect(response).to be_successful
    expect(returned["data"]["type"]).to eq("invoice")
    expect(returned["data"]["id"]).to eq(invoice_id.to_s)
  end

  it 'returns the associated item' do
    invoice_item_id = @invoice_item_1.id
    item_id = @item_1.id

    get "/api/v1/invoice_items/#{invoice_item_id}/item"
    returned = JSON.parse(response.body)

    expect(response).to be_successful
    expect(returned["data"]["type"]).to eq("item")
    expect(returned["data"]["id"]).to eq(item_id.to_s)
  end
end
