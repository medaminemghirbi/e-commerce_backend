class Admin::SubcategoriesController < Admin::BaseController
  before_action :set_subcategory, only: [:edit, :update, :destroy]

  def index
    @subcategories = Subcategory.includes(:category).order(:name_fr)
  end

  def new
    @subcategory = Subcategory.new
    @categories = Category.all.order(:name_fr)
  end

  def create
    @subcategory = Subcategory.new(subcategory_params)
    if @subcategory.save
      redirect_to admin_subcategories_path, notice: "Sous-catégorie créée."
    else
      @categories = Category.all.order(:name_fr)
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @categories = Category.all.order(:name_fr)
  end

  def update
    if @subcategory.update(subcategory_params)
      redirect_to admin_subcategories_path, notice: "Sous-catégorie mise à jour."
    else
      @categories = Category.all.order(:name_fr)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @subcategory.destroy
    redirect_to admin_subcategories_path, notice: "Sous-catégorie supprimée."
  end

  private

  def set_subcategory
    @subcategory = Subcategory.find(params[:id])
  end

  def subcategory_params
    params.require(:subcategory).permit(:category_id, :name_fr, :name_ar, :name_en, :description, :icon)
  end
end
