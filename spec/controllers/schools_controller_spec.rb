require 'rails_helper'

RSpec.describe SchoolsController do
  describe '#index' do
    before do
      School.create({ state_organization_id: 1001, organization_name: 'CFA High' })
      School.create({ state_organization_id: 1002, organization_name: 'CFA Middle' })
    end

    it 'returns a 200' do
      get :index
      expect(response.code).to eq('200')
    end

    it 'returns all the records' do
      get :index
      expected = School.all.to_json
      expect(response.body).to eq(expected)
    end
  end
end
