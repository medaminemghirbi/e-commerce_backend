class Api::V1::HomeController < Api::V1::BaseController
  def index
    slides     = SliderImage.active.ordered
    categories = Category.order(:name_fr)
    featured   = Product.active.order(created_at: :desc)

    render json: {
      slider_images:     slides.map { |s| slide_json(s) },
      categories:        categories.map { |c| category_json(c) },
      featured_products: featured.map { |p| product_json(p) }
    }
  end

  private

  def slide_json(s)
    { id: s.id, image_url: s.image_url, title: s.title, subtitle: s.subtitle, sort_order: s.sort_order }
  end

  def category_json(c)
    { id: c.id, name_fr: c.name_fr, name_ar: c.name_ar, name_en: c.name_en, icon: c.icon, description: c.description }
  end

  def product_json(p)
    {
      id: p.id, name_fr: p.name_fr, name_ar: p.name_ar, name_en: p.name_en,
      price: p.price.to_f,
      has_promotion: p.has_promotion,
      promotion_discount: p.promotion_discount.to_f,
      images: p.images,
      stock_quantity: p.stock_quantity,
      category_id: p.category_id
    }
  end
end
