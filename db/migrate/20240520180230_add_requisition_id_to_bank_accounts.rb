class AddRequisitionIdToBankAccounts < ActiveRecord::Migration[7.1]
  def change
    add_column :bank_accounts, :requisition_id, :string
  end
end
