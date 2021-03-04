require 'rails_helper'

RSpec.describe AddressCleaner do
  describe '#run' do
    it 'sets the cleaned_address fields' do
      cleaner = described_class.new

      allow(cleaner).to receive(:get_result).and_return(
        OpenStruct.new(
          delivery_line_1: '123 Main St',
          delivery_line_2: 'Unit B',
          components: OpenStruct.new(
            city_name: 'Minneapolis',
            zipcode: '55443',
            state_abbreviation: 'MN'
          ),
          metadata: OpenStruct.new(
            latitude: '37.781712',
            longitude: '-122.408363'
          )
        )
      )

      hh = Household.new
      cleaner.run(hh)

      expect(hh.clean_street_1).to eq('123 Main St')
      expect(hh.clean_street_2).to eq('Unit B')
      expect(hh.clean_city).to eq('Minneapolis')
      expect(hh.clean_zip_code).to eq('55443')
      expect(hh.clean_state).to eq('MN')
      expect(hh.cleaned_address).to be_truthy
    end
  end
end
