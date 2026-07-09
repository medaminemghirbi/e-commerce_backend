class ProductsController < ApplicationController
  def index
    @products = Product.active.includes(:category)
    @products = @products.where(category_id: params[:category]) if params[:category].present?
    @products = @products.where("name_fr ILIKE ? OR name_ar ILIKE ? OR name_en ILIKE ?",
                                "%#{params[:q]}%", "%#{params[:q]}%", "%#{params[:q]}%") if params[:q].present?
    @products = @products.order(created_at: :desc).page(params[:page]).per(12)
    @categories = Category.all
  end

  def show
    @product = Product.find(params[:id])
    @related = Product.active.where(category: @product.category).where.not(id: @product.id).limit(4)
  end
end
