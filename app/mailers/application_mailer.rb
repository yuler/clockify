class ApplicationMailer < ActionMailer::Base
  default from: ENV.fetch("SMTP_USERNAME", nil)
  layout "mailer"
end
