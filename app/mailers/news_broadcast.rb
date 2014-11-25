class NewsBroadcast < ActionMailer::Base
    ADMIN_EMAIL = "twiicoup@gmail.com"

    def send_news(user, broadcast, email_list)
        @firstname = user.firstname
        @content = broadcast.content

        mail to: user.email,
        subject: "Aber CS #{email_list} News",
        from: ADMIN_EMAIL
    end
end
