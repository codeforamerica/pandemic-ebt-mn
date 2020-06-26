class AddressCleaner
  def run(household)
    result = get_result(household)

    if result.blank?
      household.clean_street_1 = household.mailing_street
      household.clean_street_2 = household.mailing_street_2
      household.clean_city = household.mailing_city
      household.clean_zip_code = household.mailing_zip_code
      household.clean_state = household.mailing_state
    else
      household.clean_street_1 = result.delivery_line_1
      household.clean_street_2 = result.delivery_line_2
      household.clean_city = result.components.city_name
      household.clean_zip_code = result.components.zipcode
      household.clean_state = result.components.state_abbreviation
      if result&.metadata&.latitude.present? && result&.metadata&.longitude.present?
        household.clean_coordinates = [result.metadata.longitude, result.metadata.latitude]
      end
    end

    household.cleaned_address = true
    household.save
  end

  def get_result(household)
    auth_id = ENV['SMARTY_AUTH_ID'] || Rails.application.credentials.smarty_streets[:auth_id]
    auth_token = ENV['SMARTY_AUTH_TOKEN'] || Rails.application.credentials.smarty_streets[:auth_token]
    credentials = SmartyStreets::StaticCredentials.new(auth_id, auth_token)
    client = SmartyStreets::ClientBuilder.new(credentials).build_us_street_api_client

    lookup = SmartyStreets::USStreet::Lookup.new
    lookup.input_id = household.id
    lookup.street = household.mailing_street
    lookup.street2 = household.mailing_street_2
    lookup.city = household.mailing_city
    lookup.state = household.mailing_state
    lookup.zipcode = household.mailing_zip_code
    lookup.candidates = 1
    lookup.match = 'invalid'

    begin
      client.send_lookup(lookup)
    rescue SmartyStreets::SmartyError => _e
      return
    end

    lookup.result[0]
  end
end
