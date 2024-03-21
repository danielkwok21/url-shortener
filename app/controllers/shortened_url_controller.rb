class ShortenedUrlController < ApplicationController
  def list
    render :index
  end

  def detail
    render :detail
  end

  def index
    @shortened_url = ShortenedUrl.new
    render :create
  end

  rescue_from PG::UniqueViolation, with: :duplicate_record_error
  def create
    @shortened_url = ShortenedUrl.new(create_params)
    if @shortened_url.save
      redirect_to root_path, notice: "URL registered successfully"
    else
      render :create
    end
  end

  def get
  end


  @private
  def create_params
    params.permit(:original_url, :title, :backhalf)
  end

  def duplicate_record_error
    # TODO better error handling
    flash.now[:alert] = 'Error: This record violates a unique constraint.'
    render :create
  end
end
