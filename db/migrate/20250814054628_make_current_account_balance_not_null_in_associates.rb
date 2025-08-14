class MakeCurrentAccountBalanceNotNullInAssociates < ActiveRecord::Migration[8.0]
  def change
    change_column_null :associates, :current_account_balance, false
    change_column_default :associates, :current_account_balance, 0
  end
end
