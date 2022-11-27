require 'rails_helper'

RSpec.describe ReportInfo do
  it 'defaults to 1 row' do
    expect(described_class.all.count).to eq(1)
  end

  it 'cannot create second row' do
    expect { create(:report_info) }.to raise_error(ActiveRecord::RecordNotUnique)
  end

  it 'keeps rowcount to 1' do
    begin
      create(:report_info)
    rescue ActiveRecord::RecordNotUnique
      # Ignored
    end
    expect(described_class.all.count).to eq(1)
  end

  it 'uses class method for keg report date' do
    expect(described_class.keg_report_calculated_on).to be_a(Date)
  end
end
