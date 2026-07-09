class Api::V1::AstucesController < Api::V1::BaseController
  def index
    astuces = Astuce.active
    astuces = astuces.where(category: params[:category]) if params[:category].present?
    render json: { astuces: astuces.map { |a| astuce_json(a) } }
  end

  def show
    astuce = Astuce.find(params[:id])
    render json: { astuce: astuce_json(astuce) }
  end

  private

  def astuce_json(a)
    {
      id:          a.id,
      title:       a.title,
      description: a.description,
      images:      a.images,
      category:    a.category,
      product_id:  a.product_id,
      sort_order:  a.sort_order,
      created_at:  a.created_at
    }
  end
end
