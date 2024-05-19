class Transaction < ApplicationRecord
  belongs_to :bank_account

  validates :date, presence: true
  validates :amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :reference, presence: true
  validates :category, presence: true
end
