class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  has_many :user_stocks
  has_many :stocks, through: :user_stocks

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def under_stock_limit?
    stocks.count < 10
  end

  def stock_already_tracked?(ticker_symbol)
    stock = Stock.check_db(ticker_symbol)
    stocks.where(id: stock.id).exists?
    return false unless stock
  end

  def can_track_stock?(ticker_symbol)
    under_stock_limit? && !stock_already_tracked?(ticker_symbol)
  end
end
