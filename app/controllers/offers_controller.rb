

class OffersController < ApplicationController



    def index
  
    offer = Offer.all
    render json: offer
    end
  
    def create
      offer = Offer.create(offer_params)
      if offer.save
        render json: offer, status: :created
      else 
        render json: offer.errors 
      end  
   end
  
  
   def offer_params
    params.require(:offer).permit(:offer_name, :discount, :start_date, :end_date, :catalogue_variant_id)
   end
  
  end
