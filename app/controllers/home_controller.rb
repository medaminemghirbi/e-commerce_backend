class HomeController < ApplicationController
  def index
    @slides    = SliderImage.active
    @categories = Category
    @featured  = Product.active.order(created_at: :desc)
  end
end
