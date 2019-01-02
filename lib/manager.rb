class Manager < ActiveRecord::Base

  has_many :mechanics

  # def initialize(hash)
  #   super
  #   @name = hash[:name]
  # end

  def name_exists?(hash)
      prompt = TTY::Prompt.new
      response = prompt.ask("Name already exists. Please enter a nickname!")
      hash = {}
      hash[:name] = response
      #binding.pry
      self.new_hire(hash)
  end

  def manager_options
    prompt = TTY::Prompt.new
    choices = [
      {name: "Hire a Mechanic", value: "Hire"},
      # {name: "My Mechanics", value: "My Mechanics"},
      {name: "Fire a Mechanic", value: "Fire"},
      {name: "Assign a Job", value: "Assign"}
    ]
    response = prompt.select("What would you like to do?", choices)
    if response == "Hire"
      response = prompt.ask("What is the name of the New Mechanic?")
      hash = {}
      hash[:name] = response
      self.new_hire(hash)
    # elsif response == "My Mechanics"
    #   my_mechanics.
    elsif response == "Fire"
      self.fire_mechanic
    elsif
      self.assign_job
    end
  end

  def new_hire (hash)
    hash[:manager] = self
    hash[:job] = 0
    if Mechanic.all.empty?
      name = Mechanic.create(hash)
    else
      results = Mechanic.all.select do |mechanic|
        mechanic.name == (hash[:name])
      end
      if results.empty?
        name = Mechanic.create(hash)
      else
        name_exists?(hash[:name])
      end
    end
    manager_options
  end

  def assign_job #change in future to be more manual
    counter = 0
    lowest_queue = 0
    least_busy = ""
    queued_car = Car.all.find do |car|
      car.in_queue == true
    end
    queued_car.in_queue = false
    queued_car.save
    Mechanic.all.each do |mechanic|
      if counter == 0
        lowest_queue = mechanic.job
        least_busy = mechanic
        counter +=1
      elsif mechanic.job < lowest_queue
        lowest_queue = mechanic.job
        least_busy = mechanic
      end
    end
    least_busy.job += 1
    least_busy.save
    hash = {}
    hash[:mechanic] = least_busy
    hash[:car] = queued_car
    hash[:diagnosis] = "To be determined..."
    Job.create(hash)
    manager_options
  end

  def my_mechanics
    Mechanic.all.select do |mechanic|
      mechanic.manager == self
    end
  end

  def fire_mechanic
    prompt = TTY::Prompt.new
    choices = []
    my_mechanics.map do |mechanic|
      choices << {name: mechanic.name, value: mechanic}
    end
    choices << {name: "Exit", value: "Quit"}
    response = prompt.select("Which Mechanic would you like to fire?", choices)
    if response == "Quit"
      exit
    else
      response.destroy
    end
    manager_options
  end

end




# Manager
#
# id | name
