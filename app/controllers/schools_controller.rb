class SchoolsController < ApplicationController
  skip_before_action :check_locale
  skip_around_action :switch_locale

  def index
    render json: School.all.to_json
  end
end
