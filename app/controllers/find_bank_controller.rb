class FindBankController < ApplicationController
  before_action :authenticate_user!

  def index
    client = Client.create_client
    access_token = client.generate_token()['access']

    country = 'GB'
    institutions = client.institution.get_institutions(country)
    list = institutions.collect {|el| OpenStruct.new(el).marshal_dump }.to_json
    # Rails.logger.info("Value of @list: #{@list}")
    @banks = JSON.parse(list)

    Rails.logger.info("Session ID before redirect: #{request.session_options[:id]}")
    Rails.logger.info("Session Data before redirect: #{session.to_hash}")
  end
  
  def activate_bank
    client = Client.create_client
    bank_id = params['bank_id'] #retreive bank id from button
    session['bank_name'] = params['bank_name']
    # Rails.logger.info("HERE--------------------------- #{bank_id}") #this works

    reference_id = SecureRandom.uuid

    #initalise a bank authorisation session
    init = client.init_session(
      # redirect url after successful authentication
      redirect_url: link_landingpage_url,
      # institution id
      institution_id: bank_id,
      # a unique user ID of someone who's using your services, usually it's a UUID
      reference_id: reference_id,
      # A two-letter country code (ISO 639-1)
      user_language: "en",
      # option to enable account selection view for the end user
      account_selection: false
    )
    Rails.logger.info("INIT------ #{init}")
    link = init["link"] # bank authorization link
    requisition_id = init["id"] # requisition id that is needed to get an account_id
    session[:requisition_id] = requisition_id
    session[:reference_id] = reference_id
    Rails.logger.info("FB, REF ID------ #{reference_id}")
    Rails.logger.info("FB, REQ ID------ #{requisition_id}")
    Rails.logger.info("LINK------ #{link}")
    Rails.logger.info("Session ID before redirect: #{request.session_options[:id]}")
    Rails.logger.info("Session Data before redirect: #{session.to_hash}")
    # store Req ID to TemporyUserDatum
    temporary_user_datum = TemporaryUserDatum.create!(user: current_user, requisition_id: requisition_id)
    Rails.logger.info("TemporaryUserDatum created with requisition_id: #{temporary_user_datum.requisition_id}")
    Rails.logger.info("current user: #{current_user.id}")
    Rails.logger.info("TUD user: #{temporary_user_datum.user}, -- #{temporary_user_datum.user.id}")
    Rails.logger.info("Before Retreived Req ID: #{TemporaryUserDatum.find_by(user: current_user)&.requisition_id}")

    redirect_to link, allow_other_host: true
  end
end

