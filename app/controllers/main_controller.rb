class MainController < ApplicationController
  
  def index
    render :layout => logged_in? ? 'app' : 'site'
  end
  
end