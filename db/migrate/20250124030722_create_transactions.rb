class CreateTransactions < ActiveRecord::Migration[8.0]
  def change
    create_table :transactions do |t|
      t.integer :account_id
      t.string :transaction_type
      t.decimal :amount

      t.timestamps
    end
  end
end
