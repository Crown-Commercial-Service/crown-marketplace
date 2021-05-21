class CrownMarketplace::AllowListController < CrownMarketplace::FrameworkController
  before_action :set_allowed_email_domain
  before_action :set_allow_list, :set_paginated_allow_list, only: %i[index search_allow_list]

  def index; end

  def new; end

  def create
    if @allowed_email_domain.save
      redirect_to crown_marketplace_allow_list_index_path(email_domain_added: @allowed_email_domain.email_domain)
    else
      render :new
    end
  end

  def delete
    render layout: 'error'
  end

  def destroy
    @allowed_email_domain.remove_email_domain
    redirect_to crown_marketplace_allow_list_index_path(email_domain_removed: @allowed_email_domain.email_domain)
  end

  def search_allow_list
    respond_to do |format|
      format.js
    end
  end

  private

  def set_allowed_email_domain
    @allowed_email_domain = AllowedEmailDomain.new(allowed_email_domain_params)
  end

  def set_allow_list
    @allow_list = @allowed_email_domain.search_allow_list
  end

  def set_paginated_allow_list
    @paginated_allow_list = Kaminari.paginate_array(@allow_list).page(params[:page]).per(200)
  end

  def allowed_email_domain_params
    params.require(:allowed_email_domain).permit(:email_domain) if params[:allowed_email_domain]
  end
end
