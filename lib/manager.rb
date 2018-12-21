class Manager
  @@all = []

  attr_reader :name
  
  def initialize(name)
    @name = name
    @@all << self
  end

  def name_exists?(name)
      puts "Name already exists. Please enter a nickname!"
      user_input = gets.chomp
      new_hire (user_input)
  end


  def new_hire (name)
    if Mechanic.all.empty?
      name = Mechanic.new(name, self)
    else
      Mechanic.all.each do |mechanic|
        if mechanic.name == (name)
          name_exists?(name)
        else
          name = Mechanic.new(name, self)
        end
      end
    end
  end

  def assign_job
    counter = 0
    lowest_queue = 0
    least_busy = ""

    queued_car = Car.all.find do |car|
      car.status == "pending"
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
    queued_car.status = "In Progress"
    Job.new(least_busy, queued_car)
  end


  def self.all
    @@all
  end
end


# Manager
#
# id | name
