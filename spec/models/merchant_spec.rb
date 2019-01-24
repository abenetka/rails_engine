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
      @invoice_item_1 = create(:invoice_item, item: @item_1, invoice: @invoice_1, quantity: 1, unit_price: 100, created_at: 10.minutes.ago, updated_at: 9.minute.ago)

      @invoice_2 = create(:invoice, merchant: @merchant_2)
      @invoice_item_2 = create(:invoice_item, item: @item_2, invoice: @invoice_2, quantity: 3, unit_price: 300, created_at: 2.days.ago, updated_at: 1.minute.ago)

      @invoice_3 = create(:invoice, merchant: @merchant_3)
      @invoice_item_3 = create(:invoice_item, item: @item_3, invoice: @invoice_3, quantity: 3, unit_price: 200, created_at: 10.minutes.ago, updated_at: 5.minute.ago)

      @transaction_1 = create(:transaction, invoice: @invoice_1, result: 'success')
      @transaction_2 = create(:transaction, invoice: @invoice_2, result: 'success')
      @transaction_3 = create(:transaction, invoice: @invoice_3, result: 'success')
    end

    it 'calculates total revenue for x merchants' do
      expect(Merchant.most_revenue(3)[0]).to eq(@merchant_2)
      expect(Merchant.most_revenue(3).to_a.count).to eq(3)
    end
  end

end
