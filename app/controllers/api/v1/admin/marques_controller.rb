class Api::V1::Admin::MarquesController < Api::V1::Admin::BaseController
  before_action :set_marque, only: [:show, :update, :destroy]

  def index
    marques = Marque.order(:name)
    render json: { marques: marques.map { |m| marque_json(m) } }
  end

  def show
    render json: { marque: marque_json(@marque) }
  end

  def create
    marque = Marque.new(marque_params)
    if marque.save
      render json: { marque: marque_json(marque) }, status: :created
    else
      render json: { error: marque.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

  def update
    if @marque.update(marque_params)
      render json: { marque: marque_json(@marque) }
    else
      render json: { error: @marque.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

  def destroy
    @marque.destroy
    render json: { success: true }
  end

  private

  def set_marque
    @marque = Marque.find(params[:id])
  end

  def marque_params
    params.require(:marque).permit(:name, :description, :image)
  end

  def marque_json(m)
    { id: m.id, name: m.name, description: m.description, image: m.image, created_at: m.created_at }
  end
end
