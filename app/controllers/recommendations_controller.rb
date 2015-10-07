class RecommendationsController < ApplicationController
  def index
    if params[:user_search] || params[:trend_or_location] || params[:category]
      search = params[:user_search] unless params[:user_search] == nil
      trend_or_location = params[:trend_or_location] unless params[:trend_or_location] == nil
      category = params[:category] unless params[:category] == nil
      @recommendations = Recommendation.search(
        search,
        trend_or_location,
        category
        ).sort_by { |rec| rec.score }.reverse
    else
      @recommendations = Recommendation.all.sort_by { |rec| rec.score }.reverse
    end
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

  def upvote
    @recommendation = Recommendation.find(params[:id])
    respond_to do |format|
      format.json do
        if current_user
          @recommendation.upvote_by current_user
          rating = @recommendation.score
          recommendation = @recommendation
          valid = true
          render json: [recommendation, rating, valid]
        else
          rating = @recommendation.score
          recommendation = @recommendation
          valid = false
          render json: [recommendation, rating, valid]
        end
      end
    end
  end

  def downvote
    @recommendation = Recommendation.find(params[:id])
    respond_to do |format|
      format.json do
        if current_user
          @recommendation.downvote_by current_user
          recommendation = @recommendation
          rating = @recommendation.score
          valid = true
          render json: [recommendation, rating, valid]
        else
          rating = @recommendation.score
          recommendation = @recommendation
          valid = false
          render json: [recommendation, rating, valid]
        end
      end
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
