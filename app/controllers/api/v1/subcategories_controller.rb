class Api::V1::SubcategoriesController < Api::V1::BaseController
  def index
    scope = Subcategory.order(:name_fr)
    scope = scope.where(category_id: params[:category_id]) if params[:category_id].present?
    render json: { subcategories: scope.map { |s| sub_json(s) } }
  end

  def show
    render json: { subcategory: sub_json(Subcategory.find(params[:id])) }
  end

  private

  def sub_json(s)
    { id: s.id, category_id: s.category_id, name_fr: s.name_fr, name_ar: s.name_ar, name_en: s.name_en, icon: s.icon }
  end
end
