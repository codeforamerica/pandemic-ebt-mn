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
        'High School for Recording Arts',
        'Higher Ground Academy',
        'Higher Ground Secondary Academy'
      ].map { |e| { value: e, label: e } }.to_json
      expect(response.body).to eq(expected)
    end

    it 'filters data when presented with a partial search term' do
      get :index, params: { term: 'Mid' }
      expected = [
        'Mid-State Education District',
        'Middleton Elementary',
        'AFSA Middle School'
      ].map { |e| { value: e, label: e } }.to_json
      expect(response.body).to eq(expected)
    end

    it 'filters data regardless of case' do
      get :index, params: { term: 'mid' }
      expected = [
        'Mid-State Education District',
        'Middleton Elementary',
        'AFSA Middle School'
      ].map { |e| { value: e, label: e } }.to_json
      expect(response.body).to eq(expected)
    end

    it 'returns all data when search term is empty' do
      get :index, params: { term: '' }
      expected = [
        '916 Mahtomedi Academy',
        'ACGC Elementary',
        'ACGC Secondary'
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
        'ACGC Elementary',
        'Ada Borup Elementary',
        'Adams Elementary'
      ].map { |e| { value: e, label: e } }.to_json
      expect(response.body).to eq(expected)
    end
  end
end
