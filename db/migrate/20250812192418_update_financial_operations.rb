class UpdateFinancialOperations < ActiveRecord::Migration[8.0]
  def change
    # Renommer la colonne date en operation_date
    rename_column :financial_operations, :date, :operation_date

    # Ajouter la colonne operation_type
    add_column :financial_operations, :operation_type, :string

    # Ajouter les colonnes optionnelles
    add_column :financial_operations, :description, :text
    add_column :financial_operations, :reference_number, :string
    add_column :financial_operations, :metadata, :json

    # Ajouter les contraintes NOT NULL
    change_column_null :financial_operations, :amount, false
    change_column_null :financial_operations, :operation_date, false

    # Définir la précision pour amount
    change_column :financial_operations, :amount, :decimal, precision: 10, scale: 2

    # Ajouter les nouveaux index
    add_index :financial_operations, :category
    add_index :financial_operations, :operation_type
    add_index :financial_operations, :operation_date
    add_index :financial_operations, [ :company_id, :operation_date ]
    add_index :financial_operations, [ :company_id, :category ]
    add_index :financial_operations, [ :property_id, :operation_date ]
    add_index :financial_operations, [ :associate_id, :category ]
    add_index :financial_operations, [ :company_id, :category, :operation_date ]
  end
end
