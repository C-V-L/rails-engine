class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response
  rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response
  rescue_from ArgumentError, with: :render_invaild_request

  def render_not_found_response(error)
    render json: ErrorSerializer.new(error).serialized_json, status: 404
  end

  def render_unprocessable_entity_response(error)
    render json: ErrorSerializer.new(error).serialized_json, status: 404
  end

  def render_invaild_request(error)
    render json: ErrorSerializer.new(error).serialized_json, status: 400
  end

  def price_check
    if params[:min_price].to_f < 0 || params[:max_price].to_f < 0
      raise ArgumentError
    elsif params[:min_price] && params[:max_price] && params[:min_price].to_f > params[:max_price].to_f
      raise ArgumentError
    end
  end

  def name_price_mix_check
    if params[:name] && (params[:min_price] || params[:max_price])
      raise ArgumentError
    end
  end

  # def max_price_check
  #   if params[:max_price].to_f < 0
  #     error = { message: "Max price must be greater than 0" }
  #     render json: ErrorSerializer.new(error).serialized_json, status: 400
  #   end
  # end
end
