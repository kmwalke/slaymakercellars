require 'rails_helper'

RSpec.describe ReportInfo, type: :model do
  it 'cannot create second row' do
    expect(ReportInfo.all.count).to eq(1)

    expect { FactoryBot.create(:report_info) }.to raise_error(ActiveRecord::RecordNotUnique)

    expect(ReportInfo.all.count).to eq(1)
  end

  it 'uses class method for keg report date' do
    expect(ReportInfo.keg_report_calculated_on).to be_a(Date)
  end
end
