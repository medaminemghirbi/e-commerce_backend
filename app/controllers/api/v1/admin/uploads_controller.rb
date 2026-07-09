require 'net/http'

class Api::V1::Admin::UploadsController < Api::V1::Admin::BaseController
  def create
    file = params[:file]
    return render json: { error: 'No file provided' }, status: :bad_request unless file

    ext      = File.extname(file.original_filename).downcase
    filename = "#{SecureRandom.hex(12)}#{ext}"
    bucket   = ENV.fetch('SUPABASE_BUCKET')

    uri  = URI("#{ENV.fetch('SUPABASE_URL')}/storage/v1/object/#{bucket}/#{filename}")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    req = Net::HTTP::Post.new(uri)
    req['Authorization'] = "Bearer #{ENV.fetch('SUPABASE_SERVICE_KEY')}"
    req['Content-Type']  = file.content_type
    req.body = file.read

    response = http.request(req)

    if response.is_a?(Net::HTTPSuccess)
      public_url = "#{ENV.fetch('SUPABASE_URL')}/storage/v1/object/public/#{bucket}/#{filename}"
      render json: { url: public_url }, status: :created
    else
      render json: { error: 'Upload to Supabase failed', details: response.body }, status: :unprocessable_entity
    end
  end
end
