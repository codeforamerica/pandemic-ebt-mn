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

    it 'processes the data into the label/value format' do
      get :index
      expected = [
        { value: 'CFA High', label: 'CFA High' },
        { value: 'CFA Middle', label: 'CFA Middle' }
      ].to_json
      expect(response.body).to eq(expected)
    end

    it 'filters data when presented with a search term' do
      get :index, params: { term: 'High' }
      expected = [
        { value: 'CFA High', label: 'CFA High' }
      ].to_json
      expect(response.body).to eq(expected)
    end

    it 'filters data when presented with a partial search term' do
      get :index, params: { term: 'Mid' }
      expected = [
        { value: 'CFA Middle', label: 'CFA Middle' }
      ].to_json
      expect(response.body).to eq(expected)
    end

    it 'filters data regardless of case' do
      get :index, params: { term: 'mid' }
      expected = [
        { value: 'CFA Middle', label: 'CFA Middle' }
      ].to_json
      expect(response.body).to eq(expected)
    end

    it 'returns all data when search term is empty' do
      get :index, params: { term: '' }
      expected = [
        { value: 'CFA High', label: 'CFA High' },
        { value: 'CFA Middle', label: 'CFA Middle' }
      ].to_json
      expect(response.body).to eq(expected)
    end

    it 'returns no data when search term does not match' do
      get :index, params: { term: 'Los Angeles High School' }
      expected = [].to_json
      expect(response.body).to eq(expected)
    end

    it 'limits the results to 3 items, sorted alphabetically' do
      School.create({ state_organization_id: 1003, organization_name: 'CFA Elementary' })
      School.create({ state_organization_id: 1004, organization_name: 'CFA Prep' })
      get :index, params: { term: 'CFA' }
      expected = [
        { value: 'CFA Elementary', label: 'CFA Elementary' },
        { value: 'CFA High', label: 'CFA High' },
        { value: 'CFA Middle', label: 'CFA Middle' }
      ].to_json
      expect(response.body).to eq(expected)
    end
  end
end
