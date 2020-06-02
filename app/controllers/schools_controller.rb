class SchoolsController < ApplicationController
  skip_before_action :check_locale
  skip_around_action :switch_locale

  def index
    render json: School.where('organization_name ILIKE ?',
                              "%#{params[:term]}%")
                       .order(:organization_name)
                       .limit(3)
                       .to_json(only: %i[label value])
  end
end
