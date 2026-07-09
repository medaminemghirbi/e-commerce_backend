class Api::V1::Admin::FaqsController < Api::V1::Admin::BaseController
  before_action :set_faq, only: [:show, :update, :destroy]

  def index
    faqs = Faq.order(:category, :sort_order, :created_at)
    render json: { faqs: faqs.map { |f| faq_json(f) } }
  end

  def show
    render json: { faq: faq_json(@faq) }
  end

  def create
    faq = Faq.new(faq_params)
    if faq.save
      render json: { faq: faq_json(faq) }, status: :created
    else
      render json: { error: faq.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

  def update
    if @faq.update(faq_params)
      render json: { faq: faq_json(@faq) }
    else
      render json: { error: @faq.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

  def destroy
    @faq.destroy
    render json: { success: true }
  end

  private

  def set_faq
    @faq = Faq.find(params[:id])
  end

  def faq_params
    params.require(:faq).permit(:question, :answer, :category, :sort_order, :active)
  end

  def faq_json(f)
    {
      id:         f.id,
      question:   f.question,
      answer:     f.answer,
      category:   f.category,
      sort_order: f.sort_order,
      active:     f.active,
      created_at: f.created_at
    }
  end
end
