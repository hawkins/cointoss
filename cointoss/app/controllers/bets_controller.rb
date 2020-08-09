class BetsController < ApplicationController
  include RoomsHelper
  around_action :set_room

  def create
    @room = Room.find_by(id: params[:room_id])

    params.each do |key, value|
      if @room.room_state != BETTING_STAGE
        if @room.room_state == PLAYING_STAGE
          @room.errors.add(:room, "You cannot place bets while the game is in progress.")
        end
        if @room.room_state == STANDBY_STAGE
          @room.errors.add(:room, "You cannot place bets while the host is updating odds.")
        end

        @room.save

        redirect_back(fallback_location: @room)
        return
      end

      if key.start_with? "bet_"
        wager = params[key][:wager_amount].to_i

        @bet = Bet.new(params.require(key)
                             .merge!(room_id: params[:room_id], user_id: current_user.id)
                             .permit(:description, :odds, :wager_amount, :room_id, :user_id))


        if @bet.valid?
          current_user.update(account_balance: current_user.account_balance - wager)

          @room.update(house_wallet: @room.house_wallet + wager, bets: @room.bets.concat(@bet))
        else
          # TODO: Show error for invalid bet here

          render 'rooms/show'
          return
        end
      end
    end

    redirect_to @room
  end

  def set_room
    RoomsHelper.room = Room.find_by(id: params[:room_id])
    RoomsHelper.user = current_user
    yield
  end
end
