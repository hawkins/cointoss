class BetsController < ApplicationController
  def create
    params.each do |key, value|
      @room = Room.find_by(id: params[:room_id])

      if key.start_with? "bet_"
        @bet = Bet.create(params.require(key)
                              .merge!(room_id: params[:room_id], user_id: current_user.id)
                              .permit(:description, :odds, :wager_amount, :room_id, :user_id))

        wager = params[key][:wager_amount]
        current_user.account_balance -= wager if @bet.valid?
        @room.house_wallet += wager if @bet.valid?

        @room.bets << @bet
      end
    end
  end
end
