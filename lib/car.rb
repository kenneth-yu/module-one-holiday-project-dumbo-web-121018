class Car
  @@all = []

  attr_reader :year, :make, :model, :customer , :fullname
  attr_accessor :status, :diagnosis

  def initialize(year, make, model, customer)
    @make = make
    @model = model
    @year = year
    @fullname = year + " " + make + " " + model
    @customer = customer
    @diagnosis = "TBD"
    @status = "Pending"
    @@all << self
  end

  def self.all #returns all cars
    @@all << self
  end

end


# Cars

# id |  year | make | model | diagnosis | status| customer_id |
