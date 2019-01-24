require 'rails_helper'

describe "Merchants API" do
  it "shows a list of merchants" do
    create_list(:merchant, 3)

    get '/api/v1/merchants'

    expect(response).to be_successful

    merchants = JSON.parse(response.body)

    expect(merchants["data"].count).to eq(3)
  end

  it "can show a merchant" do
    merchant_id = create(:merchant).id

    get "/api/v1/merchants/#{merchant_id}"

    merchant = JSON.parse(response.body)

    expect(response).to be_successful
    expect(merchant["data"]["id"]).to eq(merchant_id.to_s)
  end

  it "can find a merchant by id" do
    merchant_id = create(:merchant).id

    get "/api/v1/merchants/find?id=#{merchant_id}"

    merchant = JSON.parse(response.body)

    expect(response).to be_successful
    expect(merchant["data"]["id"]).to eq(merchant_id.to_s)
  end

  it "can find a merchant by name" do
    merchant_name = create(:merchant).name

    get "/api/v1/merchants/find?name=#{merchant_name}"

    merchant = JSON.parse(response.body)

    expect(response).to be_successful
    expect(merchant["data"]["attributes"]["name"]).to eq(merchant_name.to_s)
  end
end

describe "Merchant stats" do
  before :each do
    @merchant_1 = create(:merchant)
    @merchant_2 = create(:merchant)
    @merchant_3 = create(:merchant)

    @item_1 = create(:item, merchant: @merchant_1)
    @item_2 = create(:item, merchant: @merchant_2)
    @item_3 = create(:item, merchant: @merchant_3)

    @invoice_1 = create(:invoice, merchant: @merchant_1)
    @invoice_item_1 = create(:invoice_item, item: @item_1, invoice: @invoice_1, quantity: 1, unit_price: 100, created_at: 10.minutes.ago, updated_at: 9.minute.ago)

    @invoice_2 = create(:invoice, merchant: @merchant_2)
    @invoice_item_2 = create(:invoice_item, item: @item_2, invoice: @invoice_2, quantity: 3, unit_price: 300, created_at: 2.days.ago, updated_at: 1.minute.ago)

    @invoice_3 = create(:invoice, merchant: @merchant_3)
    @invoice_item_3 = create(:invoice_item, item: @item_3, invoice: @invoice_3, quantity: 3, unit_price: 200, created_at: 10.minutes.ago, updated_at: 5.minute.ago)

    @transaction_1 = create(:transaction, invoice: @invoice_1, result: 'success')
    @transaction_2 = create(:transaction, invoice: @invoice_2, result: 'success')
    @transaction_3 = create(:transaction, invoice: @invoice_3, result: 'success')
  end
  

  it "returns the top x merchants ranked by total revenue" do
    quantity = 5
    get "/api/v1/merchants/most_revenue?quantity=#{quantity}"

    merchant = JSON.parse(response.body)

    expect(response).to be_successful
  end
end
