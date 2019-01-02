class Manager < ActiveRecord::Base

  has_many :mechanics


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
      {name: "Queued Jobs", value: "Jobs"},
      {name: "Assign a Job", value: "Assign"},
      {name: "Log Out", value: "quit"}

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
    elsif response == "Jobs"
      prompt.say("#{cars_in_queue.size}")
      self.manager_options
    elsif response == "Assign"
      self.assign_job
    else
      exit
    end
  end

  def new_hire (hash)
    prompt = TTY::Prompt.new
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
    prompt.say("Mechanic Hired!")
  end

  def cars_in_queue
    Car.all.select do |car|
      car.in_queue == true
    end
  end

  def assign_job #change in future to be more manual
    prompt = TTY::Prompt.new
    counter = 0
    lowest_queue = 0
    least_busy = ""
    queued_car = Car.all.find do |car|
      car.in_queue == true
    end
     if cars_in_queue.empty? == true
       prompt.say("There are no Jobs to be Assigned to a Mechanic!")
       manager_options
    else
      queued_car.in_queue = false
      queued_car.save
      if Mechanic.all.empty? == true
        prompt.say("You have no Mechanics! Hire some!")
      else
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
        prompt.say("Job Assigned!")
        manager_options
      end
    end
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
    prompt.say("Mechanic Fired!")
    manager_options
  end

end




# Manager
#
# id | name
