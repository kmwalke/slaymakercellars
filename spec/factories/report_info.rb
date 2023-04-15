FactoryBot.define do
  factory :report_info do
    keg_report_calculated_on { Time.zone.today }
  end
end
