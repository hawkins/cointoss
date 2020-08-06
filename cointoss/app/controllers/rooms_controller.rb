class RoomsController < ApplicationController

    def index
        #@rooms = Room.all
    end

    def new
        @room = Room.create
    end

    def create

        if current_user.account_balance < params[:room][:house_wallet].to_i
            @room.error = "get more money"
            render :new
        else

            current_user.account_balance = current_user.account_balance - params[:room][:house_wallet].to_i

            @room = Room.create(params.require(:room)
                                      .merge!(creation_time: Time.now(),
                                              host_id: current_user.id,
                                              locked: false)
                                      .permit(:name,
                                              :max_bet,
                                              :min_bet,
                                              :house_wallet,
                                              :max_players))
        end
    end

    def show
        @room = Rooms.find(params[:id])
    end
end
