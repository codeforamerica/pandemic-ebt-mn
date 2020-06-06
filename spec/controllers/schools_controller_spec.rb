require 'rails_helper'

RSpec.describe SchoolsController do
  describe '#index' do
    it 'returns a 200' do
      get :index
      expect(response.code).to eq('200')
    end

    it 'filters data when presented with a search term' do
      get :index, params: { term: 'High' }
      expected = [
        'High School For Recording Arts',
        'High School Summer Program',
        'Higher Ground Academy'
      ].map { |e| { value: e, label: e } }.to_json
      expect(response.body).to eq(expected)
    end

    it 'filters data when presented with a partial search term' do
      get :index, params: { term: 'Mid' }
      expected = [
        'Mid State Ed Dist Steps Trans. Prog',
        'Middle Area Learning Center',
        'Middle Level Alternative Program'
      ].map { |e| { value: e, label: e } }.to_json
      expect(response.body).to eq(expected)
    end

    it 'filters data regardless of case' do
      get :index, params: { term: 'mid' }
      expected = [
        'Mid State Ed Dist Steps Trans. Prog',
        'Middle Area Learning Center',
        'Middle Level Alternative Program'
      ].map { |e| { value: e, label: e } }.to_json
      expect(response.body).to eq(expected)
    end

    it 'returns all data when search term is empty' do
      get :index, params: { term: '' }
      expected = [
        '112 ALC Independent Study',
        '112 ALC Middle School',
        '112 ALC Seat-Based'
      ].map { |e| { value: e, label: e } }.to_json
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
        'Elementary ALC Targeted Services',
        'Elementary Extended Year Program',
        'Elementary Lighthouse'
      ].map { |e| { value: e, label: e } }.to_json
      expect(response.body).to eq(expected)
    end
  end
end
