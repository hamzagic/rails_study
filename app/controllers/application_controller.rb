class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  private

  def record_not_found(exception)
    render json: {
      error: "Record not found",
      id: params[:id],
      message: "The requested item does not exist."
    }, status: :not_found
  end
end
