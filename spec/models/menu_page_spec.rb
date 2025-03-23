require 'rails_helper'

RSpec.describe MenuPage, type: :model do
  it 'calculates the position' do
    num_pages = described_class.count
    page      = create(:menu_page)
    expect(page.position).to eq(num_pages + 1)
  end

  it 'returns the page name' do
    page = create(:menu_page)
    expect(page.name).to eq("Page #{page.position}")
  end
end
