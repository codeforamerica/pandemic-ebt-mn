class SignatureForm < Form
  NULL_BYTE = "\u0000".freeze
  set_attributes_for :household, :signature, :community_organization, :did_you_get_help
  validates_presence_of :signature, message: proc { I18n.t('validations.signature') }

  def save
    Household.transaction do
      Household.connection.execute('LOCK households IN ACCESS EXCLUSIVE MODE')
      form_attributes = attributes_for(:household)
      attributes = {
        community_organization: form_attributes[:community_organization],
        did_you_get_help: form_attributes[:did_you_get_help],
        signature: form_attributes[:signature].to_s.gsub(NULL_BYTE, ' ').strip,
        huid: (household.huid || Household.next_huid)
      }
      household.update(attributes.merge({ submitted_at: Time.zone.now }))
    end
  end
end
