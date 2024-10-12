# class OffersController < ApplicationController



# def index
#     offers = Offer.includes(:catalogue_variant).all
#     render json: offers.map { |offer|
#       {
#         id: offer.id,
#         offer_name: offer.offer_name,
#         discount: offer.discount,
#         start_date: offer.start_date,
#         end_date: offer.end_date,
#         discounted_price: offer.discounted_price # Accessing the method defined in Offer
#       }
#     }
#   end
  
#     def create
#       offer = Offer.create(offer_params)
#       if offer.save
#         render json: offer, status: :created
#       else 
#         render json: offer.errors 
#       end  
#    end
  
  
#    def offer_params
#     params.require(:offer).permit(:offer_name, :discount, :start_date, :end_date, :catalogue_variant_id)
#    end
  
#   end



class OffersController < ApplicationController
def index
  pagy, offers = pagy(
    Offer.select(:id, :offer_name, :discount, :start_date, :end_date, :catalogue_variant_id)
         .includes(:catalogue_variant)
         .order(created_at: :desc),
    items: 10
  )

  render json: {
    offers: OfferSerializer.new(offers).serializable_hash[:data],
    meta: pagination_metadata(pagy)
  }
end

  def create
    offer = Offer.new(offer_params)
    if offer.save
      render json: offer, serializer: OfferSerializer, status: :created
    else
      render json: offer.errors, status: :unprocessable_entity
    end
  end

  private

  def offer_params
    params.require(:offer).permit(:offer_name, :discount, :start_date, :end_date, :catalogue_variant_id)
  end

  # Ensure the pagination method name matches
  # def pagination_metadata(pagy)
  #   {
  #     current_page: pagy.page,
  #     total_pages: pagy.pages,
  #     total_count: pagy.count
  #   }
  # end
end
