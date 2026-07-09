class Api::V1::SliderImagesController < Api::V1::BaseController
  def index
    slides = SliderImage.active.ordered
    render json: { slider_images: slides.map { |s| slide_json(s) } }
  end

  private

  def slide_json(s)
    { id: s.id, image_url: s.image_url, title: s.title, subtitle: s.subtitle, sort_order: s.sort_order, active: s.active }
  end
end
