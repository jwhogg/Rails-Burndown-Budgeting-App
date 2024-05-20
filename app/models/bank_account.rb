require_relative "../services/client"

class BankAccount < ApplicationRecord
  belongs_to :user
  has_many :transactions, dependent: :destroy
  validates :account_number, presence: true
  validates :balance, numericality: { greater_than_or_equal_to: 0 }

  def get_account
    client = Client.create_client
    requisition_data = client.requisition.get_requisition_by_id(self.requisition_id)
    account_id =  requisition_data["accounts"][0]
    account = client.account(account_id)
    return account
  end

  def get_account_details
    account = self.get_account
    return account.get_details()
  end

  def get_account_balances
    account = self.get_account
    return account.get_balances()
  end

  def get_account_transactions
    account = self.get_account
    return account.get_transactions()
  end

  def get_account_transactions_date(from, to)#eg: "2021-12-01" "2022-01-30"
    account = self.get_account
    return account.get_transactions(date_from: from, date_to: to)
  end

end
