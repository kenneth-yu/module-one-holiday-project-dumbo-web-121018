class Mechanic
  @@all = []

  attr_reader :name
  attr_accessor :job

  def initialize(name, manager)
    @name = name
    @manager = manager
    @job = 0
    @@all << self
  end


  def relevant_current_jobs
    relevant_jobs = Job.current_jobs.select do |job|
      job.mechanic == self
    end
  end

  def jobs
    relevant_jobs = relevant_current_jobs
    puts "You currently have #{relevant_jobs.count} assigned to you"
    if relevant_jobs.count == 0
      puts "Congrats! You don't have any cars to fix!"
    elsif relevant_jobs.count > 0
      # binding.pry
      puts "Your current job is to fix #{relevant_jobs[0].car.fullname}. The customer's reason for visit is #{relevant_jobs[0].car.customer.reason}"
    end
  end

  def next_job
    relevant_jobs = relevant_current_jobs
    if relevant_jobs.count > 1
      p "Your next job is to fix #{relevant_jobs[1].car.fullname}. The customer's reason for visit is #{relevant_jobs[1].car.customer.reason}"
    else
      p "Congrats! You have not been assigned another job yet!"
    end
  end

  def work
    completed_job = Job.current_jobs.find do |job|
      if self == job.mechanic
        job.car.status = "Completed"
        self.job -= 1
      end
    end
    Job.current_jobs.delete(completed_job)
  end

  def help
    puts "These are the functions you can call as a Mechanic:"
    Mechanic.instance_methods(false)
  end


  def self.all
    @@all
  end

end

# Mechanics
#
# id | name | manager | job
