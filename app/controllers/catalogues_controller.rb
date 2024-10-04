class CataloguesController < ApplicationController

# def index
#   sub_category_name = params[:sub_category_name]
#   gender = params[:gender]

#   catalogues = Catalogue.all

#   if sub_category_name.present?
#     sub_category = SubCategory.find_by(name: sub_category_name)
#     catalogues = sub_category.present? ? sub_category.catalogues : catalogues
#   end

#   if gender.present?
#     catalogues = catalogues.filter_by_gender(gender)
#   end

#   if catalogues.blank?
#     render json: { error: "No catalogues found" }, status: :not_found
#   else
#     render json: catalogues, each_serializer: CatalogueSerializer
#   end

#   sub_category_name = params[:sub_category_name]
#   gender = params[:gender]

#   # Get all catalogues initially
#   catalogues = Catalogue.all

#   # Filter by sub-category if the name is present
#   if sub_category_name.present?
#     sub_category = SubCategory.find_by(name: sub_category_name)
#     catalogues = sub_category.present? ? sub_category.catalogues : catalogues
#   end

#   # Filter by gender if the parameter is present
#   if gender.present?
#     catalogues = catalogues.filter_by_gender(gender)
#   end

#   # Apply pagination using pagy
#   pagy, paginated_catalogues = pagy(catalogues, items: 20) # Change 'items' to your preferred per-page count

#   if paginated_catalogues.blank?
#     render json: { error: "No catalogues found" }, status: :not_found
#   else
#     render json: {
#       catalogues: ActiveModelSerializers::SerializableResource.new(paginated_catalogues, each_serializer: CatalogueSerializer),
#       meta: pagination_metadata(pagy) # Include pagination metadata
#     }
#   end
# end

skip_before_action :authorize_request, only: [:create]


def index

  sub_category_name = params[:sub_category_name]
  gender = params[:gender]

  # Get all catalogues initially
  catalogues = Catalogue.all

  # Filter by sub-category if the name is present
  if sub_category_name.present?
    sub_category = SubCategory.find_by(name: sub_category_name)
    catalogues = sub_category.present? ? sub_category.catalogues : catalogues
  end

  # Filter by gender if the parameter is present
  if gender.present?
    catalogues = catalogues.filter_by_gender(gender)
  end

  # Apply pagination using pagy
  pagy, paginated_catalogues = pagy(catalogues, items: 10) # Change 'items' to your preferred per-page count

  # Handle case where no catalogues are found
  if paginated_catalogues.blank?
    render json: { error: "No catalogues found" }, status: :not_found
  else
    # Render the paginated catalogue list with metadata
    render json: {
      catalogues: ActiveModelSerializers::SerializableResource.new(paginated_catalogues, each_serializer: CatalogueSerializer),
      meta: pagination_metadata(pagy) # Include pagination metadata
    }
  end
end




def create
  catalogue = Catalogue.new(catalogue_params)
  if catalogue.save
    render json: catalogue, status: :created
  else
    render json: catalogue.errors, status: :unprocessable_entity
  end
end
  

  
  def search
    catalogue = Catalogue.all

    catalogue = catalogue.search(params[:q]) if params[:q].present?
    
    catalogue = catalogue.sorted_by(params[:sort_by])  if params[:sort_by].present?
    
    catalogue = catalogue.filter_by_gender(params[:gender]) if params[:gender].present?

    if catalogue.present?
     render json: catalogue
    else
      render json: {message: "catalouge not found"} 
    end

  end


  private 

  def catalogue_params
    params.require(:catalogue).permit(:name, :description, :gender, :category_id, :sub_category_id, catalogue_variants_attributes: [:id, :price, :catalogue_variant_color_id, :catalogue_variant_size_id, :quantity, :_destroy])
  end

end
