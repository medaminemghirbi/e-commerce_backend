class Api::V1::ContactRequestsController < Api::V1::BaseController
  def create
    contact = ContactRequest.new(contact_params)
    if contact.save
      render json: { success: true }, status: :created
    else
      render json: { error: contact.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

  private

  def contact_params
    params.require(:contact_request).permit(:first_name, :last_name, :email, :phone, :message, :product_id, :product_requested)
  end
end
