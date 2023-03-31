class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response
  rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response


  def render_not_found_response(error)
    render json: ErrorSerializer.new(error).serialized_json, status: 404
  end

  def render_unprocessable_entity_response(error)
    render json: ErrorSerializer.new(error).serialized_json, status: 422
  end

  def no_records_found
    error = { message: "No records found" }
    render json: ErrorSerializer.new(error).serialized_json, status: 404
  end

  def min_price_check
    if params[:min_price].to_f < 0
      error = { message: "Min price must be greater than 0" }
      render json: ErrorSerializer.new(error).serialized_json, status: 400
    end
  end

  def max_price_check
    if params[:max_price].to_f < 0
      error = { message: "Max price must be greater than 0" }
      render json: ErrorSerializer.new(error).serialized_json, status: 400
    end
  end
end
