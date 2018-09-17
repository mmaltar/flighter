class Session < ActiveModelSerializers::Model
  attributes :user, :token

  def initialize(session)
    @user = session[:user]
    @token = session[:token]
  end
end
