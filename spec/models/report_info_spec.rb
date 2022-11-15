require 'rails_helper'

RSpec.describe ReportInfo, type: :model do
  before :all do
    FactoryBot.create(:report_info)
  end

  it 'cannot create second row' do
    expect(ReportInfo.all.count).to eq(1)

    FactoryBot.create(:report_info)

    expect(ReportInfo.all.count).to eq(1)
  end

  it 'uses class method for keg report date' do
    expect(ReportInfo.keg_report_calculated_on).to be_a(Date)
  end
end
