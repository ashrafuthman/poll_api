class PollsController < ApplicationController
  before_action :set_poll, only: [:show, :update, :destroy]

  # GET /polls
  def index
    @polls = Poll.all
    polls_result = @polls.map do |poll|
      options = Option.where({poll_id: poll.id})
      return unless options

      total_answers = 0
      voters = []
      options_result = options.map do |option|
        answers = Answer.where({option_id: option.id, poll_id: poll.id})
        answered_users = answers.map { |answer| User.find(answer.user_id).name }
        total_answers = total_answers + answers.count
        answered_users.map { |user| voters << user } if answered_users.length > 0
        {
          poll_id: poll.id,
          option_id: option.id,
          option: option.body,
          description: option.description,
          totalVotes: answers.count,
          voters: answered_users 
        }
      end

      final_result = {
        question_id: poll.id,
        question: poll.name,
        options: options_result,
        totalVotes: total_answers,
        voters: voters
      }
    end

    render json: polls_result
  end

  # GET /polls/1
  def show
    return unless @poll

    options = Option.where({poll_id: @poll.id})
    return unless options

    options_result = options.map do |option|
      answers = Answer.where({option_id: option.id, poll_id: @poll.id})
      answered_users = answers.map { |answer| User.find(answer.user_id).name }
      {
        option: option.body,
        description: option.description,
        totalVotes: answers.count,
        voters: answered_users 
      }
    end
    final_result = {
      question: @poll.name,
      options: options_result
    }
    render json: final_result
  end

  # POST /polls
  def create
    @poll = Poll.create({name: params[:question]})
    if @poll.save
      params[:options].each { |option| Option.create({poll_id: @poll&.id, body: option[:choice]&.split(',')&.first, description: "#{option[:choice]&.split(',')[1]} - #{option[:choice]&.split(',')[2]}" })}
      render json: @poll, status: :created, location: @poll
    else
      render json: @poll.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /polls/1
  def update
    if @poll.update(poll_params)
      render json: @poll
    else
      render json: @poll.errors, status: :unprocessable_entity
    end
  end

  # DELETE /polls/1
  def destroy
    @poll.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_poll
      @poll = Poll.find(params[:id])
    end
end
