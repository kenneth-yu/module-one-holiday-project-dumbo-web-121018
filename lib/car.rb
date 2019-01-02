class Car < ActiveRecord::Base

  has_many :mechanics,  through: :jobs
  has_many :jobs
  belongs_to :customer

end


# Cars

# id |  year | make | model | diagnosis | status| customer_id |
