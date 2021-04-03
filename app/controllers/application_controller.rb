class ApplicationController < ActionController::API
  include ActionController::Helpers 

  rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response

  def render_unprocessable_entity_response(exception)
    render json: exception.record.errors, status: 404
  end

  def render_not_found_response(exception)
    render json: { error: exception.message }, status: :not_found
  end

  def page 
    params[:page].to_i < 1 ? @page = 1 : @page = params[:page].to_i  
  end
  
  def per_page 
    params[:per_page].to_i < 1 ? @per_page = 20 : @per_page = params[:per_page].to_i
  end
  
  def api_page_info(serializer, object_type)
    if params[:page] && !params[:per_page]
      @serial = serializer.new(object_type.limit(20).offset(20 * (page - 1)))
    elsif !params[:page] && params[:per_page]
      @serial = serializer.new(object_type.limit(per_page))
    elsif params[:page] && params[:per_page]
      @serial = serializer.new(page_display(per_page, page))
    else 
      @serial = serializer.new(object_type.limit(20))
    end
  end   



  helper_method :page, :per_page
end
