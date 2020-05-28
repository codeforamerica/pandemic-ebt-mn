require 'rails_helper'

RSpec.describe ChildrenController do
  it_behaves_like 'form controller base behavior', Household.create({ is_eligible: :yes })
  it_behaves_like 'form controller always shows'

  describe '#destroy' do
    it 'deletes the child' do
      household = Household.create({ is_eligible: :yes })
      household.children.create(first_name: 'Jan', last_name: 'Jones')
      session[:current_household_id] = household.id

      delete :destroy, params: { id: household.children.first.id, locale: I18n.default_locale }

      household.reload

      expect(household.children.count).to eq(0)
    end
  end

  describe 'index' do
    it 'does not expose this' do
      expect { get '/children.csv' }.to raise_error(ActionController::UrlGenerationError)
    end
  end
end
