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
      # merchant was found in the database
      flash[:success] = "Logged in as returning merchant #{merchant.username}"
    else
      # merchant doesn't match anything in the DB
      # Attempt to create a new merchant
      merchant = Merchant.build_from_github(auth_hash)

      if merchant.save
        flash[:success] = "Logged in as new merchant #{merchant.username}"
      else
        # Couldn't save the merchant for some reason. If we
        # hit this it probably means there's a bug with the
        # way we've configured GitHub. Our strategy will
        # be to display error messages to make future
        # debugging easier.
        flash[:error] = "Could not create new merchant account: #{merchant.errors.messages}"
        return redirect_to root_path
      end
    end
    # If we get here, we have a valid merchant instance
    session[:merchant_id] = merchant.id
    return redirect_to root_path
  end

  def login_form
    @merchant = Merchant.new # do we need this line? -Elle
  end

  # MATCHED THIS TO MARGARET'S
  # def login
  #   username = merchant_params[:username]

  #   if username and merchant = Merchant.find_by(username: username)
  #     session[:merchant_id] = merchant.id
  #     flash[:status] = :success
  #     flash[:result_text] = "Successfully logged in as existing merchant #{merchant.username}"
  #   else
  #     merchant = Merchant.new(username: username)
  #     if merchant.save
  #       session[:merchant_id] = merchant.id
  #       flash[:status] = :success
  #       flash[:result_text] = "Successfully created new merchant #{merchant.username} with ID #{merchant.id}"
  #     else
  #       flash.now[:status] = :failure
  #       flash.now[:result_text] = "Could not log in"
  #       flash.now[:messages] = merchant.errors.messages
  #       render "login_form", status: :bad_request
  #       return
  #     end
  #   end

  #   # alternative syntax for flash message:
  #   # flash[:success] = flash_msg
  #   # For testing, does the status return success?

  #   redirect_to root_path
  # end

  # ^^^^^^^^^^^^^^^^^^^^^^^^^^^
  def logout
    merchant = Merchant.find_by(id: session[:merchant_id])
    # raise
    # merchant_username = merchant.username
    session[:merchant_id] = nil
    flash[:success] = "Successfully logged out." #{merchant_username}"
    redirect_to root_path
  end

  def current
    if @login_merchant.nil?
      flash[:error] = "You must be logged to view this page"
      redirect_to root_path
    end
  end
end

private

def find_merchant
  @merchant = Merchant.find_by_id(merchant_params[:id])
end

def merchant_params
  return params.require(:merchant).permit(:username, :email, :uid, :provider)
end
