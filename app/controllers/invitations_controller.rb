class InvitationsController < ApplicationController
  rescue_from ActionController::ParameterMissing, with: :missing_value

  #TODO: DELETE THIS METHOD!!!
  def index
    @invitations = Invitation.all
  end 


  def new
    @invitation = current_user.things.find(params[:id]).invitations.new
  end

  # POST /things/:id/invitation/create
  def create
    if invitation_to_self?
      flash[:alert] = "Invitation to self is not allowed."
      redirect_to things_path and return
    end

    if already_sharing_with_user?
      flash[:alert] = "Already sharing thing with specified user"
      redirect_to things_path and return
    end

    unless unconfirmed_invitation_found?
      #create a new invitation
      @invitation = current_user.things.find(thing_id_params).invitations.new(
                      user_id: current_user.id,
                      thing_id: thing_id_params,
                      recipient_email: invitation_params,
                      confirmation_code: genConfcode)

      if @invitation.save
        flash[:notice] = "Invitation to #{@invitation.recipient_email} send."
        redirect_to things_path
      else
        flash[:alert] = "Einladung konnte nicht gesendet werden, keine gültige Email-Adresse."
        redirect_to(request.referrer || things_path)
      end
    else
      resend_unconfirmed_invitation
    end
  end




  # POST /vi/:code
  # POST /vi/:code.json
  def validateInvitation
    @invitation = Invitation.where(recipient_email: current_user.email, confirmation_code: params[:code], accepted: false).first
  
    unless @invitation.nil?
      @userobject = Userobject.new(user_id: current_user.id, thing_id: @invitation.thing_id)

      if @invitation.update(accepted: true) and @userobject.save
        flash[:notice] = "Invitation accepted."
        redirect_to things_path
      else
        flash[:alert] = "Invitation could not be accepted."
        redirect_to things_path
      end
    else
      flash[:alert] = "No such invitation found."
      redirect_to things_path
    end

  end


  private
    def genConfcode
      SecureRandom.urlsafe_base64(32)
    end

    def thing_id_params
      params.require(:id)
    end

    def invitation_params
      params.require(:invitation).require(:recipient_email)
    end

    def invitation_to_self?
      current_user.email == invitation_params    
    end

    def already_sharing_with_user?
      user = User.where(email: invitation_params).first

      unless user.nil?
        userobject = Userobject.where(user_id: user.id, thing_id: thing_id_params).first
        not userobject.nil?
      else
        false
      end
    end

    def unconfirmed_invitation_found?
      invitation = current_user.things.find(thing_id_params).invitations.where(
                user_id: current_user.id,
                thing_id: thing_id_params,
                recipient_email: invitation_params,
                accepted: false)
              .first

      not invitation.nil?
    end

    def resend_unconfirmed_invitation
      @invitation = current_user.things.find(thing_id_params).invitations.where(
                      user_id: current_user.id,
                      thing_id: thing_id_params,
                      recipient_email: invitation_params,
                      accepted: false)
                    .first

      #update existing invitation with new confirmation_code (and send email again)
      if @invitation.update(confirmation_code: genConfcode)
        flash[:notice] = "Invitation to #{@invitation.recipient_email} send."
        redirect_to things_path
      end
    end

    def missing_value
      flash[:alert] = "Bitte gib eine gültige Email-Adresse ein"
      redirect_to(request.referrer || things_path)
    end
end
