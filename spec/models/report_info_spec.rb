require 'rails_helper'

RSpec.describe ReportInfo do
  it 'cannot create second row' do
    expect(described_class.all.count).to eq(1)

    expect { create(:report_info) }.to raise_error(ActiveRecord::RecordNotUnique)

    expect(described_class.all.count).to eq(1)
  end

  it 'uses class method for keg report date' do
    expect(described_class.keg_report_calculated_on).to be_a(Date)
  end
end
