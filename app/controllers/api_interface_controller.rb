# class ApiInterfaceController < ApplicationController

#     client = Nordigen::NordigenClient.new(
#         secret_id: ENV['NORDIGEN_SECRET_ID'],
#         secret_key: ENV['NORDIGEN_SECRET_KEY']
#     )    

#     # Generate new access token. Token is valid for 24 hours
#     token_data = client.generate_token()

#     # # Use existing token
#     # client.set_token("YOUR_TOKEN")

#     access_token = token_data["access"]
#     refresh_token = token_data["refresh"]

#     # # Exchange refresh token. Refresh token is valid for 30 days
#     # refresh_token = client.exchange_token(refresh_token)

#     institutions = client.institution.get_institutions("GB")

# end
