class CatalogueVariantsController < ApplicationController

    def index
      catalogue_variants = CatalogueVariant.all
  
      render json: catalogue_variants.map { |catalogue_variant|
        {
          price: catalogue_variant.price.to_f, # Uncommented and fixed the variable name
          discounted_price: catalogue_variant.discounted_price.to_f,
          offers: catalogue_variant.offers.map { |offer| 
            { 
              offer_name: offer.offer_name, 
              discount: offer.discount.to_f 
            } 
          }
                }
      }
    end
  
  end