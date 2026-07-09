class Api::V1::CategoriesController < Api::V1::BaseController
  def index
    categories = Category.order(:name_fr)
    render json: { categories: categories.map { |c| category_json(c) } }
  end

  def show
    category = Category.find(params[:id])
    render json: { category: category_json(category) }
  end

  private

  def category_json(c)
    { id: c.id, name_fr: c.name_fr, name_ar: c.name_ar, name_en: c.name_en, icon: c.icon, description: c.description }
  end
end
