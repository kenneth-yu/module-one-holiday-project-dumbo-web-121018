
# Write some code here and run `rake db:seed` to add records to your databse!

Car.destroy_all
Customer.destroy_all
Job.destroy_all
Manager.destroy_all
Mechanic.destroy_all


norman = Manager.create(name: "norman")
wing = norman.new_hire(name: "wing")
kenny = Customer.create(name: "kenny", reason: "oil change")
kenny.add_car(year: 2001, make:"honda", model:"prelude")
kenny.add_car(year: 2004, make:"mazda", model:"rx-8")
job1 = norman.assign_job
job1.save
