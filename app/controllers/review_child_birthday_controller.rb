class ReviewChildBirthdayController < FormsController
  def self.show?(_household)
    false
  end

  def edit
    if current_household.submitted_at.present?
      redirect_to(success_steps_path)
      return
    end
    @child = Child.find params[:id]
    if @child.household != current_household
      redirect_to(review_steps_path)
      return
    end
    params = {
      id: @child.id,
      dob_day: @child.dob.strftime('%-d'),
      dob_month: @child.dob.strftime('%-m'),
      dob_year: @child.dob.strftime('%Y')
    }
    @form = form_class.new(current_household, params)
  end
end
