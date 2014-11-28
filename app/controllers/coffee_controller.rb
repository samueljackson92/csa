class CoffeeController < ApplicationController
  skip_before_action :login_required
  before_action :unforce_ssl

  def index
    if request.method == "BREW" || request.headers["x-api-client-type"] == "application/coffee-pot-command"
      render text: "I'm a teapot", status: 418
    end
  end
end
