class CatalogueVariantsController < ApplicationController
skip_before_action :verify_authenticity_token

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
  


def emi

    catalogue_variant = CatalogueVariant.find(params[:id])
    principal = catalogue_variant.price.to_f # Using feature price as the principal amount
    interest_rate = params[:interest_rate].to_f / 100 / 12 # Monthly interest rate

    # Convert tenure into months if it's in years (default it to years if value is < 50)
    tenure = params[:tenure].to_i
    if tenure <= 50
      tenure = tenure * 12  # Assume the input is in years, convert it to months
    end

    # EMI Calculation: P * r * (1 + r)^n / [(1 + r)^n - 1]
    emi = (principal * interest_rate * ((1 + interest_rate) * tenure)) / (((1 + interest_rate) * tenure) - 1)

    render json: {
      catalogue_variant_id: catalogue_variant.id,
      principal: principal,
      interest_rate: params[:interest_rate],
      tenure_in_months: tenure,
      emi: emi.round(2), # Rounded EMI value
      total_amount: (emi * tenure).to_i
    }
  end



end