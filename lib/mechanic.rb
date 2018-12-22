class Mechanic < ActiveRecord::Base

  has_many :cars, through: :jobs
  has_many :jobs
  belongs_to :manager

  # def initialize(hash)
  #   super
  #   @name = hash[:name]
  # end

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

  def work #need to change to find jobs where status is true
    completed_job = Job.current_jobs.find do |job|
      if self == job.mechanic
        job.car.status = true
        self.job -= 1
      end
    end
    Job.current_jobs.delete(completed_job)
  end

  # def help  #should not need this thanks to TTY Prompt Gem
  #   puts "These are the functions you can call as a Mechanic:"
  #   Mechanic.instance_methods(false)
  # end

end

# Mechanics
#
# id | name | manager | job
