require_relative "../services/client"

class TransactionController < ApplicationController
  def index
    #check to make sure their account is linked
  end

  def linked #landing for after users link their account
    #check account is linked
    #display message
    #redirect to index
    client = Client.create_client

    requisition_id = session[:requisition_id]
    requisition_data = client.requisition.get_requisition_by_id(requisition_id)
    Rails.logger.info("Req ID: #{requisition_id}")
    Rails.logger.info("Req ID: #{requisition_data}")
    account_id =  requisition_data["accounts"]#[0]
    meta_data = account.get_metadata()
    # Fetch details
    details = account.get_details()
    # Fetch balances
    balances = account.get_balances()
    # Fetch transactions
    transactions = account.get_transactions()
    Rails.logger.info("TRANSACTIONS: #{transactions}")

    user = current_user
    if !user.bank_accounts.exists?(account_number: account_id)
      #if there isnt an account linked to user with this account_id
      #make one
      bank_account = user.bank_accounts.create(
        account_number: account_id,
        bank_name: session['bank_name'],
        balance: balances[0]
        requisition_id: requisition_id
      )
    else #there already is an account
      bank_account = user.find_by(id: account_id)
      bank_account.requisition_id = requisition_id
    end
  end
end
