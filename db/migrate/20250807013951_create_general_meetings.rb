class CreateGeneralMeetings < ActiveRecord::Migration[8.0]
  def change
    create_table :general_meetings do |t|
      t.references :company, null: false, foreign_key: true
      t.date :date
      t.string :title
      t.text :minutes_text

      t.timestamps
    end
  end
end
