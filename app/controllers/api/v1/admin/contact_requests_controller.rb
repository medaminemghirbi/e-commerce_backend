class Api::V1::Admin::ContactRequestsController < Api::V1::Admin::BaseController
  before_action :set_contact, only: [:show, :update, :destroy]

  def index
    contacts = ContactRequest.order(created_at: :desc).page(params[:page]).per(20)
    render json: { contact_requests: contacts.map { |c| contact_json(c) }, meta: pagination_meta(contacts) }
  end

  def show
    render json: { contact_request: contact_json(@contact) }
  end

  def update
    @contact.update(params.permit(:status))
    render json: { contact_request: contact_json(@contact) }
  end

  def destroy
    @contact.destroy
    render json: { success: true }
  end

  private

  def set_contact
    @contact = ContactRequest.find(params[:id])
  end

  def contact_json(c)
    { id: c.id, first_name: c.first_name, last_name: c.last_name, email: c.email, phone: c.phone, message: c.message, product_requested: c.product_requested, status: c.status, created_at: c.created_at }
  end
end
