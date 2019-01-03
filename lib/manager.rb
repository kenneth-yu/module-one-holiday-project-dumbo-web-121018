class Manager < ActiveRecord::Base

  has_many :mechanics, :dependent =>:destroy

  def manager_options #Manager "Main Menu"
    prompt = TTY::Prompt.new
    choices = [
      {name: "My Mechanics", value: "My Mechanics"},
      {name: "Hire a Mechanic", value: "Hire"},
      {name: "Fire a Mechanic", value: "Fire"},
      {name: "Queued Jobs", value: "Jobs"},
      {name: "Automatically Assign a Job", value: "QAssign"},
      {name: "Manually Assign a Job", value: "MAssign"},
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
    elsif response == "QAssign"
      self.assign_job
    elsif response == "MAssign"
      self.manually_assign_job
      # elsif response == "Search"
      #   self.search_completed_job
    else
      exit
    end
  end

  def name_exists?(hash) #Helper Function Checks to see if Name already exists in DB
      prompt = TTY::Prompt.new
      response = prompt.ask("Name already exists. Please enter a nickname! (Case-Sensitive)")
      hash = {}
      hash[:name] = response
      #binding.pry
      self.new_hire(hash)
  end


  def new_hire (hash) #Creates a new Mechanic Object
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

  def cars_in_queue #Helper function Returns Cars that are in queue
    Car.all.select do |car|
      car.in_queue == true
    end
  end

  def assign_job #Automatically create and Assign Job to Least Busy Mechanic
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

  def manually_assign_job #Manually Create a Job by picking Car and Mechanic
    prompt = TTY::Prompt.new
    list1 = []
    list2 = []
    if cars_in_queue.empty? == true
      prompt.warn("There are no Jobs to be Assigned to a Mechanic!")
      sleep(2)
      manager_options
    elsif Mechanic.all.empty? == true
        prompt.warn("You have no Mechanics! Hire some!")
        sleep(2)
        manager_options
    else
      cars_in_queue.each do |car|
        list1 << {name: "#{car.year} #{car.make} #{car.model}", value: car}
      end
      Mechanic.all.each do |mechanic|
        list2 << {name: "#{mechanic.name} - #{mechanic.job} job(s) assigned", value: mechanic}
      end
      list1 << {name: "Go Back"}
      list2 << {name: "Go Back"}
      response = prompt.select("Which car would you like to choose for repair?",list1)
      if response == "Go Back"
        manager_options
      else
        response2 = prompt.select("Which mechanic would you like to assign to the repair?", list2)
        if response2 == "Go Back"
          manager_options
        end
      end
      response.update(in_queue: false)
      hash={}
      hash[:mechanic] = response2
      hash[:car] = response
      hash[:diagnosis] = "To be determined..."
      Job.create(hash)
      prompt.ok("Job Assigned!")
      response2.job += 1
      response2.save
      sleep(2)
      manager_options
    end
  end

  def my_mechanics #Helper function that finds Mechanics Relevant to self
    Mechanic.all.select do |mechanic|
      mechanic.manager == self
    end
  end

  def fire_mechanic #Remove Mechanic Object from DB
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

  def my_mechanics_list #Return list of Mechanics with # of Jobs Assigned
    prompt = TTY::Prompt.new
    counter = 0
    my_mechanics.each do |mechanic|
      if mechanic.manager == self
        prompt.ok("#{mechanic.name} - #{mechanic.job} job(s) assigned")
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
