class CoffeeController < ApplicationController
  skip_before_action :login_required

  def index
    if request.method == "BREW" || request.headers["x-api-client-type"] == "application/coffee-pot-command"
      render json: "I'm a teapot", status: 418
    end
  end
end
