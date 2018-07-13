class NotificationsController < ApplicationController
  before_action :load_noti, only: %i(show edit update destroy)
  before_action :logged_in_user, only: %i(create destroy)

  def destroy;
    if @noti.destroy
    else
    end
  end

  private
    def load_noti
      @noti = Notification.find_by id: params[:id]
      return if @noti
      flash[:danger] = t ".danger"
      redirect_to root_url
    end

    def noti_params
      params.require(:notification).permit :event, :type_id, :object_id
    end
end
