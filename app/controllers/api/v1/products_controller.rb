class Api::V1::ProductsController < Api::V1::BaseController
  def index
    scope = Product.active.includes(:category, :marque, :subcategories)
    scope = scope.where("name_fr ILIKE ? OR name_ar ILIKE ? OR name_en ILIKE ?", "%#{params[:q]}%", "%#{params[:q]}%", "%#{params[:q]}%") if params[:q].present?
    scope = scope.where(category_id: params[:category_id]) if params[:category_id].present?
    scope = scope.order(created_at: :desc)
    products = scope.page(params[:page]).per(params[:per] || 12)
    render json: { products: products.map { |p| product_json(p) }, meta: pagination_meta(products) }
  end

  def show
    product = Product.includes(:category, :marque, :subcategories).find(params[:id])
    Product.update_counters(product.id, views_count: 1)
    related = Product.active.includes(:category, :marque, :subcategories).where(category_id: product.category_id).where.not(id: product.id).limit(4)
    render json: { product: product_json(product, full: true), related: related.map { |p| product_json(p) } }
  end

  private

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
      subcategory_ids: p.subcategories.map(&:id),
      subcategories_detail: p.subcategories.map { |s| { id: s.id, name_fr: s.name_fr, icon: s.icon } },
      created_at: p.created_at
    }
    if full
      data[:description_fr] = p.description_fr
      data[:description_ar] = p.description_ar
      data[:description_en] = p.description_en
      data[:manufacture_date] = p.manufacture_date
      data[:expiration_date] = p.expiration_date
    end
    data
  end
end
