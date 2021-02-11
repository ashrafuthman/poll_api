class AnswersController < ApplicationController
  before_action :set_answer, only: [:show, :update]

  # GET /answers
  def index
    @answers = Answer.all

    render json: @answers
  end

  # GET /answers/1
  def show
    render json: @answer
  end

  # POST /answers
  def create
    answer = Answer.where({
      user_id: answer_params[:user_id],
      option_id: answer_params[:option_id],
      poll_id: answer_params[:poll_id]
    })
    return if answer.count > 0
  
    @answer = Answer.new(answer_params)
    if @answer.save
      render json: @answer, status: :created, location: @answer
    else
      render json: @answer.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /answers/1
  def update
    if @answer.update(answer_params)
      render json: @answer
    else
      render json: @answer.errors, status: :unprocessable_entity
    end
  end

  # DELETE /answers/1
  def destroy
    @answer.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    # def set_answer
    #   byebug
    #   payload = JSON.parse(params[:id]).symbolize_keys
    #   params[:id] = ''
    #   user = User.where({name: payload[:voter]}).first
    #   answer = user && Answer.where({
    #     user_id: user.id,
    #     option_id: payload[:option]["option_id"],
    #     poll_id: payload[:option]["poll_id"]
    #   }).first
    #   if user && answer
    #     params[:id] = answer.id if answer.user_id == user.id
    #   end
    #   @answer = Answer.find(params[:id])
    # end

    # Only allow a list of trusted parameters through.
    def answer_params
      user = User.where({name: params[:voter]}).first
      user = !user ? User.create({name: params[:voter]}) : user

      params[:answer][:poll_id] = params[:option][:poll_id]
      params[:answer][:option_id] = params[:option][:option_id]
      params[:answer][:user_id] = user.id

      params.require(:answer).permit(:user_id, :poll_id, :option_id)
    end
end
