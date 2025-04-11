class CrownMarketplace::AllowListController < CrownMarketplace::FrameworkController
  before_action :authorize_user, :set_allowed_email_domain
  before_action :set_allow_list, :set_paginated_allow_list, only: %i[index search_allow_list]

  def index; end

  def new; end

  def create
    if @allowed_email_domain.save
      flash[:email_domain_added] = @allowed_email_domain.email_domain

      redirect_to crown_marketplace_allow_list_index_path
    else
      render :new
    end
  end

  def delete
    render layout: 'error'
  end

  def destroy
    @allowed_email_domain.remove_email_domain

    flash[:email_domain_removed] = @allowed_email_domain.email_domain

    redirect_to crown_marketplace_allow_list_index_path
  end

  def search_allow_list
    render json: {
      html: render_to_string(
        partial: 'allow_list_table',
        locals: { paginated_allow_list: @paginated_allow_list, email_domain_added: params[:email_domain_added] },
        formats: [:html]
      )
    }
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

  def authorize_user
    if ['new', 'create', 'delete', 'destroy'].include? action_name
      authorize! :manage, AllowedEmailDomain
    else
      authorize! :read, AllowedEmailDomain
    end
  end
end
