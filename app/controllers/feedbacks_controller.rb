class FeedbacksController < ApplicationController
  def new
    @feedback = Feedback.new
  end
end