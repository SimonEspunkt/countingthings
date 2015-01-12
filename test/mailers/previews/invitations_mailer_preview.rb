# Preview all emails at http://localhost:3000/rails/mailers/invitations_mailer
class InvitationsMailerPreview < ActionMailer::Preview
  def invitation_preview
    InvitationsMailer.invitation(User.first, 'bla@bla.de', 'http://zerosim.eltanin.uberspace.de/vi/T6p8e3bntR2-qCYHEXBnSRL7P3TEXNjXcRXWJG-w-OA', Thing.first)
  end
end
