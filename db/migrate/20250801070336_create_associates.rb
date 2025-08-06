class CreateAssociates < ActiveRecord::Migration[8.0]
  def change
    create_table :associates do |t|
      t.references :company, null: false, foreign_key: true
      t.string :first_name
      t.string :last_name
      t.string :email
      t.integer :shares_count
      t.decimal :initial_contribution
      t.decimal :current_account_balance

      t.timestamps
    end
  end
end
