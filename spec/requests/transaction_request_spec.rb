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

  it "can find all transactions by id" do
    transaction_id_1 = create(:transaction).id
    transaction_id_2 = create(:transaction).id
    transaction_id_3 = create(:transaction).id

    get "/api/v1/transactions/find_all?id=#{transaction_id_1}"

    transaction = JSON.parse(response.body)

    expect(response).to be_successful
    expect(transaction["data"].count).to eq(1)
    expect(transaction["data"][0]["id"]).to eq(transaction_id_1.to_s)
  end

  it "can find all transactions by credit_card_number" do
    transaction_credit_card_number_1 = create(:transaction, credit_card_number: "4654405418249632").credit_card_number
    transaction_credit_card_number_2 = create(:transaction, credit_card_number: "4654405418249631").credit_card_number
    transaction_credit_card_number_3 = create(:transaction, credit_card_number: "4654405418249632").credit_card_number

    get "/api/v1/transactions/find_all?credit_card_number=#{transaction_credit_card_number_1}"

    transaction = JSON.parse(response.body)

    expect(response).to be_successful
    expect(transaction["data"].count).to eq(2)
    expect(transaction["data"][0]["attributes"]["credit_card_number"]).to eq(transaction_credit_card_number_1.to_s)
    expect(transaction["data"][1]["attributes"]["credit_card_number"]).to eq(transaction_credit_card_number_3.to_s)
  end

  it "can find all transactions by credit_card_expiration_date" do
    transaction_credit_card_expiration_date_1 = create(:transaction).credit_card_expiration_date
    transaction_credit_card_expiration_date_2 = create(:transaction).credit_card_expiration_date
    transaction_credit_card_expiration_date_3 = create(:transaction).credit_card_expiration_date

    get "/api/v1/transactions/find_all?credit_card_expiration_date=#{transaction_credit_card_expiration_date_1}"

    transaction = JSON.parse(response.body)

    expect(response).to be_successful
    expect(transaction["data"].count).to eq(3)
    expect(transaction["data"][0]["attributes"]["credit_card_expiration_date"]).to eq(nil)
    expect(transaction["data"][1]["attributes"]["credit_card_expiration_date"]).to eq(nil)
    expect(transaction["data"][2]["attributes"]["credit_card_expiration_date"]).to eq(nil)
  end

  it "can find all transactions by result" do
    transaction_result_1 = create(:transaction, result: "success").result
    transaction_result_2 = create(:transaction, result: "success").result
    transaction_result_3 = create(:transaction, result: "failed").result

    get "/api/v1/transactions/find_all?result=#{transaction_result_2}"

    transaction = JSON.parse(response.body)

    expect(response).to be_successful
    expect(transaction["data"].count).to eq(2)
    expect(transaction["data"][0]["attributes"]["result"]).to eq(transaction_result_1.to_s)
    expect(transaction["data"][0]["attributes"]["result"]).to eq(transaction_result_2.to_s)
  end

  it "can find all transactions by created_at" do
    date = "2012-03-29 02:54:10 UTC"
    transaction_created_at_1 = create(:transaction, created_at: "2012-03-30 02:54:10 UTC")
    transaction_created_at_2 = create(:transaction, created_at: "2012-03-29 02:54:10 UTC")
    transaction_created_at_3 = create(:transaction, created_at: "2012-03-29 02:54:10 UTC")

    get "/api/v1/transactions/find_all?created_at=#{date}"

    returned = JSON.parse(response.body)

    expect(response).to be_successful
    expect(returned["data"][0]["id"]).to eq(transaction_created_at_2.id.to_s)
    expect(returned["data"][1]["id"]).to eq(transaction_created_at_3.id.to_s)
    expect(returned["data"].count).to eq(2)
  end

  it "can find all transactions by updated_at" do
    date = "2012-03-25 02:54:10 UTC"
    transaction_updated_at_1 = create(:transaction, updated_at: "2012-03-25 02:54:10 UTC")
    transaction_updated_at_2 = create(:transaction, updated_at: "2012-03-29 02:54:10 UTC")
    transaction_updated_at_3 = create(:transaction, updated_at: "2012-03-29 02:54:10 UTC")

    get "/api/v1/transactions/find_all?updated_at=#{date}"

    returned = JSON.parse(response.body)

    expect(response).to be_successful
    expect(returned["data"][0]["id"]).to eq(transaction_updated_at_1.id.to_s)
    expect(returned["data"].count).to eq(1)
  end

  it "can return a random transaction" do
    transaction_1 = create(:transaction)
    transaction_2 = create(:transaction)
    transaction_3 = create(:transaction)

    get "/api/v1/transactions/random"

    returned = JSON.parse(response.body)

    expect(response).to be_successful
    expect(returned["data"]["type"]).to eq("transaction")
    expect(returned.count).to eq(1)
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
