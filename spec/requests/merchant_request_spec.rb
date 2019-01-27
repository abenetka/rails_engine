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

describe "Merchant stats and relationship endpoints" do
  before :each do
    @merchant_1 = create(:merchant, name: "Merchant 1")
    @merchant_2 = create(:merchant, name: "Merchant 2")
    @merchant_3 = create(:merchant, name: "Merchant 3")

    @item_1 = create(:item, merchant: @merchant_1)
    @item_2 = create(:item, merchant: @merchant_2)
    @item_3 = create(:item, merchant: @merchant_3)

    @invoice_1 = create(:invoice, merchant: @merchant_1, updated_at: '2012-03-27 14:54:09 UTC')
    @invoice_item_1 = create(:invoice_item, item: @item_1, invoice: @invoice_1, quantity: 1, unit_price: 2000)

    @invoice_2 = create(:invoice, merchant: @merchant_2, updated_at: '2012-03-24 14:54:09 UTC')
    @invoice_item_2 = create(:invoice_item, item: @item_2, invoice: @invoice_2, quantity: 3, unit_price: 300)

    @invoice_3 = create(:invoice, merchant: @merchant_3, updated_at: '2012-03-23 14:54:09 UTC')
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

    merchant = JSON.parse(response.body)
    expect(response).to be_successful
  end
  it "returns the top revenue for merchants by date x" do
    date = "2012-03-27 14:54:09 UTC"

    get "/api/v1/merchants/revenue?date=#{date}"

    merchants = JSON.parse(response.body)

    expect(response).to be_successful
    expect(merchants["data"]["revenue_by_date"]["all_merchants"]).to eq(2900)
  end

  it "returns the total revenue for a particular merchant" do
    merchant_id = @merchant_2.id

    get "/api/v1/merchants/#{merchant_id}/revenue"

    merchant = JSON.parse(response.body)

    expect(response).to be_successful
    expect(merchant["data"]["revenue_for_merchant"]["merchant"]).to eq(900)
  end

  it "returns the total revenue for a particular merchant on specific invoice date" do
    merchant_id = @merchant_1.id
    date = "2012-03-24 14:54:09 UTC"

    get "/api/v1/merchants/#{merchant_id}/revenue?date=#{date}"
    merchant = JSON.parse(response.body)

    expect(response).to be_successful
  end

  it "returns a collection of items associated with that merchant" do
    merchant_id = @merchant_1.id
    item_id = @item_1.id

    get "/api/v1/merchants/#{merchant_id}/items"

    merchant = JSON.parse(response.body)

    expect(response).to be_successful
    expect(merchant["data"][0]["attributes"]["name"]).to eq("item_1")
    expect(merchant["data"][0]["id"]).to eq(item_id.to_s)
    expect(merchant["data"][0]["attributes"]["merchant_id"]).to eq(merchant_id)
  end

  it "returns a collection of invoices associated with that merchant from their known orders" do
    merchant_id = @merchant_1.id
    invoice_id_1 = @invoice_1.id

    get "/api/v1/merchants/#{merchant_id}/invoices"

    merchant = JSON.parse(response.body)

    expect(response).to be_successful
    expect(merchant["data"][0]["id"]).to eq(invoice_id_1.to_s)
    expect(merchant.count).to eq(1)
  end


end
