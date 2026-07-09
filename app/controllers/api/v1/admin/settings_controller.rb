class Api::V1::Admin::SettingsController < Api::V1::Admin::BaseController
  def show
    pricing = Setting.get('pricing') || { 'margin' => 20, 'promotion' => 20 }
    render json: { margin: pricing['margin'].to_i, promotion: pricing['promotion'].to_i }
  end

  def update
    margin    = params[:margin].to_i
    promotion = params[:promotion].to_i
    Setting.set('pricing', { 'margin' => margin, 'promotion' => promotion })
    render json: { margin: margin, promotion: promotion }
  end
end
