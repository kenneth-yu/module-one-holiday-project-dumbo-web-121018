class Mechanic < ActiveRecord::Base

  has_many :cars, through: :jobs
  has_many :jobs
  belongs_to :manager

  def mechanic_options
    prompt = TTY::Prompt.new
    choices = [
      {name: 'Current Jobs'},
      {name: 'Next Job'},
      {name: 'Work'},
      {name: 'Log out'}
    ]
    response = prompt.select("What would you like to do?", choices)
    if response == "Current Jobs"
      self.jobs
    elsif response == 'Next Job'
      self.next_job
    elsif response == 'Work'
      self.work
    else
      prompt.say ("Logging out!")
      exit
    end
  end

  def relevant_current_jobs
    relevant_jobs = Job.select do |job|
      job.mechanic == self && job.status == false
    end
  end

  def jobs
    prompt = TTY::Prompt.new
    relevant_jobs = relevant_current_jobs
    prompt.say("You currently have #{relevant_jobs.count} job(s) assigned to you")
    if relevant_jobs.count == 0
      prompt.say("Congrats! You don't have any cars to fix!")
    elsif relevant_jobs.count > 0
      prompt.say("Your current job is to fix the #{relevant_jobs[0].car.year} #{relevant_jobs[0].car.make} #{relevant_jobs[0].car.model}. The customer's reason for visit is #{relevant_jobs[0].car.complaint}")
    end
    mechanic_options
  end

  def next_job
    prompt = TTY::Prompt.new
    relevant_jobs = relevant_current_jobs
    if relevant_jobs.count > 1
      prompt.say("Your next job is to fix the #{relevant_jobs[0].car.year} #{relevant_jobs[0].car.make} #{relevant_jobs[0].car.model}. The customer's reason for visit is #{relevant_jobs[1].car.complaint}")
    else
      prompt.say ("Congrats! You have not been assigned another job yet!")
    end
    mechanic_options
  end

  def work #need to change to find jobs where status is true
    prompt = TTY::Prompt.new
    if relevant_current_jobs.empty? == true
      prompt.say ("There are no more Jobs to complete!")
      self.mechanic_options
    else
      completed_job = Job.all.find do |job|
        if self == job.mechanic && job.status == false
          job.status = true
          self.job -= 1
          self.save
          job.save
        end
      end
      prompt.say("Job Completed")
      mechanic_options
    end
  end
  # def help  #should not need this thanks to TTY Prompt Gem
  #   puts "These are the functions you can call as a Mechanic:"
  #   Mechanic.instance_methods(false)
  # end

end

# Mechanics
#
# id | name | manager | job
