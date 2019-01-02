class Job < ActiveRecord::Base

  belongs_to :car
  belongs_to :mechanic

end


# Jobs
#
# id | mechanic | car | current_jobs |
