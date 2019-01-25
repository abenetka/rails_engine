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

  it "can find a merchant by created at" do
    date = "2012-03-27 14:54:09 UTC"
    merchant = create(:merchant, created_at: date)

    get "/api/v1/merchants/find?created_at=#{date}"
    returned_merchant= JSON.parse(response.body)

    expect(response).to be_successful
    expect(returned_merchant["data"]["id"]).to eq(merchant.id.to_s)
  end

  it "can find a merchant by updated at" do
    date = "2012-03-29 02:54:10 UTC"
    merchant = create(:merchant, updated_at: date)

    get "/api/v1/merchants/find?updated_at=#{date}"
    returned_merchant= JSON.parse(response.body)

    expect(response).to be_successful
    expect(returned_merchant["data"]["id"]).to eq(merchant.id.to_s)
  end
end

describe "Merchant stats" do
  before :each do
    @merchant_1 = create(:merchant, name: "Merchant 1")
    @merchant_2 = create(:merchant, name: "Merchant 2")
    @merchant_3 = create(:merchant, name: "Merchant 3")

    @item_1 = create(:item, merchant: @merchant_1)
    @item_2 = create(:item, merchant: @merchant_2)
    @item_3 = create(:item, merchant: @merchant_3)

    @invoice_1 = create(:invoice, merchant: @merchant_1)
    @invoice_item_1 = create(:invoice_item, item: @item_1, invoice: @invoice_1, quantity: 1, unit_price: 2000)

    @invoice_2 = create(:invoice, merchant: @merchant_2)
    @invoice_item_2 = create(:invoice_item, item: @item_2, invoice: @invoice_2, quantity: 3, unit_price: 300)

    @invoice_3 = create(:invoice, merchant: @merchant_3)
    @invoice_item_3 = create(:invoice_item, item: @item_3, invoice: @invoice_3, quantity: 5, unit_price: 200)

    @transaction_1 = create(:transaction, invoice: @invoice_1, result: 'success', updated_at: '2012-03-27 14:54:09 UTC')
    @transaction_2 = create(:transaction, invoice: @invoice_2, result: 'success', updated_at: '2012-03-27 14:54:09 UTC')
    @transaction_3 = create(:transaction, invoice: @invoice_3, result: 'success', updated_at: '2012-03-26 14:54:09 UTC')
  end


  it "returns the top x merchants ranked by total revenue" do
    quantity = 5
    get "/api/v1/merchants/most_revenue?quantity=#{quantity}"

    merchants = JSON.parse(response.body)

    expect(response).to be_successful
    expect(merchants["data"].first["attributes"]["name"]).to eq("Merchant 1")
    expect(merchants["data"].last["attributes"]["name"]).to eq("Merchant 2")
  end

  it "returns the top x merchants ranked by total items sold" do
    quantity = 5
    get "/api/v1/merchants/most_items?quantity=#{quantity}"

    merchant = JSON.parse(response.body)

    expect(response).to be_successful
  end

  it "returns the top revenue for merchants by date x" do
    date = "2012-03-27 14:54:09 UTC"

    get "/api/v1/merchants/revenue?date=#{date}"
    binding.pry
    merchant = JSON.parse(response.body)
    expect(response).to be_successful
  end


end
