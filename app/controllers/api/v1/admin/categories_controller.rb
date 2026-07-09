class Api::V1::Admin::CategoriesController < Api::V1::Admin::BaseController
  before_action :set_category, only: [:show, :update, :destroy]

  def index
    categories = Category.order(:name_fr)
    render json: { categories: categories.map { |c| cat_json(c) } }
  end

  def show
    render json: { category: cat_json(@category) }
  end

  def create
    cat = Category.new(cat_params)
    if cat.save
      render json: { category: cat_json(cat) }, status: :created
    else
      render json: { error: cat.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

  def update
    if @category.update(cat_params)
      render json: { category: cat_json(@category) }
    else
      render json: { error: @category.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

  def destroy
    @category.destroy
    render json: { success: true }
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end

  def cat_params
    params.require(:category).permit(:name_fr, :name_ar, :name_en, :icon, :description)
  end

  def cat_json(c)
    { id: c.id, name_fr: c.name_fr, name_ar: c.name_ar, name_en: c.name_en, icon: c.icon, description: c.description, products_count: c.products.count }
  end
end
