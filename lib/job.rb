class Job
  @@all = []
  @@current_jobs = []
  attr_reader :mechanic, :car

  def initialize(mechanic, car)
    @mechanic = mechanic
    @car = car
    @@all << self
    @@current_jobs << self
  end

  def self.current_jobs
    @@current_jobs
  end

  def self.all
    @@all
  end
end


# Jobs 
#
# id | mechanic | car | current_jobs |
