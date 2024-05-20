require_relative "../services/client"

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :bank_accounts, dependent: :destroy

  def linked_account?
    return current_user.bank_account.exists?
  end

end
