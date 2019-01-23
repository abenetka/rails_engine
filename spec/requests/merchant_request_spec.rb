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
