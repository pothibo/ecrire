class SessionsController < ApplicationController
  before_action :authenticate!, except: :failed

  def create
    redirect_to :root
  end

  def destroy
    warden.logout
    redirect_to :back
  end

  def failed
    respond_to do |format|
      format.html do
        unless warden.errors.empty?
          flash[:user] = warden.errors.full_messages.to_sentence
        end
        redirect_to :root
      end
      format.js do
        render 'show' and return
      end
    end
  end
end
