class Car < ActiveRecord::Base

  has_many :mechanics,  through: :jobs
  has_many :jobs
  belongs_to :customer

  # def initialize(hash)
  #   super
  #   #@make = hash[:make]
  #   #@model = hash[:model]
  #   #@year = hash[:year]
  #@fullname = year + " " + make + " " + model
  #   #@customer = hash[:customer]
  #   @diagnosis = nil
  #   @status = "Pending"
  # end

end


# Cars

# id |  year | make | model | diagnosis | status| customer_id |
