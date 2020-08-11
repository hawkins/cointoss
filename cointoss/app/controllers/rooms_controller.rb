class RoomsController < ApplicationController
  around_action :set_current_user

  def index
    @rooms = Room.all
  end

  def remove_user
    @user = User.find_by(id: params[:user_id])
    @room = Room.find_by(id: params[:room_id])

    if @room.room_state == RoomsHelper::PLAYING_STAGE
      @rooms.errors.add(:base, "You can't leave an in-progress game. Wait for the host to end the round.")
      render :index
      return
    end

    if @user.id != @room.host_id
      @room.users.delete(@user)
      @user.room_id = nil
      render :index
    else
      @rooms.errors.add(:base, "You can't leave a game you're hosting. That would be rude!")
      render :index
      return
    end
  end

  def destroy
    @room = Room.find_by(id: params[:id])
    RoomsHelper.room = @room

    @room.users.each do |u|
      u.room_id = nil
    end
    @room.users.delete_all

    @room.actions.destroy_all

    @room.bets.delete_all

    @user = User.find_by(id: @room.host_id)
    @user.update(room_id: nil)
    if (@room.house_wallet > 0)
      @user.update(account_balance: @user.account_balance + @room.house_wallet)
    end

    @room.destroy
    RoomsHelper.room = nil

    redirect_back(fallback_location: rooms_path)
  end

  def add_user
    @user = User.find_by(id: params[:user_id])
    @room = Room.find_by(id: params[:room_id])
    @room.users << @user
    @user.room = @room
    redirect_to @room
  end

  def show
    begin
      @room = Room.find(params[:id].to_i)
    rescue ActiveRecord::RecordNotFound
      redirect_to rooms_path
    else
      if !@room.users.exists?(current_user.id)
        redirect_to rooms_path
      end
    end
  end

  def new
    @room = Room.new if @room.nil?
  end

  def update_user_account_balance(host_id, house_wallet)
    host = User.find_by(id: host_id)
    new_account_balance = host.account_balance - house_wallet
    host.update(account_balance: new_account_balance)
  end

  def create
    @room = Room.new(params.require(:room)
                         .merge!(creation_time: Time.now(),
                                 host_id: current_user.id,
                                 locked: false,
                                 room_state: RoomsHelper::STANDBY_STAGE)
                         .permit(:name,
                                 :max_bet,
                                 :min_bet,
                                 :house_wallet,
                                 :max_users,
                                 :host_id,
                                 :locked,
                                 :room_state)) if @room.nil?

    if current_user.room_id.present?
      @room.errors.add(:base, "Cannot create more than one room.")

      render :new
      return
    end

    if @room.valid?
      @room.save
      update_user_account_balance(@room.host_id, @room.house_wallet)
      User.find_by(id: @room.host_id).update(room_id: @room.id)
      redirect_to @room
    else
      render :new
    end
  end

  def set_current_user
    RoomsHelper.user = current_user
    RoomsHelper.room = @room
    RoomsHelper.room = Room.find_by(id: params[:id]) if @room.nil?
    yield
  end

  def place_bets
    @room = Room.find_by(id: params[:room_id])

    valid_bets = []
    invalid_bets = []

    params.each do |key, value|
      if @room.room_state != RoomsHelper::BETTING_STAGE
        if @room.room_state == RoomsHelper::PLAYING_STAGE
          @room.errors.add(:room, "You cannot place bets while the game is in progress.")
        end
        if @room.room_state == RoomsHelper::STANDBY_STAGE
          @room.errors.add(:room, "You cannot place bets while the host is updating odds.")
        end

        # TODO: Shouldn't this just be render rooms/show?
        render :show
        return
      end

      if key.start_with? "bet_"
        bet = Bet.new(params.require(key)
                           .merge!(room_id: params[:room_id], user_id: current_user.id)
                           .permit(:description, :odds, :wager_amount, :room_id, :user_id))

        # Ignore bets where wager is nil or 0 because user did not take this bet
        next if bet.wager_amount.nil? or bet.wager_amount.zero?

        if bet.invalid?
          invalid_bets << bet
        else
          valid_bets << bet
        end
      end
    end

    valid_bets.each do |bet|
      wager = bet.wager_amount
      current_user.update(account_balance: current_user.account_balance - wager)
      @room.update(house_wallet: @room.house_wallet + wager, bets: @room.bets.concat(bet))
    end

    invalid_bets.each do |bet|
      bet.errors.full_messages.each do |message|
        @room.errors.add(:base, message)
      end
    end

    @room.save

    render :show
    return
  end

  # Handle form submission with information on which actions
  # yielded a return or not, calculate payouts for each bet
  # as a result of the action results, and advance the stage
  def calculate_payouts
    @room = Room.find_by(id: params[:room_id])

    params.each do |key, value|
      if key.start_with? "bet_"
        did_yield = params[key][:yield].to_i == 1
        bets = Bet.where(description: params[key][:description],
                        odds: params[key][:odds],
                        room_id: params[:room_id])

        if did_yield
          bets.each do |bet|
            user = User.find_by(id: bet.user_id)
            user.update(account_balance: user.account_balance + bet.potential_earning)
          end
        end

        # TODO: Notify users of their results
      end
    end

    @room.bets.delete_all

    next_stage
  end

  # Progress room to the next stage, updating @room.room_state
  #
  # @room.state has these values:
  #   0: Standby - Admin will update actions and odds now
  #   1: Betting - Odds are locked and players can place bets now
  #   2: Playing - Game is in progress, bets are locked, admin can reward bets now
  def next_stage
    id = params[:id] || params[:room_id]
    @room = Room.find(id)

    return if current_user.id != @room.host_id

    @room.room_state += 1
    @room.room_state = RoomsHelper::STANDBY_STAGE if @room.room_state > RoomsHelper::PLAYING_STAGE
    @room.save

    redirect_to @room
  end
end
