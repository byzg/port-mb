class Feedback < ActiveRecord::Base
  after_create :notify

  private
  def notify
    FeedbackNotifier.new(self).send
  end
end
