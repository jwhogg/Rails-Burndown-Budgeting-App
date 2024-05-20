require_relative "../services/client"

class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    client = Client.create_client
    access_token = client.generate_token()['access']

    country = 'GB'
    institutions = client.institution.get_institutions(country)
    list = institutions.collect {|el| OpenStruct.new(el).marshal_dump }.to_json
    # Rails.logger.info("Value of @list: #{@list}")
    @banks = JSON.parse(list)
  end

  def activate_bank
    client = Client.create_client
    bank_id = params['bank_id'] #retreive bank id from button
    # Rails.logger.info("HERE--------------------------- #{bank_id}") #this works

    #initalise a bank authorisation session
    init = client.init_session(
      # redirect url after successful authentication
      redirect_url: "https://gocardless.com",
      # institution id
      institution_id: bank_id,
      # a unique user ID of someone who's using your services, usually it's a UUID
      reference_id: SecureRandom.uuid,
      # A two-letter country code (ISO 639-1)
      user_language: "en",
      # option to enable account selection view for the end user
      account_selection: false
    )
    link = init["link"] # bank authorization link
    requisition_id = init["id"] # requisition id that is needed to get an account_id
    Rails.logger.info("LINK------ #{link}")
    redirect_to link, allow_other_host: true
  end
end
