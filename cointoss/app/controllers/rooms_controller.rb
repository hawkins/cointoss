class RoomsController < ApplicationController
    around_action :set_current_user

    def index
        @rooms = Room.all
    end

    def remove_user
        @user = User.find_by(id: params[:user_id])
        @room = Room.find_by(id: params[:room_id])
        @room.users.delete(@user)
        @user.room_id = nil
        redirect_to rooms_path
    end

    def destroy
        @room = Room.find_by(id: params[:id])
        @room.users.each do |u|
            u.room_id = nil
        end
        @room.users.delete_all
        @room.actions.destroy_all
        @room.bets.delete_all
        User.find_by(id: @room.host_id).room_id = nil
        @room.destroy
        redirect_back(fallback_location: rooms_path)
    end

    def add_user
        @user = User.find_by(id: params[:user_id])
        @room = Room.find_by(id: params[:room_id])
        @room.users << @user
        @user.room = @room
        redirect_to @room
    end

    def update
        @room = Room.find_by(id: params[:actions][:room_id])
        @room.actions.create(params[:actions].permit(:description, :odds))
        redirect_back(fallback_location: rooms_path) 
    end

    def show
        @room = Room.find(params[:id].to_i)
        #if @room.current_users.include? current_user
        #redirect_to rooms_path
        #end
        #if @room.host_id != current_user.id
        #    redirect_to rooms_path
        #end
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

        @room = Room.new
        if current_user.room_id.present?
            @room.errors.add(:room, message: "Cannot create more than one room.")
            @room.save
            redirect_back(fallback_location: rooms_path)
            return 
        end

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
            User.find_by(id: @room.host_id).update(room_id: @room.id)
            redirect_to rooms_path
        else
            render :new
        end
    end

    def set_current_user
        RoomsHelper.user = current_user
        yield
    ensure
        RoomsHelper.user = nil
    end
end
