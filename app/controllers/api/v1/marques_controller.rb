class Api::V1::MarquesController < Api::V1::BaseController
  def index
    marques = Marque.order(:name)
    render json: { marques: marques.map { |m| marque_json(m) } }
  end

  def show
    marque = Marque.find(params[:id])
    render json: { marque: marque_json(marque) }
  end

  private

  def marque_json(m)
    { id: m.id, name: m.name, description: m.description, image: m.image }
  end
end
