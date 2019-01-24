require 'rails_helper'

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
    expect(item["data"]["attributes"]["unit_price"]).to eq(item_unit_price)
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
end
