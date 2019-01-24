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
end
