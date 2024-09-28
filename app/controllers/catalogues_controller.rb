class CataloguesController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]

def index
  sub_category_name = params[:sub_category_name]
  gender = params[:gender]

  catalogues = Catalogue.all

  if sub_category_name.present?
    sub_category = SubCategory.find_by(name: sub_category_name)
    catalogues = sub_category.present? ? sub_category.catalogues : catalogues
  end

  if gender.present?
    catalogues = catalogues.filter_by_gender(gender)
  end

  if catalogues.blank?
    render json: { error: "No catalogues found" }, status: :not_found
  else
    render json: catalogues, each_serializer: CatalogueSerializer
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
