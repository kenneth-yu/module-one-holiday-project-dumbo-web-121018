class Manager < ActiveRecord::Base

  has_many :mechanics

  # def initialize(hash)
  #   super
  #   @name = hash[:name]
  # end

  def name_exists?(name)
      puts "Name already exists. Please enter a nickname!"
      user_input = gets.chomp
      new_hire (user_input)
  end


  def new_hire (hash)
    hash[:manager] = self
    hash[:job] = 0
    if Mechanic.all.empty?
      name = Mechanic.create(hash)
    else
      Mechanic.all.each do |mechanic|
        if mechanic.name == (name)
          name_exists?(name)
        else
          name = Mechanic.create(hash)
          binding.pry
        end
      end
    end
  end

  def assign_job
    counter = 0
    lowest_queue = 0
    least_busy = ""

    queued_car = Car.all.find do |car|
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
    end
    least_busy.job += 1
    hash = {}
    hash[:mechanic] = least_busy
    hash[:car] = queued_car
    hash[:diagnosis] = "To be determined..."
    Job.create(hash)
  end

end


# Manager
#
# id | name
