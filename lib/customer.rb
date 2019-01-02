class Customer < ActiveRecord::Base

  has_many :cars

  # def initialize(hash)
  #   super
  #   @name = hash[:name]
  #   @reason = hash[:reason]
  # end
  def customer_options
    prompt = TTY::Prompt.new
    choices = [
      # {name: 'Current Cars'},
      {name: 'Add Cars'},
      {name: 'Remove Cars'},
      {name: 'Log out'}
    ]
    response = prompt.select("What would you like to do?", choices)
  #  binding.pry
    if response == 'Add Cars'
      self.add_car
    elsif response == 'Remove Cars'
      self.remove_car
    else
      prompt.say ("Logging out!")
      exit
    end
  end

  def add_car
    prompt = TTY::Prompt.new
    hash = {}
    response = prompt.ask("What year is the car?")
    hash[:year] = response
    response = prompt.ask("What make is the car?")
    hash[:make] = response
    response = prompt.ask("What model is the car?")
    hash[:model] = response
    hash[:customer] = self
    #Car.new(year, make, model, self)
    Car.create(hash)
  end

  def my_cars
     Car.all.select do |car|
      car.customer == self
    end
  end

  def remove_car
    prompt = TTY::Prompt.new
    choices = []
    my_cars.map do |car|
      choices << {name: "#{car.year.to_s + ' '+ car.make + ' ' + car.model}", value: car}
    end
    choices << {name: "Exit", value: "Quit"}
    response = prompt.select("Which car would you like to remove?", choices)
    if response == "Quit"
      exit
    else
      response.destroy
    end
  end


end


# Customers

# id | name | reason | car_id |
