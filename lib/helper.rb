def welcome
  puts "Welcome to AoR Repair Shop!"
  welcome_prompts
end

def recursive_customer(input)
  counter = 0
  prompt= TTY::Prompt.new
  if input == 'Customer'
    response = prompt.select("Are you a new or old customer?", %w(New Old))
     found_customer = new_or_old(response)
     if found_customer == nil
       response = prompt.select("Customer not found... Would you like to try again?", %w(Yes No))
       if response == "Yes"
         recursive_customer('Customer')
       else
         response = prompt.select("Do you want to pick a different role?", %w(Yes No))
         if response == "Yes"
           welcome_prompts
         end
       end
     else
       prompt.say("Profile Found!")
       return found_customer
     end
  end
end

def recursive_mechanic_search(input)
  prompt = TTY::Prompt.new
  if input == 'Mechanic'
    found_mechanic = search_mechanic
    if found_mechanic == nil
      response = prompt.select("Mechanic not found... Would you like to try again?", %w(Yes No))
      if response == "Yes"
        recursive_mechanic_search('Mechanic')
      else
        response = prompt.select("Do you want to pick a different role?", %w(Yes No))
        if response == "Yes"
          welcome_prompts
        end
      end
    else
      prompt.say("Profile Found!")
      return found_mechanic
    end
  end
end

def recursive_manager_search(input)
  prompt = TTY::Prompt.new
  if input == 'Manager'
    found_manager = search_manager
    if found_manager == nil
      response = prompt.select("Manager not found... Would you like to try again?", %w(Yes No))
      if response == "Yes"
        recursive_manager_search('Manager')
      else
        response = prompt.select("Do you want to pick a different role?", %w(Yes No))
        if response == "Yes"
          welcome_prompts
        end
      end
    else
      prompt.say("Profile Found!")
      return found_manager
    end
  end
end

def welcome_check (input)
  #prompt = TTY::Prompt.new
  if input == 'Customer'
    return recursive_customer(input)
  elsif input == 'Mechanic'
    return recursive_mechanic_search(input)
  else
    return recursive_manager_search(input)
  end
end

def welcome_prompts
  prompt = TTY::Prompt.new
  role_response = prompt.select("Are you a Customer, Mechanic, or a Manager?", %w(Customer Mechanic Manager))
  welcome_check(role_response)
end


def new_or_old (response)
  prompt = TTY::Prompt.new
  if response == "New"
    name = prompt.ask("What is your name?")
    reason = prompt.ask("What is your reason for your visit?")
    #CREATE NEW CUSTOMER OBJECT USING CL INPUTS
    return Customer.create(name,reason)
  elsif response == "Old"
    name = prompt.ask("Welcome back! What is your name?")
    reason = prompt.ask("What is the reason for your visit?")
    search_customer(name, reason)

  end
end

def search_customer(name, reason)
  found_customer = Customer.all.find do |customer|
    customer.name == name
  end
end

def search_manager
  prompt = TTY::Prompt.new
  response = prompt.ask("Which Manager are you?")
  found_manager = Manager.all.find do |manager|
    manager.name == response
  end
end

def search_mechanic
  prompt = TTY::Prompt.new
  response = prompt.ask("Which Mechanic are you?")
  var = found_mechanic = Mechanic.all.find do |mechanic|
     mechanic.name == response
   end
   var
 end
