class Admin::ProductsController < Admin::BaseController
  before_action :set_product, only: [:show, :edit, :update, :destroy]

  def index
    @products = Product.includes(:category).order(created_at: :desc).page(params[:page]).per(20)
  end

  def new
    @product    = Product.new
    @categories = Category.all
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to admin_products_path, notice: "Produit créé."
    else
      @categories = Category.all
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @categories = Category.all
  end

  def update
    if @product.update(product_params)
      redirect_to admin_products_path, notice: "Produit mis à jour."
    else
      @categories = Category.all
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @product.destroy
    redirect_to admin_products_path, notice: "Produit supprimé."
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(
      :name_fr, :name_ar, :name_en,
      :description_fr, :description_ar, :description_en,
      :category_id, :purchase_price, :selling_price,
      :stock_quantity, :manufacture_date, :expiration_date,
      :has_promotion, :promotion_discount, :status,
      images: []
    )
  end
end
