require_relative "../services/client"

class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    user = current_user
    
    user_has_req_id = TemporaryUserDatum.exists?(user: user)

    #if user doesnt have a linked account OR not a Req ID in the temporary DB
    if !user.linked_account? || !user_has_req_id
      #if the user doesnt have a linked account, redirect them to link theirs
      redirect_to find_bank_url
    elsif user_has_req_id
      #redirect to LINKED action
      redirect_to link_landingpage_url
    else
      #all logic goes in here, where the user DOES have a linked account
      #show transactions
      @balances = []
      user.bank_accounts.each do |bank_account|
        @balances << bank_account.get_account_balances
      end
    end
  end
  # def index
  #   client = Client.create_client
  #   access_token = client.generate_token()['access']

  #   country = 'GB'
  #   institutions = client.institution.get_institutions(country)
  #   list = institutions.collect {|el| OpenStruct.new(el).marshal_dump }.to_json
  #   # Rails.logger.info("Value of @list: #{@list}")
  #   @banks = JSON.parse(list)
  # end
  
  # def activate_bank
  #   client = Client.create_client
  #   bank_id = params['bank_id'] #retreive bank id from button
  #   session['bank_name'] = params['bank_name']
  #   # Rails.logger.info("HERE--------------------------- #{bank_id}") #this works

  #   #initalise a bank authorisation session
  #   init = client.init_session(
  #     # redirect url after successful authentication
  #     redirect_url: link_landingpage_url,
  #     # institution id
  #     institution_id: bank_id,
  #     # a unique user ID of someone who's using your services, usually it's a UUID
  #     reference_id: SecureRandom.uuid,
  #     # A two-letter country code (ISO 639-1)
  #     user_language: "en",
  #     # option to enable account selection view for the end user
  #     account_selection: false
  #   )
  #   Rails.logger.info("INIT------ #{init}")
  #   link = init["link"] # bank authorization link
  #   requisition_id = init["id"] # requisition id that is needed to get an account_id
  #   session[:requisition_id] = requisition_id
  #   Rails.logger.info("LINK------ #{link}")
  #   redirect_to link, allow_other_host: true
  # end
end
