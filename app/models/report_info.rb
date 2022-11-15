class ReportInfo < ApplicationRecord
  self.table_name = 'report_info'

  def self.keg_report_calculated_on
    ReportInfo.first.keg_report_calculated_on
  end
end
