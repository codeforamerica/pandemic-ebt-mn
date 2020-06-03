require 'rails_helper'

RSpec.describe EligibleController do
  it_behaves_like 'form controller base behavior', Household.create({ is_eligible: :yes })

  describe '#update' do
    it 'updates the experiment group if present' do
      session[:experiment_group] = 'mn_early'
      put :update, params: { form: { is_eligible: 'no' }, locale: I18n.default_locale }

      household = Household.last

      expect(household.is_eligible).to eq('no')
      expect(household.experiment_group).to eq('mn_early')
    end
  end
end
