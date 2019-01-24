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
