class ActionsController < ApplicationController
    def create
        @action = Action.create(params[:actions].permit(:description, :odds))

        @room = Room.find_by(id: params[:actions][:room_id])
        @room.actions << @action

        redirect_back(fallback_location: rooms_path)
    end

    def destroy
        Action.find_by(id: params[:id]).destroy
        redirect_back(fallback_location: rooms_path)
    end
end
