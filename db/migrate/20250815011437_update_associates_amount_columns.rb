class UpdateAssociatesAmountColumns < ActiveRecord::Migration[8.0]
  def change
    change_column :associates, :initial_contribution, :decimal, precision: 10, scale: 2, default: 0.0
    change_column :associates, :current_account_balance, :decimal, precision: 10, scale: 2, default: 0.0, null: false
  end
end
