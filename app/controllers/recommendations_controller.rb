class RecommendationsController < ApplicationController
  def index
    @recommendations = Recommendation.all
  end

  def show
    @recommendation = Recommendation.find(params[:id])
  end

  def edit
    @recommendation = Recommendation.find(params[:id])
  end

  def update
    @recommendation = Recommendation.find(params[:id])
    if @recommendation.user_id == current_user.id
      if @recommendation.update_attributes(recommendation_params)
        flash[:success] = 'Recommendation edited successfully'
        redirect_to recommendation_path(@recommendation)
      else
        flash[:alert] = 'Something went wrong'
        render :edit
      end
    else
      flash[:error] = "You can only edit your own recommendations"
    end
  end

  def new
    @recommendation = Recommendation.new
  end

  def create
    @recommendation = Recommendation.new(recommendation_params)
    @recommendation.user_id = current_user.id
    if @recommendation.save
      flash[:success] = 'Recommendation successfully created!'
      redirect_to recommendation_path(@recommendation)
    else
      flash[:alert] = @recommendation.errors.full_messages.join(". ")
      render :new
    end
  end

  def destroy
    @recommendation = Recommendation.find(params[:id])
    if @recommendation.user_id == current_user.id
      @recommendation.destroy
      flash[:success] = 'Recommendation deleted'
      redirect_to recommendations_path
    else
      flash[:alert] = "You can only delete your own recommendations"
    end
  end

  private

  def recommendation_params
    params.require(:recommendation).permit(
      :query,
      :trend_or_location,
      :category,
      :description
    )
  end

end
