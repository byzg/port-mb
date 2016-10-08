class FeedbacksController < ApplicationController
  def new
    @feedback = Feedback.new
  end

  def create
    render json: {message: 'Спасибки!=)', sendstatus: 1}
  end
end