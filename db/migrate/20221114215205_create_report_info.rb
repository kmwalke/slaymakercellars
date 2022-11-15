class CreateReportInfo < ActiveRecord::Migration[7.0]
  def up
    create_table :report_info, id: false do |t|
      t.date :keg_report_calculated_on
    end

    ReportInfo.create(keg_report_calculated_on: Date.today)
  end

  def down
    drop_table :report_info
  end
end
