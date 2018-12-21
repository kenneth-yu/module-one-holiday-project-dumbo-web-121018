class Customer
  @@all = []

  attr_accessor :car, :reason
  attr_reader :name

  def initialize(name, reason)
    @name = name
    @reason = reason
    #@car = [] dont store relationship here
    @@all << self
  end

  def add_car(year, make, model)
    Car.new(year, make, model, self)
  end

  def place_in_line
  end

  def self.all #returns all customers
    @@all
  end
end


# Customers

# id | name | reason | car_id |
