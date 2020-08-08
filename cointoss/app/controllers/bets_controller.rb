class BetsController < ApplicationController
  def create
    params.each do |key, value|
      @room = Room.find_by(id: params[:room_id])

      if key.start_with? "bet_"
        @bet = Bet.create(params.require(key)
                              .merge!(room_id: params[:room_id], user_id: current_user.id)
                              .permit(:description, :odds, :wager_amount, :room_id, :user_id))

        wager = params[key][:wager_amount]

        if @bet.valid?

          current_user.account_balance -= wager
          current_user.save

          @room.house_wallet += wager
          @room.bets << @bet
          @room.save
        end
      end
    end
  end
end
