class BetsController < ApplicationController
  def create
    params.each do |key, value|
      if key.start_with? "bet_"
        @bet = Bet.create(params.require(key)
                              .merge!(room_id: params[:room_id], user_id: current_user.id)
                              .permit(:description, :odds, :wager_amount, :room_id, :user_id))
        @room = Room.find_by(id: params[:room_id])
        @room.bets << @bet
      end
    end
  end
end
