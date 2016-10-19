class FeedbackNotifier
  def initialize(feedback)
    @feedback = feedback
    @message = @feedback.name
  end

  def send
    ADMINS.each do |admin|
      vk(admin)
    end
  end

  private
  def vk(admin)
    request = Typhoeus::Request.new(
      'https://api.vk.com/method/messages.send',
      method: :get,
      params: {
        domain: admin[:vk_domain],
        message: @message,
        access_token: ENV['VK_ACCESS_TOKEN'],
        v: ENV['VK_VERSION']
      }
    )
    Rails.logger.info 'Run request to api.vk.com/method/messages.send'
    Rails.logger.info "for admin #{admin[:vk_domain]} with feedback.id = #{@feedback.id}"
    request.on_complete do |response|
      Rails.logger.info 'Got response:'
      Rails.logger.info response.body
    end
    request.run
  end
end