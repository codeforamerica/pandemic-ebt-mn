require 'rails_helper'

def formatter_helper(school_name, city)
  {
    value: school_name,
    label: "#{school_name} - #{city}"
  }
end

RSpec.describe SchoolsController do
  describe '#index' do
    it 'returns a 200' do
      get :index
      expect(response.code).to eq('200')
    end

    it 'filters data when presented with a search term' do
      get :index, params: { term: 'High' }
      expected = [
        formatter_helper('High School for Recording Arts', 'St Paul'),
        formatter_helper('Higher Ground Academy', 'St Paul'),
        formatter_helper('Higher Ground Secondary Academy', 'St. Paul')
      ].to_json
      expect(response.body).to eq(expected)
    end

    it 'filters data when presented with a partial search term' do
      get :index, params: { term: 'Mid' }
      expected = [
        formatter_helper('Mid-State Education District', 'Little Falls'),
        formatter_helper('Middleton Elementary', 'Woodbury'),
        formatter_helper('AFSA Middle School', 'Little Canada')
      ].to_json
      expect(response.body).to eq(expected)
    end

    it 'filters data regardless of case' do
      get :index, params: { term: 'mid' }
      expected = [
        formatter_helper('Mid-State Education District', 'Little Falls'),
        formatter_helper('Middleton Elementary', 'Woodbury'),
        formatter_helper('AFSA Middle School', 'Little Canada')
      ].to_json
      expect(response.body).to eq(expected)
    end

    it 'returns all data when search term is empty' do
      get :index, params: { term: '' }
      expected = [
        formatter_helper('916 Mahtomedi Academy', 'White Bear Lake'),
        formatter_helper('ACGC Elementary', 'Atwater'),
        formatter_helper('ACGC Secondary', 'Grove City')
      ].to_json
      expect(response.body).to eq(expected)
    end

    it 'returns no data when search term does not match' do
      get :index, params: { term: 'Los Angeles High School' }
      expected = [].to_json
      expect(response.body).to eq(expected)
    end

    it 'limits the results to 3 items, sorted alphabetically' do
      get :index, params: { term: 'Elementary' }
      expected = [
        formatter_helper('ACGC Elementary', 'Atwater'),
        formatter_helper('Ada Borup Elementary', 'Ada'),
        formatter_helper('Adams Elementary', 'St Paul')
      ].to_json
      expect(response.body).to eq(expected)
    end
  end
end
