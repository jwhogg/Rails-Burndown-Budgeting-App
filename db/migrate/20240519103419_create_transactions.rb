class CreateTransactions < ActiveRecord::Migration[7.1]
  def change
    create_table :transactions do |t|
      t.references :bank_account, null: false, foreign_key: true
      t.date :date
      t.decimal :amount
      t.string :reference
      t.string :category

      t.timestamps
    end
  end
end
