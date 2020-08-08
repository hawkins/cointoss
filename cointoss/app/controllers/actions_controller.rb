class ActionsController < ApplicationController
    def create
        #@action = Action.create()
    end

    def destroy
        Action.find_by(id: params[:id]).destroy
        redirect_back(fallback_location: rooms_path)
    end
end
