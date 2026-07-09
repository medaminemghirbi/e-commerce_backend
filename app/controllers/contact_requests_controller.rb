class ContactRequestsController < ApplicationController
  def new
    @contact = ContactRequest.new
    @products = Product.active.order(:name_fr)
  end

  def create
    @contact = ContactRequest.new(contact_params)
    if @contact.save
      redirect_to root_path, notice: "Message envoyé ! Nous vous contacterons bientôt."
    else
      @products = Product.active.order(:name_fr)
      render :new, status: :unprocessable_entity
    end
  end

  private

  def contact_params
    params.require(:contact_request).permit(:first_name, :last_name, :email, :phone, :message, :product_id)
  end
end
