class Admin::SliderImagesController < Admin::BaseController
  before_action :set_slide, only: [:edit, :update, :destroy, :toggle_active]

  def index
    @slides = SliderImage.ordered
  end

  def new
    @slide = SliderImage.new
  end

  def create
    @slide = SliderImage.new(slide_params)
    if @slide.save
      redirect_to admin_slider_images_path, notice: "Image ajoutée."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @slide.update(slide_params)
      redirect_to admin_slider_images_path, notice: "Image mise à jour."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @slide.destroy
    redirect_to admin_slider_images_path, notice: "Image supprimée."
  end

  def toggle_active
    @slide.update(active: !@slide.active)
    redirect_to admin_slider_images_path
  end

  private

  def set_slide
    @slide = SliderImage.find(params[:id])
  end

  def slide_params
    params.require(:slider_image).permit(:title, :subtitle, :image_url, :link_url, :link_label, :sort_order, :active)
  end
end
