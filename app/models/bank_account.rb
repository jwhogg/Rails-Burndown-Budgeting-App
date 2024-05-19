class BankAccount < ApplicationRecord
  belongs_to :user
  has_many :transactions, dependent: :destroy
  validates :account_number, presence: true
  validates :balance, numericality: { greater_than_or_equal_to: 0 }
end
