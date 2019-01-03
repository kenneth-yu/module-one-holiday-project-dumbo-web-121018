class Mechanic < ActiveRecord::Base

  has_many :cars, through: :jobs
  has_many :jobs, :dependent=> :destroy
  belongs_to :manager

  def mechanic_options #Mechanic's "Main Menu"
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
      prompt.ok ("Logging out! Bye bye!")
      sleep(2)
      exit
    end
  end

  def relevant_current_jobs #returns Jobs Relevant to self that are not complete
    relevant_jobs = Job.select do |job| #Helper function
      job.mechanic == self && job.status == false
    end
  end

  def jobs #returns Current Job with Count
    prompt = TTY::Prompt.new
    relevant_jobs = relevant_current_jobs
    prompt.ok("You currently have #{relevant_jobs.count} job(s) assigned to you...")
    if relevant_jobs.count == 0
      prompt.ok("Congrats! You don't have any cars to fix!")
    elsif relevant_jobs.count > 0
      prompt.ok("Your current job is to fix the #{relevant_jobs[0].car.year} #{relevant_jobs[0].car.make} #{relevant_jobs[0].car.model}. The customer's reason for visit is #{relevant_jobs[0].car.complaint}")
    end
    self.mechanic_options
  end

  def next_job #Returns next job if exists
    prompt = TTY::Prompt.new
    relevant_jobs = relevant_current_jobs
    if relevant_jobs.count > 1
      prompt.ok("Your next job is to fix the #{relevant_jobs[1].car.year} #{relevant_jobs[1].car.make} #{relevant_jobs[1].car.model}. The customer's reason for visit is #{relevant_jobs[1].car.complaint}")
    else
      prompt.ok ("Congrats! You have not been assigned another job yet!")
    end
    self.mechanic_options
  end

  def work #Looks for first job in queue and marks it as complete with diagnosis.
    prompt = TTY::Prompt.new
    if relevant_current_jobs.empty? == true
      prompt.ok ("There are no more Jobs to complete!")
      self.mechanic_options
    else
      completed_job = Job.all.find do |job|
        if self == job.mechanic && job.status == false
          response = prompt.ask ("#{job.car.customer.name} complained about the #{job.car.complaint}. What is your diagnosis?")
          job.update(diagnosis: response, status: true)
          # job.status = true #used update instead
          self.job -= 1
          self.save
          # job.save
        end
      end
      prompt.ok("Job Completed")
      self.mechanic_options
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
