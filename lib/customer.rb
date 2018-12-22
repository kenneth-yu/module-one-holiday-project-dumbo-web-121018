class Customer < ActiveRecord::Base

  has_many :cars

  # def initialize(hash)
  #   super
  #   @name = hash[:name]
  #   @reason = hash[:reason]
  # end

  def add_car(hash)
    hash[:customer] = self
    #Car.new(year, make, model, self)
    Car.create(hash)
  end

  def place_in_line
  end

end


# Customers

# id | name | reason | car_id |
