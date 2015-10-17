class SearchesController < ApplicationController
  def destroy
    @search = Search.find(params[:id])
    if current_user && @search.user_id == current_user.id
      @search.destroy
      flash[:success] = 'Search deleted'
      redirect_to user_path(current_user)
    else
      flash[:alert] = "You can only delete your own searches"
    end
  end

  def destroy_all
    @user = User.find(params[:user_id])
    if current_user && @user.id == current_user.id
      @searches = Search.where(user_id: @user.id)
      @searches.destroy_all
      flash[:success] = 'All searches deleted'
      redirect_to user_path(current_user)
    else
      flash[:alert] = "You can only delete your own searches"
    end
  end
end
