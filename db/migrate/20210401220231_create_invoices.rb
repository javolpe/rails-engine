class CreateInvoices < ActiveRecord::Migration[5.2]
  def change
    create_table :invoices do |t|
      t.references :customer, foreign_key: true
      t.references :merchant
      t.integer :status

      t.timestamps
    end
  end
end
