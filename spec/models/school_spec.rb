require 'rails_helper'

describe 'School' do
  before do
    stub_const("SCHOOL_LIST", [
      "A Great School",
      "Another Great School",
      "Best School Ever",
      "Completely Awesome School",
      "Great Expectations",
      "Superschool of Awesome",
      "Superschool of OK",
      "Superschool of Superheroes",
      "The Greatest School"
    ])
  end

  describe '#where' do
    it 'finds results that start with the term' do
      expected = [
        "Superschool of Awesome",
        "Superschool of OK",
        "Superschool of Superheroes"
      ]
      actual = School.where('Super')
      expect(actual).to eq(expected)
    end

    it 'finds results that include the term' do
      expected = [
        "Completely Awesome School",
        "Superschool of Awesome"
      ]
      actual = School.where('Awesome')
      expect(actual).to eq(expected)
    end

    it 'finds results regardless of case' do
      expected = [
        "Completely Awesome School",
        "Superschool of Awesome"
      ]
      actual = School.where('awesome')
      expect(actual).to eq(expected)
    end

    it 'finds results that end with the term' do
      expected = [
        "Best School Ever"
      ]
      actual = School.where('Ever')
      expect(actual).to eq(expected)
    end
  end

  describe '#find_sorted_by_term' do
    it 'limits results to 3' do
      expected = [
        "Superschool of Awesome",
        "Superschool of OK",
        "Superschool of Superheroes"
      ].map { |e| {label: e, value: e} }
      actual = School.find_sorted_by_term('Super')
      expect(actual).to eq(expected)
    end

    it 'prioritizes results that start with the term even when not alphabetically first' do
      expected = [
        "Superschool of Awesome",
        "Superschool of OK",
        "Superschool of Superheroes"
      ].map { |e| {label: e, value: e} }
      actual = School.find_sorted_by_term('Super')
      expect(actual).to eq(expected)
    end
  end
end

