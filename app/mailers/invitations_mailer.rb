class InvitationsMailer < ActionMailer::Base
  default from: "info@zerosim.eltanin.uberspace.de"

  def invitation(user, recipient, link, thing)
    @recipient = recipient
    @user = user
    @link = link
    @thing = thing
    mail(to: recipient, subject: '#{user.name} möchte mit dir Dinge zählen! (countingthings.io)' )
  end
end
