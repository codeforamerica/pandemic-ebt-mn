require 'rails_helper'

describe 'School' do
  STUBBED_ID = '1009001000'.freeze
  STUBBED_CITY = 'St Paul'.freeze
  before do
    stub_const('SCHOOL_LIST', [
      'A Great School',
      'Another Great School',
      'Best School Ever',
      'Completely Awesome School',
      'Great Expectations',
      'Superschool of Awesome',
      'Superschool of OK',
      'Superschool of Superheroes',
      'The Greatest School',
      'The Superest School'
    ].map { |school| HashWithIndifferentAccess.new('Name': school, 'stateorganizationid': STUBBED_ID, 'Site City': STUBBED_CITY) })
  end

  describe '#where' do
    it 'finds results that start with the term' do
      expected = [
        'Superschool of Awesome',
        'Superschool of OK',
        'Superschool of Superheroes',
        'The Superest School'
      ]
      actual = School.where('Super')
      expect(actual).to eq(expected)
    end

    it 'finds results that include the term' do
      expected = [
        'Completely Awesome School',
        'Superschool of Awesome'
      ]
      actual = School.where('Awesome')
      expect(actual).to eq(expected)
    end

    it 'finds results regardless of case' do
      expected = [
        'Completely Awesome School',
        'Superschool of Awesome'
      ]
      actual = School.where('awesome')
      expect(actual).to eq(expected)
    end

    it 'finds results that end with the term' do
      expected = [
        'Best School Ever'
      ]
      actual = School.where('Ever')
      expect(actual).to eq(expected)
    end
  end

  describe '#find_sorted_by_term' do
    it 'limits results to 3' do
      expected = [
        'Superschool of Awesome',
        'Superschool of OK',
        'Superschool of Superheroes'
      ].map { |e| { label: "#{e} - #{STUBBED_CITY}", value: e } }
      actual = School.find_sorted_by_term('Super')
      expect(actual).to eq(expected)
    end

    it 'prioritizes results that start with the term even when not alphabetically first' do
      expected = [
        'Great Expectations',
        'A Great School',
        'Another Great School'
      ].map { |e| { label: "#{e} - #{STUBBED_CITY}", value: e } }
      actual = School.find_sorted_by_term('Great')
      expect(actual).to eq(expected)
    end

    it 'handles cases where no data is returned' do
      expected = []
      actual = School.find_sorted_by_term('ZZZZZZZZ')
      expect(actual).to eq(expected)
    end

    it 'handles cases where term is nil by returning the first 3 records' do
      expected = 3
      actual = School.find_sorted_by_term(nil).length
      expect(actual).to eq(expected)
    end

    it 'returns the city with the name as the label' do
      expected = [{ label: "Great Expectations - #{STUBBED_CITY}",
                    value: 'Great Expectations' }]
      actual = School.find_sorted_by_term('Great Expectations')
      expect(actual).to eq(expected)
    end
  end

  describe '#org_id_for' do
    it 'returns the state organization id for matches' do
      expected = STUBBED_ID
      school = 'Great Expectations'
      expect(School.org_id_for(school)).to eq expected
    end

    it 'returns the state organization id for matches regardless of case' do
      expected = STUBBED_ID
      school = 'great expectations'
      expect(School.org_id_for(school)).to eq expected
    end

    it 'returns an empty string for no matches' do
      expected = ''
      school = 'School of Awesome Rock'
      expect(School.org_id_for(school)).to eq expected
    end
  end
end
