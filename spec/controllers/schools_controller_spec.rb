require 'rails_helper'

RSpec.describe SchoolsController do
  describe '#index' do
    it 'returns a 200' do
      get :index
      expect(response.code).to eq('200')
    end

    it 'filters data when presented with a search term' do
      get :index, params: { term: 'High' }
      expected = [{ value: '270 Hopkins North Junior High ALC', label: '270 Hopkins North Junior High ALC' }, { value: '270 Hopkins North Junior High TS', label: '270 Hopkins North Junior High TS' }, { value: '270 Hopkins West Junior High ALC', label: '270 Hopkins West Junior High ALC' }].to_json
      expect(response.body).to eq(expected)
    end

    it 'filters data when presented with a partial search term' do
      get :index, params: { term: 'Mid' }
      expected = [{ value: '112 ALC Middle School', label: '112 ALC Middle School' }, { value: '272 Central Mid Sch TS', label: '272 Central Mid Sch TS' }, { value: '273 So View Middle TS', label: '273 So View Middle TS' }].to_json
      expect(response.body).to eq(expected)
    end

    it 'filters data regardless of case' do
      get :index, params: { term: 'mid' }
      expected = [{ value: '112 ALC Middle School', label: '112 ALC Middle School' }, { value: '272 Central Mid Sch TS', label: '272 Central Mid Sch TS' }, { value: '273 So View Middle TS', label: '273 So View Middle TS' }].to_json
      expect(response.body).to eq(expected)
    end

    it 'returns all data when search term is empty' do
      get :index, params: { term: '' }
      expected = [{ value: '112 ALC Independent Study', label: '112 ALC Independent Study' }, { value: '112 ALC Middle School', label: '112 ALC Middle School' }, { value: '112 ALC Seat-Based', label: '112 ALC Seat-Based' }].to_json
      expect(response.body).to eq(expected)
    end

    it 'returns no data when search term does not match' do
      get :index, params: { term: 'Los Angeles High School' }
      expected = [].to_json
      expect(response.body).to eq(expected)
    end

    it 'limits the results to 3 items, sorted alphabetically' do
      get :index, params: { term: 'Elementary' }
      expected =  [{ value: '270 - Glen Lake Elementary', label: '270 - Glen Lake Elementary' }, { value: '270 Alice Smith Elementary TS', label: '270 Alice Smith Elementary TS' }, { value: '270 Eisenhower Elementary TS', label: '270 Eisenhower Elementary TS' }].to_json
      expect(response.body).to eq(expected)
    end
  end
end
