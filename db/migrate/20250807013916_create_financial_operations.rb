class CreateFinancialOperations < ActiveRecord::Migration[8.0]
  def change
    create_table :financial_operations do |t|
      t.references :company, null: false, foreign_key: true
      t.references :property, foreign_key: true
      t.references :tenant, foreign_key: true
      t.references :associate, foreign_key: true
      t.string :category
      t.string :label
      t.decimal :amount
      t.date :date

      t.timestamps
    end
  end
end
