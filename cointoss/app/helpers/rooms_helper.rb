module RoomsHelper
  thread_mattr_accessor :user
  thread_mattr_accessor :room

  def user
    @user || User.create
  end

  def room
    @room || Room.create
  end

  STANDBY_STAGE = 0.freeze
  BETTING_STAGE = 1.freeze
  PLAYING_STAGE = 2.freeze
end
