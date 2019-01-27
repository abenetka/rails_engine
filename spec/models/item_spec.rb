require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'relationships' do
    it { should belong_to(:merchant) }
    it { should have_many(:invoice_items) }
    it { should have_many(:invoices).through(:invoice_items) }
  end

  describe 'validations' do
    it {should validate_presence_of(:name)}
    it {should validate_presence_of(:description)}
    it {should validate_presence_of(:unit_price)}
  end

  describe 'items stats' do
    before :each do
      @merchant_1 = create(:merchant)
      @merchant_2 = create(:merchant)
      @merchant_3 = create(:merchant)

      @customer_1 = create(:customer)
      @customer_2 = create(:customer)
      @customer_3 = create(:customer)

      @item_1 = create(:item, merchant: @merchant_1)
      @item_2 = create(:item, merchant: @merchant_2)
      @item_3 = create(:item, merchant: @merchant_3)

      @invoice_1 = create(:invoice, merchant: @merchant_1, customer: @customer_1, updated_at: '2012-03-23 14:54:09 UTC')
      @invoice_item_1 = create(:invoice_item, item: @item_1, invoice: @invoice_1, quantity: 1, unit_price: 2000)

      @invoice_2 = create(:invoice, merchant: @merchant_2, customer: @customer_1,  updated_at: '2012-03-24 14:54:09 UTC')
      @invoice_item_2 = create(:invoice_item, item: @item_2, invoice: @invoice_2, quantity: 3, unit_price: 300)

      @invoice_3 = create(:invoice, merchant: @merchant_3, customer: @customer_2,  updated_at: '2012-03-23 14:54:09 UTC')
      @invoice_item_3 = create(:invoice_item, item: @item_3, invoice: @invoice_3, quantity: 5, unit_price: 200)

      @invoice_4 = create(:invoice, merchant: @merchant_1, customer: @customer_2,  updated_at: '2012-03-24 14:54:09 UTC')
      @invoice_item_4 = create(:invoice_item, item: @item_1, invoice: @invoice_4, quantity: 1, unit_price: 200)

      @transaction_1 = create(:transaction, invoice: @invoice_1, result: 'success', updated_at: '2012-03-27 14:54:09 UTC')
      @transaction_2 = create(:transaction, invoice: @invoice_2, result: 'success', updated_at: '2012-03-27 14:54:09 UTC')
      @transaction_3 = create(:transaction, invoice: @invoice_3, result: 'success', updated_at: '2012-03-26 14:54:09 UTC')
    end

    it 'calculates total revenue for x items' do
      expect(Item.items_most_revenue(3)[0]).to eq(@item_1)
      expect(Item.items_most_revenue(3)[1]).to eq(@item_3)
      expect(Item.items_most_revenue(3)[2]).to eq(@item_2)
    end

    it 'calculates total items sold for x items' do
      # GET /api/v1/items/most_items?quantity=x returns the top x item instances ranked by total number sold
      expect(Item.top_items(3)[0]).to eq(@item_3)
      expect(Item.top_items(3)[1]).to eq(@item_2)
      expect(Item.top_items(3)[2]).to eq(@item_1)
    end

    it 'calculates best date for sales of single item ' do
      # GET /api/v1/items/:id/best_day returns the date with the most sales for the given item using the invoice date. If there are multiple days with equal number of sales, return the most recent day.
      expect(@item_1.best_date).to eq(@invoice_1.updated_at)
    end
  end
end
