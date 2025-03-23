require 'rails_helper'

RSpec.describe MenuPage, type: :model do
  it 'calculates the position' do
    expect {true}.to be_nil
    # should put new sections at the end and should rearrange correctly
  end

  it 'returns the page name' do
    page = create(:menu_page)
    expect(page.name).to eq("Page #{page.position}")
  end
end
