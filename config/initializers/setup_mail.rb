ActionMailer::Base.smtp_settings={
  :address=>"mail01.harbingergroup.com",
  :port=>25,
  :domain=>"automationgroup.com",
  :user_name=>"activetest@automationgroup.com ",
  :password=>"active_test_mailer ",
  :authentication=> :login,
  :enable_starttls_auto=>true
}


