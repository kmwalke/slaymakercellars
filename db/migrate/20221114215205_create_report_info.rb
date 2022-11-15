class CreateReportInfo < ActiveRecord::Migration[7.0]
  def up
    create_table :report_info, id: false do |t|
      t.integer :uuid, null: false, default: 1
      t.date :keg_report_calculated_on
    end

    add_index :report_info, :uuid, unique: true

    ReportInfo.create(keg_report_calculated_on: Date.today)
  end

  def down
    remove_index :report_info, :uuid
    drop_table :report_info
  end
end
