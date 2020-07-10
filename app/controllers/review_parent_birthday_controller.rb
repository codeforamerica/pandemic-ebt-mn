class ReviewParentBirthdayController < FormsController
  def self.show?(_household)
    false
  end

  def edit
    if current_household.submitted_at.present?
      redirect_to(success_steps_path)
      return
    end
    params = {
      parent_dob_day: current_household.parent_dob.strftime('%-d'),
      parent_dob_month: current_household.parent_dob.strftime('%-m'),
      parent_dob_year: current_household.parent_dob.strftime('%Y')
    }
    @form = form_class.new(current_household, params)
  end
end
