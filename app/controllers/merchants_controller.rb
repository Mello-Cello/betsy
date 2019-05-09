class MerchantsController < ApplicationController
  before_action :find_logged_in_merchant, only: [:current]

  def index
    @merchants = Merchant.all
  end

  def show
    @merchant = Merchant.find_by(id: params[:id])

    if @merchant.nil?
      flash[:error] = "Unknown merchant"
      redirect_to merchants_path
    end
  end

  def create
    auth_hash = request.env["omniauth.auth"]
    merchant = Merchant.find_by(uid: auth_hash[:uid], provider: "github")
    if merchant
      flash[:success] = "Logged in as returning merchant #{merchant.username}"
    else
      merchant = Merchant.build_from_github(auth_hash)

      if merchant.save
        flash[:success] = "Logged in as new merchant #{merchant.username}"
      else
        flash[:error] = "Could not create new merchant account: #{merchant.errors.messages}"
        return redirect_to root_path
      end
    end
    session[:merchant_id] = merchant.id
    return redirect_to root_path
  end

  def logout
    session[:merchant_id] = nil
    flash[:success] = "Successfully logged out."
    redirect_to root_path
  end

  def current
    if @login_merchant.nil?
      flash[:error] = "You must be logged to view this page"
      redirect_to root_path
    end
  end
end
