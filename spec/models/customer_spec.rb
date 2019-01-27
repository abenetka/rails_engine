require 'rails_helper'

RSpec.describe Customer, type: :model do
  describe 'relationships' do
    it { should have_many(:invoices) }
  end

  describe 'validations' do
    it {should validate_presence_of(:first_name)}
    it {should validate_presence_of(:last_name)}
  end

  describe 'customer stats' do
    before :each do
      @merchant_1 = create(:merchant)
      @merchant_2 = create(:merchant)
      @merchant_3 = create(:merchant)

      @customer_1 = create(:customer)
      @customer_2 = create(:customer)
      @customer_3 = create(:customer)

      @item_1 = create(:item, merchant: @merchant_1)
      @item_2 = create(:item, merchant: @merchant_1)
      @item_3 = create(:item, merchant: @merchant_2)

      @invoice_1 = create(:invoice, merchant: @merchant_1, customer: @customer_1, updated_at: '2012-03-23 14:54:09 UTC')
      @invoice_item_1 = create(:invoice_item, item: @item_1, invoice: @invoice_1, quantity: 1, unit_price: 2000)

      @invoice_2 = create(:invoice, merchant: @merchant_1, customer: @customer_1,  updated_at: '2012-03-24 14:54:09 UTC')
      @invoice_item_2 = create(:invoice_item, item: @item_2, invoice: @invoice_2, quantity: 3, unit_price: 300)

      @invoice_3 = create(:invoice, merchant: @merchant_2, customer: @customer_1,  updated_at: '2012-03-23 14:54:09 UTC')
      @invoice_item_3 = create(:invoice_item, item: @item_3, invoice: @invoice_3, quantity: 5, unit_price: 200)

      @invoice_4 = create(:invoice, merchant: @merchant_1, customer: @customer_2,  updated_at: '2012-03-24 14:54:09 UTC')
      @invoice_item_4 = create(:invoice_item, item: @item_1, invoice: @invoice_4, quantity: 1, unit_price: 200)

      @invoice_5 = create(:invoice, merchant: @merchant_1, customer: @customer_2,  updated_at: '2012-03-24 14:54:09 UTC')
      @invoice_item_5 = create(:invoice_item, item: @item_2, invoice: @invoice_5, quantity: 3, unit_price: 200)

      @invoice_6 = create(:invoice, merchant: @merchant_2, customer: @customer_2,  updated_at: '2012-03-24 14:54:09 UTC')
      @invoice_item_6 = create(:invoice_item, item: @item_3, invoice: @invoice_6, quantity: 1, unit_price: 200)

      @transaction_1 = create(:transaction, invoice: @invoice_1, result: 'success', updated_at: '2012-03-27 14:54:09 UTC')
      @transaction_2 = create(:transaction, invoice: @invoice_2, result: 'success', updated_at: '2012-03-27 14:54:09 UTC')
      @transaction_3 = create(:transaction, invoice: @invoice_3, result: 'success', updated_at: '2012-03-26 14:54:09 UTC')
      @transaction_4 = create(:transaction, invoice: @invoice_4, result: 'success', updated_at: '2012-03-26 14:54:09 UTC')
      @transaction_5 = create(:transaction, invoice: @invoice_5, result: 'failed', updated_at: '2012-03-26 14:54:09 UTC')
      @transaction_6 = create(:transaction, invoice: @invoice_6, result: 'failed', updated_at: '2012-03-26 14:54:09 UTC')
    end

    it 'calculates total number of successful transactions' do
      expect(@customer_1.favorite_merchant[0]).to eq(@merchant_1)
      expect(@customer_2.favorite_merchant[0]).to eq(@merchant_1)
    end
  end



  # returns a merchant where the customer has conducted the most successful transactions
end
