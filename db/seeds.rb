
# Write some code here and run `rake db:seed` to add records to your databse!

Car.destroy_all
Customer.destroy_all
Job.destroy_all
Manager.destroy_all
Mechanic.destroy_all


#Create Manager named "Norman"
norman = Manager.create(name: "Norman")
#Create Manager named "Yurman"
yurman = Manager.create(name: "Yurman")

#Mechanic Hashes used for creating Mechanic Objects
mechanic = {name: "Wing", manager: norman, job: 0}
mechanic2 = {name: "Peter", manager: yurman, job: 0}

 #Create Mechanic named "Wing" belongs to "Norman"
wing = Mechanic.create(mechanic)
peter = Mechanic.create(mechanic2)

#Create Customer named "Kenny"
kenny = Customer.create(name: "Kenny")
#Create Customer named "Calvin"
calvin = Customer.create(name: "Calvin")

#Car Hashes used for creating Car Objects
car1 = {year: 2001, make:"Honda", model:"Prelude", customer: kenny,complaint: "Suspension"}
car2 = {year: 2004, make:"Mazda", model:"Rx-8", customer: kenny, complaint: "Engine"}
car3 = {year: 2002, make:"Honda", model:"S2000", customer: calvin, complaint:"Brakes"}
car4 = {year: 2008, make:"Toyota", model:"Rav-4", customer:calvin, complaint:"Radio"}

#Create two cars that belong to "Kenny"
lude = Car.create(car1)
eight = Car.create(car2)
#Create two cars that belong to "Calvin"
s2 = Car.create(car3)
rav = Car.create(car4)

#Job hashes used for creating Job Objects
job1 = {mechanic: wing, car: lude}
job2 = {mechanic: peter, car: eight}
job3 = {mechanic: wing, car:s2}

#Create a job
Job.create(job1).car.update(in_queue: false)
Job.create(job2).car.update(in_queue: false)
Job.create(job3).car.update(in_queue: false)
#NOTE: rav is in queue but not assigned!
