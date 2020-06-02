require 'rails_helper'

RSpec.describe SchoolsController do
  describe '#index' do
    it 'returns a 200' do
      get :index
      expect(response.code).to eq('200')
    end

    it 'filters data when presented with a search term' do
      get :index, params: { term: 'High' }
      expected = [{ id: 60_287_709_000, value: '270 Hopkins North Junior High ALC', label: '270 Hopkins North Junior High ALC' }, { id: 60_287_715_000, value: '270 Hopkins North Junior High TS', label: '270 Hopkins North Junior High TS' }, { id: 60_287_710_000, value: '270 Hopkins West Junior High ALC', label: '270 Hopkins West Junior High ALC' }].to_json
      expect(response.body).to eq(expected)
    end

    it 'filters data when presented with a partial search term' do
      get :index, params: { term: 'Mid' }
      expected = [{ id: 10_112_066_000, value: '112 ALC Middle School', label: '112 ALC Middle School' }, { id: 60_287_743_000, value: '272 Central Mid Sch TS', label: '272 Central Mid Sch TS' }, { id: 60_287_689_000, value: '273 So View Middle TS', label: '273 So View Middle TS' }].to_json
      expect(response.body).to eq(expected)
    end

    it 'filters data regardless of case' do
      get :index, params: { term: 'mid' }
      expected = [{ id: 10_112_066_000, value: '112 ALC Middle School', label: '112 ALC Middle School' }, { id: 60_287_743_000, value: '272 Central Mid Sch TS', label: '272 Central Mid Sch TS' }, { id: 60_287_689_000, value: '273 So View Middle TS', label: '273 So View Middle TS' }].to_json
      expect(response.body).to eq(expected)
    end

    it 'returns all data when search term is empty' do
      get :index, params: { term: '' }
      expected = [{ id: 10_112_067_000, value: '112 ALC Independent Study', label: '112 ALC Independent Study' }, { id: 10_112_066_000, value: '112 ALC Middle School', label: '112 ALC Middle School' }, { id: 10_112_071_000, value: '112 ALC Seat-Based', label: '112 ALC Seat-Based' }].to_json
      expect(response.body).to eq(expected)
    end

    it 'returns no data when search term does not match' do
      get :index, params: { term: 'Los Angeles High School' }
      expected = [].to_json
      expect(response.body).to eq(expected)
    end

    it 'limits the results to 3 items, sorted alphabetically' do
      get :index, params: { term: 'Elementary' }
      expected =  [{ id: 60_287_793_000, value: '270 - Glen Lake Elementary', label: '270 - Glen Lake Elementary' }, { id: 60_287_675_000, value: '270 Alice Smith Elementary TS', label: '270 Alice Smith Elementary TS' }, { id: 60_287_695_000, value: '270 Eisenhower Elementary TS', label: '270 Eisenhower Elementary TS' }].to_json
      expect(response.body).to eq(expected)
    end
  end
end
