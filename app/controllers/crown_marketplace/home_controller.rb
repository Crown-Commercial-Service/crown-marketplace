class CrownMarketplace::HomeController < CrownMarketplace::FrameworkController
  include SharedPagesConcern

  def index
    redirect_to crown_marketplace_allow_list_index_path
  end
end
