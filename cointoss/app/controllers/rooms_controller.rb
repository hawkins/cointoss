class RoomsController < ApplicationController

    def index
        @rooms = Room.all
    end

    def add_action_to_room
    end

    def show
        @room = Room.find(params[:id].to_i)
        if @room.current_users.include? current_user
            redirect_to rooms_path
        end
        if @room.host_id != current_user.id
            redirect_to rooms_path
        end
    end

    def new
        @room = Room.new
    end

    def update_user_account_balance(host_id, house_wallet)
        host = User.find_by(id: host_id)
        new_account_balance = host.account_balance - house_wallet
        host.update(account_balance: new_account_balance)
    end

    def create

        @room = Room.create(params.require(:room)
                                      .merge!(creation_time: Time.now(),
                                              host_id: current_user.id,
                                              locked: false)
                                      .permit(:name,
                                              :max_bet,
                                              :min_bet,
                                              :house_wallet,
                                              :max_users,
                                              :host_id,
                                              :locked))
            
        if @room.valid?
            update_user_account_balance(@room.host_id, @room.house_wallet)
        else
            render :new
        end
    end
end
