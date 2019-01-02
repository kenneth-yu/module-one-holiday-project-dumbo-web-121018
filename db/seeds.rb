
# Write some code here and run `rake db:seed` to add records to your databse!

Car.destroy_all
Customer.destroy_all
Job.destroy_all
Manager.destroy_all
Mechanic.destroy_all


norman = Manager.create(name: "norman")
mechanic = {name: "wing", manager: norman, job: 0}
wing = Mechanic.create(mechanic)
#wing = norman.new_hire(name: "wing")
kenny = Customer.create(name: "kenny")
car1 = {year: 2001, make:"honda", model:"prelude", customer: kenny,complaint: "suspension"}
car2 = {year: 2004, make:"mazda", model:"rx-8", customer: kenny, complaint: "engine"}
lude = Car.create(car1)
eight = Car.create(car2)
job1 = {mechanic: wing, car: lude}
job2 = {mechanic: wing, car: eight}
Job.create(job1)
Job.create(job2)

# kenny.add_car(car1)
# kenny.add_car(car2)
# job1 = norman.assign_job
# job1.save
