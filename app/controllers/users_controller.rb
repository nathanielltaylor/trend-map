class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @searches = @user.searches.reverse
    @recommendations = @user.recommendations.sort_by { |rec| rec.score }.reverse
  end
end
