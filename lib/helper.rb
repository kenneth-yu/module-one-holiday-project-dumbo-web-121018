def welcome
  Gem.win_platform? ? (system "cls") : (system "clear")
  # puts "Welcome to AoR Repair Shop!"
  puts <<-'EOF'

                                  _    ___  ____
                                 / \  / _ \|  _ \       _.-.___\__
                                / _ \| | | | |_) |     |  _      _`-.
                               / ___ \ |_| |  _ <      '-(_)----(_)--`
       _         _          __/_/   \_\___/|_| \_\_        ____  _
      / \  _   _| |_ ___   |  _ \ ___ _ __   __ _(_)_ __  / ___|| |__   ___  _ __
     / _ \| | | | __/ _ \  | |_) / _ \ '_ \ / _` | | '__| \___ \| '_ \ / _ \| '_ \
    / ___ \ |_| | || (_) | |  _ <  __/ |_) | (_| | | |     ___) | | | | (_) | |_) |
   /_/   \_\__,_|\__\___/  |_| \_\___| .__/ \__,_|_|_|    |____/|_| |_|\___/| .__/
                                     |_|                                    |_|

EOF
  welcome_prompts
end

def welcome_prompts
  prompt = TTY::Prompt.new
  role_response = prompt.select("Are you a Customer, Mechanic, or a Manager?", %w(Customer Mechanic Manager Exit))
  welcome_check(role_response)
end

def welcome_check (input)
  #Gem.win_platform? ? (system "cls") : (system "clear")
  #prompt = TTY::Prompt.new
  if input == 'Customer'
    return recursive_customer(input)
  elsif input == 'Mechanic'
    return recursive_mechanic_search(input)
  elsif input == 'Manager'
    return recursive_manager_search(input)
  else
    exit
  end
end

def recursive_customer(input)
  prompt = TTY::Prompt.new
  if input == 'Customer'
    response = prompt.select("Are you a new or old customer?", %w(New Old))
    found_customer = new_or_old(response).customer_options
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
      prompt.ok("Profile Found!")
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
      prompt.ok("Profile Found!")
      found_manager.manager_options
      #return found_manager
    end
  end
end

def recursive_new_customer(name)
  prompt = TTY::Prompt.new
  if search_customer(name) != nil
    name = prompt.ask("Name already exists... Please enter a nickname!")
    recursive_new_customer(name)
    return name
  end
  name
end

def new_or_old (response)
  prompt = TTY::Prompt.new
  if response == "New"
    name = prompt.ask("What is your name? (Case-Sensitive)")
    if name == "back"
      welcome_prompts
    elsif name == "exit"
      exit
    else
      name = recursive_new_customer(name)
      hash = {}
      hash[:name] = name
      new_customer = Customer.create(hash)
      return new_customer
    end
  elsif response == "Old"
    name = prompt.ask("Welcome back! What is your name? (Case-Sensitive)")
    if name == "back"
      welcome_prompts
    elsif name == "exit"
      exit
    else
      found_customer = search_customer(name)
      if found_customer == nil
        response = prompt.select("Customer not found... Would you like to try again?", %w(Yes No))
        if response == "Yes"
          return new_or_old('Old')
        else
          response = prompt.select("Do you want to pick a different role?", %w(Yes No))
          if response == "Yes"
            welcome_prompts
          else
            sleep(2)
            exit
          end
        end
      end
    end
  end
  #binding.pry
  found_customer
end

def search_customer(name)
  found_customer = Customer.all.find do |customer|
    customer.name == name
  end
end

def search_manager
  prompt = TTY::Prompt.new
  response = prompt.ask("Which Manager are you? (Case-Sensitive)")
  if response == "back"
    welcome_prompts
  elsif response == "exit"
    exit
  else
    found_manager = Manager.all.find do |manager|
      manager.name == response
    end
  end
end

def search_mechanic
  prompt = TTY::Prompt.new
  response = prompt.ask("Which Mechanic are you? (Case-Sensitive)")
  if response == "back"
    welcome_prompts
  elsif response == "exit"
    exit
  else
    found_mechanic = Mechanic.all.find do |mechanic|
       mechanic.name == response
     end
  end
  found_mechanic
 end
