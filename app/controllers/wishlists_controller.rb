class WishlistsController < ApplicationController
  before_action :set_user

  def create
    existing_wishlist = @user.wishlists.find_by(catalogue_id: wishlist_params[:catalogue_id], catalogue_variant_id: wishlist_params[:catalogue_variant_id])
    if existing_wishlist
      existing_wishlist.destroy
      render json: { message: 'Wishlist deleted successfully' }, status: :ok
    else
      wishlist = @user.wishlists.build(wishlist_params)
      if wishlist.save
        render json: { message: 'Wishlist created successfully', wishlist: wishlist }, status: :created
      else
        render json: { errors: wishlist.errors.full_messages }, status: :unprocessable_entity
      end
    end
  end

  private 

  def set_user
    @user = Account.find(params[:account_id]) 
  end

  def wishlist_params
    params.require(:wishlist).permit(:catalogue_id, :catalogue_variant_id)
  end
end
