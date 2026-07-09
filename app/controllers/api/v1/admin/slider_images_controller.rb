class Api::V1::Admin::SliderImagesController < Api::V1::Admin::BaseController
  before_action :set_slide, only: [:show, :update, :destroy, :toggle_active]

  def index
    slides = SliderImage.ordered
    render json: { slider_images: slides.map { |s| slide_json(s) } }
  end

  def show
    render json: { slider_image: slide_json(@slide) }
  end

  def create
    slide = SliderImage.new(slide_params)
    if slide.save
      render json: { slider_image: slide_json(slide) }, status: :created
    else
      render json: { error: slide.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

  def update
    if @slide.update(slide_params)
      render json: { slider_image: slide_json(@slide) }
    else
      render json: { error: @slide.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

  def destroy
    @slide.destroy
    render json: { success: true }
  end

  def toggle_active
    @slide.update!(active: !@slide.active)
    render json: { slider_image: slide_json(@slide) }
  end

  private

  def set_slide
    @slide = SliderImage.find(params[:id])
  end

  def slide_params
    params.require(:slider_image).permit(:image_url, :title, :subtitle, :sort_order, :active)
  end

  def slide_json(s)
    { id: s.id, image_url: s.image_url, title: s.title, subtitle: s.subtitle, sort_order: s.sort_order, active: s.active }
  end
end
