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
    bank_id = params['bank_id'] #retreive bank id from button
    # Rails.logger.info("HERE--------------------------- #{bank_id}") #this works
  end
end
