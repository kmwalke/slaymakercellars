FactoryBot.define do
  factory :report_info do
    keg_report_calculated_on { Date.today }
  end
end
