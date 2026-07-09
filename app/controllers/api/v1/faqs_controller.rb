class Api::V1::FaqsController < Api::V1::BaseController
  def index
    faqs = Faq.active.group_by(&:category)
    grouped = faqs.transform_values { |items| items.map { |f| faq_json(f) } }
    render json: { faqs: grouped }
  end

  private

  def faq_json(f)
    { id: f.id, question: f.question, answer: f.answer, sort_order: f.sort_order }
  end
end
