require_relative "../services/client"

class TransactionController < ApplicationController
  before_action :authenticate_user!
  def index
    #check to make sure their account is linked
    #show transactions
  end

  def linked #landing for after users link their account
    #check account is linked
    #display message
    #redirect to index

    #NEED TO CHECK USER IS SIGNED IN

    client = Client.create_client

    Rails.logger.info("Session ID after redirect: #{request.session_options[:id]}")
    Rails.logger.info("Session Data after redirect: #{session.to_hash}")

    #retreive reqID from TemporyUserDatum
    temporary_user_datum = TemporaryUserDatum.find_by(user: current_user)
    requisition_id = temporary_user_datum&.requisition_id
    
    Rails.logger.info("TC, Retrieved requisition_id: #{requisition_id} for user: #{current_user.id}")

    # requisition_id = session[:requisition_id]
    requisition_data = client.requisition.get_requisition_by_id(requisition_id)
    Rails.logger.info("TC, Req ID: #{requisition_id}")
    Rails.logger.info("TC, Req ID: #{requisition_data}")

    Rails.logger.info("Accounts: #{requisition_data["accounts"]}")
    # begin 
    #   account =  requisition_data["accounts"]#[0] #error probably going to be thrown here
    # rescue => e
    #   account =  requisition_data["accounts"][0]
    #   Rails.logger.info("Error thrown trying to get accounts")
    # end
    account_id =  requisition_data["accounts"][0]
    Rails.logger.info("account ID: #{account_id}")
    # Instantiate account object
    account = client.account(account_id)
    Rails.logger.info("account: #{account}")
    meta_data = account.get_metadata()
    # Fetch details
    details = account.get_details()
    # Fetch balances
    balances = account.get_balances()
    # Fetch transactions
    transactions = account.get_transactions()
    Rails.logger.info("TC, TRANSACTIONS: #{transactions}")
    Rails.logger.info("TC, BALANCES: #{balances}")
    Rails.logger.info("TC, DETAILS: #{details}")
    Rails.logger.info("TC, METADATA: #{meta_data}")

    begin
      user = current_user
      if !user.bank_accounts.exists?(account_number: account_id)
        #if there isnt an account linked to user with this account_id
        #make one
        bank_account = user.bank_accounts.create(
          account_number: account_id,
          bank_name: session['bank_name'],
          balance: balances[0],
          requisition_id: requisition_id
        )
      else #there already is an account
        bank_account = user.find_by(id: account_id)
        bank_account.requisition_id = requisition_id
      end
    rescue => e
      Rails.logger.info("Error, failed to save bank details to user")
    end

    #destroy the row the req id came from so a user can have more than one bank account
    temporary_user_datum&.destroy
  end
end
