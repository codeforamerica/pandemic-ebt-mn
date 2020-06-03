class SchoolsController < ApplicationController
  skip_before_action :check_locale
  skip_around_action :switch_locale

  def index
    render json: School.find_sorted_by_term(params[:term])
  end
end
