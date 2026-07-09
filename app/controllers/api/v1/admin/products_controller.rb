class Api::V1::Admin::ProductsController < Api::V1::Admin::BaseController
  before_action :set_product, only: [:show, :update, :destroy]

  def index
    scope = Product.includes(:category, :marque)
    scope = scope.where("name_fr ILIKE ? OR name_ar ILIKE ?", "%#{params[:q]}%", "%#{params[:q]}%") if params[:q].present?
    scope = scope.order(created_at: :desc)
    products = scope.page(params[:page]).per(params[:per] || 20)
    render json: { products: products.map { |p| product_json(p) }, meta: pagination_meta(products) }
  end

  def show
    render json: { product: product_json(@product, full: true) }
  end

  def create
    product = Product.new(product_params)
    if product.save
      save_subcategories(product, params[:product][:subcategory_ids])
      render json: { product: product_json(product, full: true) }, status: :created
    else
      render json: { error: product.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

  def update
    if @product.update(product_params)
      save_subcategories(@product, params[:product][:subcategory_ids]) if params[:product][:subcategory_ids]
      render json: { product: product_json(@product, full: true) }
    else
      render json: { error: @product.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

  def destroy
    @product.destroy
    render json: { success: true }
  end

  def destroy_all
    count = Product.count
    ::ProductSubcategory.delete_all
    Product.delete_all
    render json: { success: true, deleted: count }
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(
      :name_fr, :name_ar, :name_en,
      :description_fr, :description_ar, :description_en,
      :price, :stock_quantity,
      :category_id, :marque_id, :status, :has_promotion, :promotion_discount,
      :manufacture_date, :expiration_date,
      images: []
    )
  end

  def save_subcategories(product, ids)
    return if ids.nil?
    ::ProductSubcategory.where(product_id: product.id).delete_all
    ids = Array(ids).reject(&:blank?)
    ::ProductSubcategory.insert_all(ids.map { |sid| { product_id: product.id, subcategory_id: sid.to_i } }) if ids.any?
  end

  def product_json(p, full: false)
    data = {
      id: p.id,
      name_fr: p.name_fr, name_ar: p.name_ar, name_en: p.name_en,
      price: p.price.to_f,
      stock_quantity: p.stock_quantity,
      images: p.images || [],
      status: p.status,
      has_promotion: p.has_promotion,
      promotion_discount: p.promotion_discount.to_f,
      category_id: p.category_id,
      category: p.category ? { id: p.category.id, name_fr: p.category.name_fr, icon: p.category.icon } : nil,
      marque_id: p.marque_id,
      marque: p.marque ? { id: p.marque.id, name: p.marque.name, image: p.marque.image } : nil,
      created_at: p.created_at
    }
    if full
      links = ::ProductSubcategory.includes(:subcategory).where(product_id: p.id)
      data[:description_fr] = p.description_fr
      data[:description_ar] = p.description_ar
      data[:description_en] = p.description_en
      data[:manufacture_date] = p.manufacture_date
      data[:expiration_date] = p.expiration_date
      data[:subcategory_ids] = links.map(&:subcategory_id)
      data[:subcategories_detail] = links.map { |l|
        begin
          { id: l.subcategory.id, name_fr: l.subcategory.name_fr, icon: l.subcategory.icon }
        rescue
          nil
        end
      }.compact
    end
    data
  end
end
