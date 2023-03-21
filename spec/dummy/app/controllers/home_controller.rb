class HomeController < ApplicationController
  def index
    redirect_to "/mdr/content/test_files_home"
  end
end