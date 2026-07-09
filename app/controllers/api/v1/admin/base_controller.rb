class Api::V1::Admin::BaseController < Api::V1::BaseController
  before_action :require_admin!
end
