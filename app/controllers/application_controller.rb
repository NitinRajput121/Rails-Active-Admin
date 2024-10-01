class ApplicationController < ActionController::Base
	skip_before_action :verify_authenticity_token

	include Pagy::Backend

	private 

	  def pagination_metadata(pagy)
	    {
	      current_page: pagy.page,
	      total_pages: pagy.pages,
	      total_count: pagy.count
	    }
	  end

	
end
