class Customer < ActiveRecord::Base

  has_many :cars

  def customer_options
    prompt = TTY::Prompt.new
    choices = [
      # {name: 'Current Cars'},
      {name: 'Add Cars'},
      {name: 'Remove Cars'},
      {name: 'Queue a Car for Repair', value: "queue"},
      {name: 'Log out'}
    ]
    response = prompt.select("What would you like to do?", choices)
    if response == 'Add Cars'
      self.add_car
    elsif response == 'Remove Cars'
      if owned_cars.empty? == true
        prompt.say("You have no cars to remove!")
        customer_options
      else
        self.remove_car
      end
    elsif response == "queue"
      queue_car
    else
      prompt.say ("Logging out!")
      exit
    end
  end

  def owned_cars
    Car.all.select do |car|
      car.customer == self
    end
  end

  def queue_car
    prompt = TTY::Prompt.new
    choices = []
    if my_cars.empty? == true
      prompt.say("You do not have any cars! Please add a car first!")
      self.customer_options
    else
      my_cars.map do |car|
        choices << {name: "#{car.year.to_s + ' '+ car.make + ' ' + car.model}", value: car}
      end
      choices << {name: "Exit", value: "Quit"}
      response = prompt.select("Which car would you like to queue?", choices)
      if response == "Quit"
        exit
      else
        response1 = prompt.ask("What is wrong with the car?")
        response.update(complaint: "#{response1}")
        self.customer_options
        prompt.say("Car is queued for repair!")
      end
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
    self.customer_options
    prompt.say("Car added!")
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
      prompt.say("Car removed!")
    end
    self.customer_options
  end


end


# Customers

# id | name | reason | car_id |
