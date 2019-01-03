class Customer < ActiveRecord::Base

  has_many :cars

  def customer_options
    prompt = TTY::Prompt.new
    choices = [
      {name: 'Registered Cars'},
      {name: 'Add Cars'},
      {name: 'Remove Cars'},
      {name: 'Queue a Car for Repair', value: "queue"},
      {name: 'Log out'}
    ]
    response = prompt.select("What would you like to do?", choices)
    if response == 'Add Cars'
      self.add_car
    elsif response == 'Registered Cars'
      my_cars.each do |car|
        prompt.ok ("#{car.year} #{car.make} #{car.model}")
      end
    elsif response == 'Remove Cars'
      if owned_cars.empty? == true
        prompt.warn("You have no cars to remove!")
        sleep(2)
        customer_options
      else
        self.remove_car
      end
    elsif response == "queue"
      queue_car
    else
      prompt.ok ("Logging out! Bye bye!")
      sleep(2)
      exit
    end
    self.customer_options
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
      prompt.warn("You do not have any cars! Please add a car first!")
      sleep(2)
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
        prompt.ok("Car is queued for repair!")
        self.customer_options
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
    prompt.ok("Car added!")
    self.customer_options
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
      prompt.ok("Car removed!")
    end
    self.customer_options
  end


end


# Customers

# id | name | reason | car_id |
