require 'rails_helper'

RSpec.describe OrdersReport do
  let(:start_date) { '04-01-2023' }
  let(:end_date) { '04-11-2023' }
  let(:report) { described_class.new(start_date, end_date) }

  describe 'initialize' do
    it 'sets the start date' do
      expect(report.start_date).to eq(DateTime.parse("#{start_date} 00:00:00"))
    end

    it 'sets the end date' do
      expect(report.end_date).to eq(DateTime.parse("#{end_date} 23:59:59"))
    end

    it 'returns a wholesale order array' do
      expect(report.orders).to be_a(Array)
    end
  end

  describe 'report data' do
    let!(:order1) { create(:order, created_at: '03-01-2023') }
    let!(:order2) { create(:order, created_at: '04-04-2023') }
    let!(:order3) { create(:order, created_at: 'o4-11-2023') }
    let!(:report2) { described_class.new(start_date, end_date) }
    let(:orders) { [order1, order2, order3] }

    before do
      3.times { create(:line_item, order: order2) }
    end

    it 'returns wholesale orders' do
      expect(report.orders.empty?).to be(false)
    end

    it 'returns a mock order with an id' do
      expect(report.orders.first.id).to eq(order2.id)
    end

    it 'returns a mock order with an item count' do
      expect(report2.orders.first.num_items).to eq(calc_items(order2))
    end

    it 'returns a mock order with a value' do
      expect(report2.orders.first.value).to eq(calc_value(order2))
    end

    it 'counts total items' do
      expect(report2.num_items).to eq(orders.map { |o| calc_items(o) }.sum)
    end

    it 'counts total value' do
      expect(report2.value).to eq(orders.map { |o| calc_value(o) }.sum)
    end
  end
end

private

def calc_items(order)
  order.line_items.map(&:quantity).sum
end

def calc_value(order)
  order.line_items.map { |li| li.quantity * li.price_point }.sum
end
