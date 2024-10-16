class CatalogueVariantsController < ApplicationController


  def index
    # Paginate catalogue variants with Pagy and include associations
    pagy, catalogue_variants = pagy(
      CatalogueVariant.includes(:offers, :catalogue_variant_size, :catalogue_variant_color).all, # Eager load offers, size, and color
      items: 20
    )

    # Use ActiveModelSerializers to serialize the paginated catalogue variants
    render json: {
      catalogue_variants: ActiveModelSerializers::SerializableResource.new(catalogue_variants, each_serializer: CatalogueVariantSerializer),
      meta: pagination_metadata(pagy) # Include pagination metadata
    }
  end

  


def emi
  catalogue_variant = CatalogueVariant.find(params[:id])
  if !catalogue_variant
    render json:{message:"catalogue_variant not found"}
  end

  principal = catalogue_variant.price.to_f
  interest_rate = params[:interest_rate].to_f / 100 / 12 


  tenure = params[:tenure].to_i
  if tenure <= 50
    tenure = tenure * 12
  end

  if interest_rate > 0
    emi = (principal * interest_rate * ((1 + interest_rate)**tenure)) / (((1 + interest_rate)**tenure) - 1)
  else
 
    emi = principal / tenure
  end

  # Return the calculated EMI and total amount
  render json: {
    catalogue_variant_id: catalogue_variant.id,
    principal: principal,
    interest_rate: params[:interest_rate],
    tenure_in_months: tenure,
    emi: emi.round(2),
    total_amount: (emi * tenure).round(2) 
  }
end




end