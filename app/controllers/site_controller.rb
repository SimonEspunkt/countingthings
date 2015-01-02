class SiteController < ApplicationController

  def index
    if current_user
      redirect_to things_path
    end
  end
  
end
