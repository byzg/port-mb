class FeedbacksController < ApplicationController
  def new
    @feedback = Feedback.new
  end

  def create
    feedback = Feedback.new(feedback_params)
    if feedback.save
      render json: {message: t('.success'), sendstatus: 1}
    else
      render json: {message: feedback.errors.full_messages, sendstatus: 0}
    end
  end

  private
  def feedback_params
    params.require(:feedback).permit(:name, :phone, :email, :message)
  end
end