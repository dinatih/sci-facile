class CreateTenants < ActiveRecord::Migration[8.0]
  def change
    create_table :tenants do |t|
      t.references :property, null: false, foreign_key: true
      t.string :first_name
      t.string :last_name
      t.string :email
      t.decimal :rent_amount
      t.decimal :charges_amount
      t.date :lease_start_date
      t.date :lease_end_date

      t.timestamps
    end
  end
end
