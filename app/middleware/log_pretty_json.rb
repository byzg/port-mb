class LogPrettyJson
  def initialize(app)
    @app = app
  end
 
  def call(env)
    status, headers, response = @app.call(env)
     
    if defined?(Rails) && headers['Content-Type'] =~ /^application\/json/
      if response.body.present? 
        obj = JSON.parse(response.body)
        pretty_str = JSON.pretty_unparse(obj)
      else
        pretty_str = '<empty>'
      end
      Rails.logger.debug('Response: ' + pretty_str + "\n\n")
    end
     
    [status, headers, response]
  end
end