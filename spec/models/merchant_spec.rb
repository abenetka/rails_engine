require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe 'relationships' do
    it { should have_many(:items) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
  end

  describe 'merchant stats' do
    before :each do
      @merchant_1 = create(:merchant)
      @merchant_2 = create(:merchant)
      @merchant_3 = create(:merchant)

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

    it 'calculates total revenue for x merchants' do
      expect(Merchant.most_revenue(3)[0]).to eq(@merchant_1)
      expect(Merchant.most_revenue(3)[1]).to eq(@merchant_3)
      expect(Merchant.most_revenue(3)[2]).to eq(@merchant_2)
      expect(Merchant.most_revenue(3).to_a.count).to eq(3)
    end

    it 'calculates total items sold for x merchants' do
    # GET /api/v1/merchants/most_items?quantity=x returns the top x merchants ranked by total number of items sold
      expect(Merchant.most_items(3)[0]).to eq(@merchant_3)
      expect(Merchant.most_items(3)[1]).to eq(@merchant_2)
      expect(Merchant.most_items(3)[2]).to eq(@merchant_1)
    end

    it 'calculates total revenue for all merchants for date x' do
      date = '2012-03-27 14:54:09 UTC'
      expect(Merchant.total_revenue_by_date(date)).to eq(2900)
    end

  end
end
