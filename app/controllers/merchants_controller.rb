class MerchantsController < ApplicationController
  def show
  end

  def create
    auth_hash = request.env["omniauth.auth"]

    merchant = Merchant.find_by(uid: auth_hash[:uid], provider: "github")
    if merchant
      # merchant was found in the database
      flash[:success] = "Logged in as returning merchant #{merchant.name}"
    else
      # merchant doesn't match anything in the DB
      # Attempt to create a new merchant
      merchant = Merchant.build_from_github(auth_hash)

      if merchant.save
        flash[:success] = "Logged in as new merchant #{merchant.name}"
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

  # MATCH THIS TO MARGARET'S
  def login
    username = params[:merchant][:username]

    merchant = Merchant.find_by(username: username)
    if merchant.nil?
      flash_msg = "Welcome to Incredibly!"
    else
      flash_msg = "Welcome back #{username}!"
    end

    merchant ||= Merchant.create(username: username)

    session[:merchant_id] = merchant.id
    flash[:success] = flash_msg
    redirect_to root_path
  end

  # ^^^^^^^^^^^^^^^^^^^^^^^^^^^
  def logout
    merchant = Merchant.find_by(id: session[:merchant_id])
    session[:merchant_id] = nil
    flash[:notice] = "Successfully logged out #{merchant.username}"
    redirect_to root_path
  end
end
