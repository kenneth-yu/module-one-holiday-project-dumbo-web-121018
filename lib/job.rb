class Job < ActiveRecord::Base

  belongs_to :car
  belongs_to :mechanic


  # def initialize(hash)
  #   super
  # #  @mechanic = hash[:mechanic]
  #   #@car = hash[:car]
  #end

  # def completed?
  #   @status
  # end

end


# Jobs
#
# id | mechanic | car | current_jobs |
