class Api::V1::Admin::AstucesController < Api::V1::Admin::BaseController
  before_action :set_astuce, only: [:show, :update, :destroy]

  def index
    astuces = Astuce.includes(:product).order(:sort_order, :created_at)
    render json: { astuces: astuces.map { |a| astuce_json(a) } }
  end

  def show
    render json: { astuce: astuce_json(@astuce) }
  end

  def create
    astuce = Astuce.new(astuce_params)
    if astuce.save
      render json: { astuce: astuce_json(astuce) }, status: :created
    else
      render json: { error: astuce.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

  def update
    if @astuce.update(astuce_params)
      render json: { astuce: astuce_json(@astuce) }
    else
      render json: { error: @astuce.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

  def destroy
    @astuce.destroy
    render json: { success: true }
  end

  private

  def set_astuce
    @astuce = Astuce.find(params[:id])
  end

  def astuce_params
    params.require(:astuce).permit(:title, :description, :category, :product_id, :active, :sort_order, images: [])
  end

  def astuce_json(a)
    {
      id:           a.id,
      title:        a.title,
      description:  a.description,
      images:       a.images,
      category:     a.category,
      product_id:   a.product_id,
      product_name: a.product&.name_fr,
      active:       a.active,
      sort_order:   a.sort_order,
      created_at:   a.created_at
    }
  end
end
