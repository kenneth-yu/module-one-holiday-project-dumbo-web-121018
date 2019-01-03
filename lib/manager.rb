class Manager < ActiveRecord::Base

  has_many :mechanics


  def name_exists?(hash)
      prompt = TTY::Prompt.new
      response = prompt.ask("Name already exists. Please enter a nickname! (Case-Sensitive)")
      hash = {}
      hash[:name] = response
      #binding.pry
      self.new_hire(hash)
  end

  def manager_options
    prompt = TTY::Prompt.new
    choices = [
      {name: "My Mechanics", value: "My Mechanics"},
      {name: "Hire a Mechanic", value: "Hire"},
      {name: "Fire a Mechanic", value: "Fire"},
      {name: "Queued Jobs", value: "Jobs"},
      {name: "Assign a Job", value: "Assign"},
      # {name: "Search Completed Jobs", value: "Search"},
      {name: "Log Out", value: "quit"}

    ]
    response = prompt.select("What would you like to do?", choices)
    if response == "Hire"
      response = prompt.ask("What is the name of the New Mechanic? (Case-Sensitive)")
      hash = {}
      hash[:name] = response
      self.new_hire(hash)
    elsif response == "My Mechanics"
      self.my_mechanics_list
    elsif response == "Fire"
      self.fire_mechanic
    elsif response == "Jobs"
      prompt.ok("#{cars_in_queue.size}")
      self.manager_options
    elsif response == "Assign"
      self.assign_job
    # elsif response == "Search"
    #   self.search_completed_job
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
    prompt.ok("Mechanic Hired!")
    sleep(2)
    manager_options
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
       prompt.warn("There are no Jobs to be Assigned to a Mechanic!")
       sleep(2)
       manager_options
    else
      queued_car.in_queue = false
      queued_car.save
      if Mechanic.all.empty? == true
        prompt.warn("You have no Mechanics! Hire some!")
        manager_options
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
        prompt.ok("Job Assigned!")
        sleep(2)
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
    if my_mechanics.empty? == true
      prompt.warn("There are no Mechanics to fire!")
      sleep(2)
      self.manager_options
    else
      response = prompt.select("Which Mechanic would you like to fire?", choices)
      if response == "Quit"
        prompt.ok("Logging Out! Bye bye!")
        sleep(2)
        exit
      else
        response.destroy
      end
      prompt.ok("#{response.name} was Fired!")
      sleep(2)
      manager_options
    end
  end

  def my_mechanics_list
    prompt = TTY::Prompt.new
    counter = 0
    my_mechanics.each do |mechanic|
      if mechanic.manager == self
        prompt.ok("#{mechanic.name}")
        counter += 1
      end
    end
    if my_mechanics.empty? == true
      prompt.warn("You don't have any mechanics!")
      sleep(2)
      self.manager_options
    end
    manager_options
  end
#   def search_completed_job
#     binding.pry
#     prompt = TTY::Prompt.new
#     choices = [
#       {name: "Customer Name", value: "Customer"},
#       {name: "Car", value: "Car"},
#       {name: "Mechanic", value: "Mechanic"},
#     ]
#     response = prompt.select("What would you like to search by?", choices)
#     if response == "Customer"
#       response = prompt.ask("What is the customer's name?")
#       relevant_jobs = Job.all.select do |job|
#         job.car.customer.name == response
#       end
#       relevant_jobs.map do |job|
#         prompt.say("Job number #{job.id} was completed by #{job.mechanic.name}. The customer #{job.car.customer.name} complained about #{job.car.complaint}.")
#       end
#     elsif response == "Car"
#
#
#     else
#       response = prompt.ask("What is the mechanic's name?")
#       relevant_jobs = Job.all.select do |job|
#         job.mechanic.name == response
#       end
#       relevant_jobs.each do |job|
#         prompt.say("#{reponse}")
#       end
#     end
#   end
end




# Manager
#
# id | name
