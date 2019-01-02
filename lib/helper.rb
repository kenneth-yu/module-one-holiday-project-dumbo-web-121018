def welcome
  puts "Welcome to AoR Repair Shop!"
  welcome_prompts
end

def recursive_customer(input)
  counter = 0
  prompt = TTY::Prompt.new
  if input == 'Customer'
    response = prompt.select("Are you a new or old customer?", %w(New Old))
    found_customer = new_or_old(response).customer_options
     # if found_customer == nil
     #   response = prompt.select("Customer not found... Would you like to try again?", %w(Yes No))
     #   if response == "Yes"
     #     recursive_customer('Customer')
     #   else
     #     response = prompt.select("Do you want to pick a different role?", %w(Yes No))
     #     if response == "Yes"
     #       welcome_prompts
     #     end
     #   end
     # else
     #   prompt.say("Profile Found!")
     #   return found_customer
     # end
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
      return found_mechanic.mechanic_options
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
      found_manager.manager_options
      #return found_manager
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

def recursive_new_customer(name)
  prompt = TTY::Prompt.new
  if search_customer(name) != nil
    name = prompt.ask("Name already exists... Please enter a nickname!")
    recursive_new_customer(name)
    return name
  end
end


def new_or_old (response)
  prompt = TTY::Prompt.new
  if response == "New"
    name = prompt.ask("What is your name?")
    name = recursive_new_customer(name)
    reason = prompt.ask("What is the reason for your visit?")
    hash = {}
    hash[:name] = name
    hash[:reason] = reason
    #CREATE NEW CUSTOMER OBJECT USING CL INPUTS
    return Customer.create(hash)
  elsif response == "Old"
    name = prompt.ask("Welcome back! What is your name?")
    found_customer = search_customer(name)
    if found_customer == nil
      response = prompt.select("Customer not found... Would you like to try again?", %w(Yes No))
      if response == "Yes"
        new_or_old('Old')
      else
        response = prompt.select("Do you want to pick a different role?", %w(Yes No))
        if response == "Yes"
          welcome_prompts
        end
      end
    else
      reason = prompt.ask("What is the reason for your visit?")
      found_customer.update(reason: reason)
      binding.pry
    end
  end
  return found_customer
end

def search_customer(name)
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
  found_mechanic = Mechanic.all.find do |mechanic|
     mechanic.name == response
   end
   found_mechanic
 end
