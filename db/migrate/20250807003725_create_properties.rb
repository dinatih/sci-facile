class CreateProperties < ActiveRecord::Migration[8.0]
  def change
    create_table :properties do |t|
      t.references :company, null: false, foreign_key: true
      t.string :address
      t.text :description
      t.date :acquisition_date
      t.decimal :acquisition_price

      t.timestamps
    end
  end
end
