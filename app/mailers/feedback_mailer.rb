class FeedbackMailer < ActionMailer::Base
  default from: "feedback@#{DOMAIN}"

  def admins(feedback)
    @feedback = feedback
    mail(to: ADMINS.map(&:email).join(','), subject: t('.subject', domain: DOMAIN))
  end
end