require 'rails_helper'

describe "Invoices API" do
  it "shows a list of invoices" do
    create_list(:invoice, 3)

    get '/api/v1/invoices'

    expect(response).to be_successful

    invoice = JSON.parse(response.body)

    expect(invoice["data"].count).to eq(3)
  end

  it "can show a invoice" do
    invoice_id = create(:invoice).id

    get "/api/v1/invoices/#{invoice_id}"

    invoice = JSON.parse(response.body)

    expect(response).to be_successful
    expect(invoice["data"]["id"]).to eq(invoice_id.to_s)
  end

  it "can find a invoice by id" do
    invoice_id = create(:invoice).id

    get "/api/v1/invoices/find?id=#{invoice_id}"

    invoice = JSON.parse(response.body)
    expect(response).to be_successful
    expect(invoice["data"]["id"]).to eq(invoice_id.to_s)
  end

  it "can find a invoice by status" do
    invoice_status = create(:invoice).status

    get "/api/v1/invoices/find?status=#{invoice_status}"
    invoice = JSON.parse(response.body)

    expect(response).to be_successful
    expect(invoice["data"]["attributes"]["status"]).to eq(invoice_status)
  end

  it "can find a invoice by created at" do
    date = "2012-03-27 14:54:09 UTC"
    invoice = create(:invoice, created_at: date)

    get "/api/v1/invoices/find?created_at=#{date}"
    returned_invoice = JSON.parse(response.body)

    expect(response).to be_successful
    expect(returned_invoice["data"]["id"]).to eq(invoice.id.to_s)
  end

  it "can find a invoice by updated at" do
    date = "2012-03-29 02:54:10 UTC"
    invoice = create(:invoice, updated_at: date)

    get "/api/v1/invoices/find?updated_at=#{date}"
    returned_invoice = JSON.parse(response.body)

    expect(response).to be_successful
    expect(returned_invoice["data"]["id"]).to eq(invoice.id.to_s)
  end

  it "can find all invoices by id" do
    invoice_id_1 = create(:invoice).id
    invoice_id_2 = create(:invoice).id
    invoice_id_3 = create(:invoice).id

    get "/api/v1/invoices/find_all?id=#{invoice_id_1}"

    returned = JSON.parse(response.body)

    expect(response).to be_successful
    expect(returned["data"].count).to eq(1)
    expect(returned["data"][0]["id"]).to eq(invoice_id_1.to_s)
  end

  it "can find all invoices by status" do
    invoice_status_1 = create(:invoice).status
    invoice_status_2 = create(:invoice).status
    invoice_status_3 = create(:invoice).status

    get "/api/v1/invoices/find_all?status=#{invoice_status_1}"
    returned = JSON.parse(response.body)

    expect(response).to be_successful
    expect(returned["data"][0]["attributes"]["status"]).to eq(invoice_status_1.to_s)
  end

  it "can find all invoices by created_at" do
    date = "2012-03-29 02:54:10 UTC"
    invoice_created_at_1 = create(:invoice, created_at: "2012-03-30 02:54:10 UTC")
    invoice_created_at_2 = create(:invoice, created_at: "2012-03-29 02:54:10 UTC")
    invoice_created_at_3 = create(:invoice, created_at: "2012-03-29 02:54:10 UTC")

    get "/api/v1/invoices/find_all?created_at=#{date}"

    returned = JSON.parse(response.body)

    expect(response).to be_successful
    expect(returned["data"][0]["id"]).to eq(invoice_created_at_2.id.to_s)
    expect(returned["data"][1]["id"]).to eq(invoice_created_at_3.id.to_s)
    expect(returned["data"].count).to eq(2)
  end

  it "can find all invoices by updated_at" do
    date = "2012-03-25 02:54:10 UTC"
    invoice_updated_at_1 = create(:invoice, updated_at: "2012-03-25 02:54:10 UTC")
    invoice_updated_at_2 = create(:invoice, updated_at: "2012-03-29 02:54:10 UTC")
    invoice_updated_at_3 = create(:invoice, updated_at: "2012-03-29 02:54:10 UTC")

    get "/api/v1/invoices/find_all?updated_at=#{date}"

    returned = JSON.parse(response.body)

    expect(response).to be_successful
    expect(returned["data"][0]["id"]).to eq(invoice_updated_at_1.id.to_s)
    expect(returned["data"].count).to eq(1)
  end

  it "can return a random invoice" do
    invoice_1 = create(:invoice)
    invoice_2 = create(:invoice)
    invoice_3 = create(:invoice)

    get "/api/v1/invoices/random"

    returned = JSON.parse(response.body)

    expect(response).to be_successful
    expect(returned["data"]["type"]).to eq("invoice")
    expect(returned.count).to eq(1)
  end
end

describe "Invoice relationship endpoints" do
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

  it 'returns a collection of associated transactions' do
    invoice_id = @invoice_1.id
    transaction_id_1 = @transaction_1.id
    transaction_id_2 = @transaction_2.id

    get "/api/v1/invoices/#{invoice_id}/transactions"
    returned = JSON.parse(response.body)

    expect(response).to be_successful
    expect(returned["data"][0]["type"]).to eq("transaction")
    expect(returned["data"].count).to eq(2)
    expect(returned["data"][0]["id"]).to eq(transaction_id_1.to_s)
    expect(returned["data"][1]["id"]).to eq(transaction_id_2.to_s)
  end

  it 'returns a collection of associated invoice_items' do
    invoice_id = @invoice_1.id
    invoice_item_id_1 = @invoice_item_1.id
    invoice_item_id_2 = @invoice_item_2.id

    get "/api/v1/invoices/#{invoice_id}/invoice_items"
    returned = JSON.parse(response.body)

    expect(returned["data"][0]["type"]).to eq("invoice_item")
    expect(returned["data"].count).to eq(2)
    expect(returned["data"][0]["id"]).to eq(invoice_item_id_1.to_s)
    expect(returned["data"][1]["id"]).to eq(invoice_item_id_2.to_s)
  end

  it 'returns a collection of associated items' do
    invoice_id = @invoice_1.id
    item_id_1 = @item_1.id
    item_id_2 = @item_2.id

    get "/api/v1/invoices/#{invoice_id}/items"
    returned = JSON.parse(response.body)

    expect(returned["data"][0]["type"]).to eq("item")
    expect(returned["data"].count).to eq(2)
    expect(returned["data"][0]["id"]).to eq(item_id_1.to_s)
    expect(returned["data"][1]["id"]).to eq(item_id_2.to_s)
  end

  it 'returns a collection of associated customer' do
    invoice_id = @invoice_1.id
    customer_id = @customer_1.id

    get "/api/v1/invoices/#{invoice_id}/customer"
    returned = JSON.parse(response.body)

    expect(returned["data"]["type"]).to eq("customer")
    expect(returned["data"]["id"]).to eq(customer_id.to_s)
  end

  it 'returns a collection of associated customer' do
    invoice_id = @invoice_1.id
    merchant_id = @merchant_1.id

    get "/api/v1/invoices/#{invoice_id}/merchant"
    returned = JSON.parse(response.body)

    expect(returned["data"]["type"]).to eq("merchant")
    expect(returned["data"]["id"]).to eq(merchant_id.to_s)
  end

end
