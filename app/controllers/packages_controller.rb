class PackagesController < ApplicationController
  def index
    @packages = Package.includes(:latest_version)
      .order(:name)
      .page(params[:page])
  end

  def show
    @package = Package.find_by_name params[:id]
  end
end
