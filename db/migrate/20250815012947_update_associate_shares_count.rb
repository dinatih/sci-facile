class UpdateAssociateSharesCount < ActiveRecord::Migration[8.0]
  def change
    change_column_default :associates, :shares_count, 0
    change_column_null :associates, :shares_count, false
  end
end
