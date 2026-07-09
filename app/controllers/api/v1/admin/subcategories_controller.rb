class Api::V1::Admin::SubcategoriesController < Api::V1::Admin::BaseController
  before_action :set_sub, only: [:show, :update, :destroy]

  def index
    scope = Subcategory.includes(:category).order(:name_fr)
    scope = scope.where(category_id: params[:category_id]) if params[:category_id].present?
    render json: { subcategories: scope.map { |s| sub_json(s) } }
  end

  def show
    render json: { subcategory: sub_json(@sub) }
  end

  def create
    sub = Subcategory.new(sub_params)
    if sub.save
      render json: { subcategory: sub_json(sub) }, status: :created
    else
      render json: { error: sub.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

  def update
    if @sub.update(sub_params)
      render json: { subcategory: sub_json(@sub) }
    else
      render json: { error: @sub.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

  def destroy
    @sub.destroy
    render json: { success: true }
  end

  private

  def set_sub
    @sub = Subcategory.find(params[:id])
  end

  def sub_params
    params.require(:subcategory).permit(:category_id, :name_fr, :name_ar, :name_en, :icon, :description)
  end

  def sub_json(s)
    { id: s.id, category_id: s.category_id, name_fr: s.name_fr, name_ar: s.name_ar, name_en: s.name_en, icon: s.icon }
  end
end
