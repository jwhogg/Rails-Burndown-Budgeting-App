require 'nordigen-ruby'
require 'dotenv/load'

class Client

    def self.create_client
        # Create client instance
        return Nordigen::NordigenClient.new(
            secret_id: ENV['NORDIGEN_SECRET_ID'],
            secret_key: ENV['NORDIGEN_SECRET_KEY']
        )
    end

end