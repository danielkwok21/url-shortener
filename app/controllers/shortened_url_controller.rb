class ShortenedUrlController < ApplicationController
  def list
    @shortened_urls = ShortenedUrl.all
    @domain_name = "https://urlshortener.danielkwok.com"
    render :index
  end

  def detail
    @shortened_url = ShortenedUrl.find_by(backhalf: params[:backhalf])
    
    if @shortened_url != nil
      @clicks = Click.where(shortened_url_id: @shortened_url.id)
      @domain_name = "https://urlshortener.danielkwok.com"
      render :detail
    else
      flash[:alert] = 'Error: invalid backhalf'
      render :detail
    end
    
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
