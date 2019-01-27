require 'rails_helper'

describe "Transactions API" do
  it "shows a list of transactions" do
    create_list(:transaction, 3)

    get '/api/v1/transactions'

    expect(response).to be_successful

    transactions = JSON.parse(response.body)

    expect(transactions["data"].count).to eq(3)
  end

  it "can show a transaction" do
    transaction_id = create(:transaction).id

    get "/api/v1/transactions/#{transaction_id}"

    transaction = JSON.parse(response.body)

    expect(response).to be_successful
    expect(transaction["data"]["id"]).to eq(transaction_id.to_s)
  end

  it "can find a transaction by id" do
    transaction_id = create(:transaction).id

    get "/api/v1/transactions/find?id=#{transaction_id}"

    transaction = JSON.parse(response.body)

    expect(response).to be_successful
    expect(transaction["data"]["id"]).to eq(transaction_id.to_s)
  end

  it "can find a transaction by credit_card_number" do
    cc_num = create(:transaction).credit_card_number

    get "/api/v1/transactions/find?name=#{cc_num}"

    transaction = JSON.parse(response.body)

    expect(response).to be_successful
    expect(transaction["data"]["attributes"]["credit_card_number"]).to eq(cc_num.to_s)
  end

  it "can find a transaction by credit_card_expiration_date" do
    cc_exp = create(:transaction).credit_card_expiration_date

    get "/api/v1/transactions/find?name=#{cc_exp}"

    transaction = JSON.parse(response.body)

    expect(response).to be_successful
    expect(transaction["data"]["attributes"]["credit_card_expiration_date"]).to eq(nil)
  end

  it "can find a transaction by created at" do
    date = "2012-03-27 14:54:09 UTC"
    transaction = create(:transaction, created_at: date)

    get "/api/v1/transactions/find?created_at=#{date}"
    returned_transaction = JSON.parse(response.body)

    expect(response).to be_successful
    expect(returned_transaction["data"]["id"]).to eq(transaction.id.to_s)
  end

  it "can find a transaction by updated at" do
    date = "2012-03-29 02:54:10 UTC"
    transaction = create(:transaction, updated_at: date)

    get "/api/v1/transactions/find?updated_at=#{date}"
    returned_transaction = JSON.parse(response.body)

    expect(response).to be_successful
    expect(returned_transaction["data"]["id"]).to eq(transaction.id.to_s)
  end
end

describe "Transaction relationship endpoints" do
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

  it 'returns the associated invoice' do
    transaction_id = @transaction_1.id
    invoice_id_1 = @invoice_1.id

    get "/api/v1/transactions/#{transaction_id}/invoice"
    returned = JSON.parse(response.body)

    expect(response).to be_successful
    expect(returned["data"]["type"]).to eq("invoice")
    expect(returned["data"]["id"]).to eq(invoice_id_1.to_s)
  end
end
