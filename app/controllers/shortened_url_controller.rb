class ShortenedUrlController < ApplicationController
  def list
    user_id = session[:user_id]
    if user_id
      @shortened_urls = ShortenedUrl.where(user_id: user_id).order(created_at: :desc)
      @domain_name = ENV["DOMAIN_NAME"]
      render :index
    else
      redirect_to login_path
    end
    
  end

  def detail
    user_id = session[:user_id]
    @shortened_url = ShortenedUrl.find_by(backhalf: params[:backhalf])
    @domain_name = ENV["DOMAIN_NAME"]
    
    if @shortened_url == nil
      Rails.logger.error "invalid backhalf: #{params[:backhalf]}"
      flash[:alert] = 'Error: invalid backhalf'
      render :detail
      return
    end
    
    if @shortened_url.user_id != user_id
      Rails.logger.error "Shortened URL does not belong to user: #{user_id}"
      flash[:alert] = 'Error: invalid backhalf'
      @shortened_url = nil
      render :detail
      return
    end
    
    @total_count = Click.where(shortened_url_id: @shortened_url.id).count
    @page_size = 10
    @number_of_pages = (@total_count.to_f / @page_size).ceil()

    # if no data, just return
    if @total_count == 0
      render :detail
      return
    end

    # if empty query param, fallback to 1
    if params[:page].nil?
      @page = 1
    # else, cast it to integer
    else
      @page = params[:page].to_i
    end

    offset = (@page - 1) * @page_size

    # incase out of bound query param
    is_page_too_small = offset < 0
    is_page_too_big = @page > @number_of_pages
    if is_page_too_small || is_page_too_big
      # obfuscate data
      @number_of_pages = 0
      @total_count = 0

      link = "<a href=\"#{request.base_url + request.path}\"> Click here to go back</a>"    
      flash.now[:alert] = "Error: invalid page number. #{link}".html_safe
      render :detail
      return
    end

    is_at_end = @page == @number_of_pages

    if !is_at_end 
      @next_url = '?page=' + (@page+1).to_s
    end

    is_at_beginning = offset == 0
    if !is_at_beginning 
      @prev_url = '?page=' + (@page-1).to_s
    end


    @clicks = Click.where(shortened_url_id: @shortened_url.id)
    .offset(offset)
    .order(created_at: :desc)
    .limit(@page_size)
    .all

    render :detail    
  end

  def index
    @shortened_url = ShortenedUrl.new
    @domain_name = ENV["DOMAIN_NAME"]
    render :create
  end

  rescue_from PG::UniqueViolation, with: :duplicate_record_error
  def create
    user_id = session[:user_id]
    @shortened_url = ShortenedUrl.new(create_params)
    @shortened_url.user_id = user_id

    if @shortened_url.save
      redirect_to root_path, notice: "URL registered successfully"
    else
      render :create
    end
  end

  def get
  end

  def redirect
    shortened_url = ShortenedUrl.find_by(backhalf: params[:backhalf])
    
    if shortened_url != nil    
      Thread.new {
        begin
          ipAPI =  IpApi.new()
          response_json = ipAPI.get_details_by_ip(request.remote_ip)
          response = JSON.parse(response_json)

          click = Click.new
          click.shortened_url_id = shortened_url.id
          click.ip_address = request.remote_ip
          click.user_agent = request.user_agent
          click.referrer = request.referer
          click.geolocation = response["geolocation"]
          click.country = response["country"]
          click.device_type = get_device_type_from_user_agent(request.user_agent)
          click.browser = get_browser_from_user_agent(request.user_agent)
          click.os = get_os_from_user_agent(request.user_agent)

          unless click.save
            Rails.logger.error "error saving click: #{click.errors.full_messages}"
          end
        rescue => e
          Rails.logger.error "An error occurred: #{e.message}"
        end
      }

      redirect_to shortened_url.original_url
    else
      render :not_found, layout: false
    end
  end

  @private
  def create_params
    params.permit(:original_url, :title, :backhalf)
  end

  @private
  def duplicate_record_error
    flash.now[:alert] = 'Backhalf is already taken. Try choosing something more unique?'
    render :create
  end

  @private
  def get_device_type_from_user_agent(user_agent)
    if user_agent =~ /iPhone/i || user_agent =~ /iPad/i || user_agent =~ /iPod/i
      return 'iOS'
    elsif user_agent =~ /Android/i
      return 'Android'
    else
      return 'Unknown'
    end
  end

  @private
  def get_browser_from_user_agent(user_agent)
    if user_agent =~ /MSIE/i || user_agent =~ /Trident/i
      return 'Internet Explorer'
    elsif user_agent =~ /Edge/i
      return 'Microsoft Edge'
    elsif user_agent =~ /Firefox/i
      return 'Firefox'
    elsif user_agent =~ /Chrome/i
      return 'Chrome'
    elsif user_agent =~ /Safari/i && user_agent =~ /Version/i
      return 'Safari'
    elsif user_agent =~ /Opera/i || user_agent =~ /OPR/i
      return 'Opera'
    else
      return 'Unknown'
    end
  end

  @private
  def get_os_from_user_agent(user_agent)
    if user_agent =~ /Windows/i
      return 'Windows'
    elsif user_agent =~ /Macintosh/i || user_agent =~ /Mac OS X/i
      return 'Mac OS X'
    elsif user_agent =~ /Linux/i
      return 'Linux'
    elsif user_agent =~ /Android/i
      return 'Android'
    elsif user_agent =~ /iPhone/i || user_agent =~ /iPad/i || user_agent =~ /iPod/i
      return 'iOS'
    else
      return 'Unknown'
    end
  end
end
