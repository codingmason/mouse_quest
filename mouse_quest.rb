=begin
	
========= CLASSES =========

*** Character Class ***

	-Character name
	-Character Spellbook is an array of spell names
	-Location equals an array containing an X and Y axis value
	-Treasure equals the treasure they've accrued
	-XP is the amount of experience they've acquired
	-Health is 9 plus the Level 
	-Level is a floored version of XP rounded to the nearest hundred
	-Base Level


========= CLASSES =========

*** Monster Class ***
	
	-Monster name
	-Level 
	-Treasure
	-XP is the amount of experience they are worth
	-Health 
	-Attack Value
	-Attack flavor text


========= DATABASES =========

*** Saved Character Database ***

	-Character name
	-FOREIGN KEY matching the Spellbook Database
	-Money 
	-XP
	-Level

*** Spellbook Database ***

	-Primary Key (should match the Primary Key of the Saved Character Database)
	-Name (from the Character Name)
	-Columns for each spell with boolean values showing whether the character knows
	 the spell or not


========= METHODS =========

*** Intro Method ***

	-PUTS text explaining the quest
	-UNTIL correct input is TRUE
		-Ask if the user would like to load a character or create a character
			-IF Load, run Load Character Method. Correct input is TRUE
			-ELSIF Create, run Create Character Method. Correct input is TRUE
			-ELSE, PUTS an 'I didn't understand that' message. Correct input is FALSE

*** Create Character Method ***

	-PUTS a question asking for a character name
	-GETS the response. Assign as a variable 'character name'
	-UNTIL correct input is TRUE
		-PUTS a question asking to choose between a few different spells they could use
		-GETS the response. 
			-IF response is correct, assign response as variable 'first spell', input is TRUE
			-ELSE PUTS something like 'I really think you should arm yourself with knowledge'
	-CREATE an instance of the Character Class called Current Character
	-Assign character name and spell to Current Character class variables
	-Query SQLite to to add Character information to the Saved Characters database
	-Query SQLite to to add spell information to the Spellbook database
	-Run Cheesewright Inn Method

*** Load Character Method ***

	-Query SQLite to PUTS names of saved characters and their primary keys 
	-UNTIL correct input is TRUE
		-PUTS a question ask the player to pick the character number
		-GETS the response. 
			-IF response is correct, CREATE an instance of the Character Class 
			 called Current Character using info queried from Saved Character 
			 and Saved Inventory databases
			-ELSE PUTS 'That character does not exist'
	-PUTS a summary of the character, spellbook, and inventory.
	-Run Cheesewright Inn Method


*** Cheesewright Inn Method ***
	
	-UNTIL correct input is TRUE
		-PUTS a description of the inn. The proprieter, Sam Butterwhiskers, asks if
	 	they would like to rest or venture forth
		-GETS response
			-IF rest, run the Save Method. Correct input is TRUE
			-ELSIF venture forth, run the Move Method. Correct input is TRUE
			-ELSE, PUTS an 'I didn't understand that' message. Correct input is FALSE

*** Save Method ***
	
	-Query SQLite and push Current Character attributes to Saved Character Database 
	 with matching name
	-Query SQLite and push Character Spellbook attributes to Spellbook Database with 
	 matching name
	-PUTS question if they would like to continue or not
		-IF yes, PUTS description of waking up at the inn and have Sam wish them good
		luck on their quest. Run the Action Method 
		-ELSE, PUTS a goodbye message and end program


*** Action Method ***

	-PUTS would you like to move or cast a spell
	-GETS answer
		-IF answer is move, run Move Method
		-ELSIF answer is spell, run the Cast Spell Method
		-ELSE PUTS that was not a valid input

*** Cast Spell Method ***

	-PUTS list of spell names in the Character Spellbook
	-PUTS a message asking for a selection
	-GETS answer. Use answer as key for Master Spellbook Hash
		-IF the value of the hash entry is an Attack method PUTS there's no one to fight
		-ELSE run the value of the hash entry
	-RUN Move method

*** Move Method ***

	-UNTIL correct input is TRUE
		-PUTS would you like to move North, East, South, West
		-GETS answer
			-IF North add 1 to Current Character's Location y axis. Correct input TRUE 
			-ELSIF East add 1 to Current Character's Location x axis. Correct input TRUE  	
			-ELSIF South add -1 to Current Character's Location y axis. Correct input TRUE  	
			-ELSIF East add -1 to Current Character's Location x axis. Correct input TRUE  	
			-ELSE PUTS that is not a valid direction. . Correct input FALSE 
		-PUTS 'You venture' the chosen direction 'and soon come upon...'
		-Run the New Location Method

*** New Location Method ***

	-IF the Current Character's Location equals the coordinates of a special location,
	 run that location's method.
	-ELSIF the Current Character's x axis absolute value is greater than 5, PUTS the
	 description for the Tanglewood Swamp key of the Forest Map Hash and call the 
	 method listed in the hash
	-ELSE PUTS the description for the location Forest Map Hash whose key matches the
	 Current Character's Location and call the method listed in the hash 


*** Random Monster Method ***

	-Takes an argument of an INTEGER between 1 and 3, set that equal to a variable Level
	-Multiply the Level a RANDOM number between 1 and 3
		-IF the product is less than 3, call the Action Method
		-ELSE set a RANDOM number between one and the Monster Hash length
		-Use that number to select a monster from the Monster Hash
		-Create new instance of the Monster class with information from Monster Hash and
		 Level variable 
		-Set that new Monster equal to Opponent
		-PUTS a message saying that a such and such level monster has appeared
		-Run the Combat Method

*** Combat Method ***

	-Takes an argument of Opponent
	-UNTIL victory = TRUE
		-PUTS would you like to cast a spell or run away
		-GETS answer
			-IF run away, generate RANDOM number between 1 and 10
				-IF greater than 5, call Action Method
				-ELSE PUTS "The monster catches you"
			-ELSE if cast a spell, PUTS 'What spell would you like to cast'
		-PUTS a list of available spells from the Character Spellbook array
		-GETS the choice of Spell
		-Use the spell name to grab the values from the matching spell in the 
		 Spell Hash. 
			-PUTS the spell flavor text from the Spell Hash
			-Call the method from the Spell Hash
		-IF Opponent health is =< zero, victory = TRUE
		-ELSE 
			-PUTS the attack flavor text from the Monster Hash 
			-Call the Attack method with value from the Monster Hash
		-IF Current Character health is =< 0,  victory = TRUE
		-ELSE victory = FALSE
	-Call the Combat Resolution Method

*** Combat Resolution Method ***	

	-IF Current Character health is =< 0
		-PUTS a message saying your character died
		-ABORT
	-ELSE
		-PUTS a message that the opponent died
		-Set a treasure variable equal to the opponent treasure * opponent level
		-Set an XP variable equal to the opponent XP * opponent level
		-PUTS a message saying you gained x amount of treasure and XP
		-Add treasure and XP to Current Character's treasure and XP
		-Compare Current Character's Level with Current Character's Base Level
			-IF Level > Base Level, PUTS message 'Congratulations, you are now level X'
			-Set Current Character's Base Level to Current Character's Level
			-Set Current Character's Health equal to 9 + Level
		-Call Action Method

*** Attack Method ***	

	- Create RANDOM hit number between 1 and 10 + the attacker's level
	- IF hit number is > 5
		- Calculate damage by a RANDOM numbe between 1 and attackers attack value
		- Subtract damage from defender's health
		- PUTS the attacker hit for X points of damage
		- PUTS defender's health
	- ELSE PUTS the attacker missed


*** Heal Method ***

	-Set a variable max health equal to 9 + Current Character Level
	-Set variable differential equal to max health - Current Character health
	-Set variable health bonus to 33% of differential
	-Add health bonus to Current Character health
	-PUTS you gained health bonus 

*** Unlock Method ***

	-IF Current Character's location is (x,y of the Tower)
		-PUTS victory text
		-EXIT
	-ELSE PUTS nothing happens



========= Hashes =========

*** Master Spellbook Hash ***

	-Key is the spell name
	-Values are an array containing:
		-Flavor text for casting the spell
		-A method call
		-A cost

*** Forest Map Hash ***
	
 -Most keys are a two digit array of x and y axis values
 -The values are an array containing: 
 		-A description of the location
 		-A method call, usually a Random Monster Method or an Action Method 
 -One key is a string "Tanglewood Swamp"
  	-The values are an array containing: 
 		-A description of the location
 		-A Random Monster Method 


*** Monster Hash ***

	-Keys should be integers from 1 onward
	-The values are an array containing: 
		-Name
		-Treasure
		-XP 
		-Health 
		-Attack Value
		-Attack flavor text
=end

require 'sqlite3'


# Class Declarations

class Character

	attr_reader :name
	attr_accessor :character_spellbook, :level, :base_level, :location, :health, :treasure,  :xp


	def initialize(name, character_spellbook, level, treasure, xp)
		@name = name
		@character_spellbook = character_spellbook
		@location = [0,0]
		@level = level
		@base_level = level
		@health = level + 9
		@treasure = treasure
		@xp = xp
	end


end

class Monster

	attr_reader :name, :level, :treasure, :xp, :attack_value, :attack_flavor_text
	attr_accessor :health

	def initialize(name, level, health, treasure, xp, attack_value,	attack_flavor_text)
		@name = name
		@level = level
		@health = health + (level * 2)
		@treasure = rand(1..treasure) * level
		@xp = (xp * level) - rand(1..xp)
		@attack_value = attack_value + level
		@attack_flavor_text = attack_flavor_text
	end

end

# Method Declarations

def intro
	puts "Welcome brave adventurer! Etc etc"
	valid_input = FALSE
	until valid_input == TRUE
		puts "Would you like to [C]reate a character or [L]oad a character?"
		answer = gets.chomp
		if answer.downcase == "c"
			valid_input = TRUE
			return "create_character"
		elsif answer.downcase == "l"
			valid_input = TRUE
			return "load_character"
		else puts "I'm sorry, I didn't understand that. Please enter a valid input."
		end
	end
end


def create_character
	puts "What is the name of the brave little mouse you would like to create?"
	character_name = gets.chomp
	valid_input = false
	until valid_input == TRUE
		puts "Which spell would you like to start #{character_name} off with? \n" +
		     "  1. Firewhiskers - This spell will scorch your enemies with blazing tendrils of flame \n" +
		     "  2. Squeekendorf's Heavenly Cheese - This spell will create a magical wedge of cheddar \n" +
		     "     that will heal your wounds and fill your belly. \n" +
		     "  3. Mystical Mousetraps - This spell will cause ghostly mousetraps to appear and snap \n" +      
		     "     on your foes' toes. Very painful."
		spell_choice = gets.chomp    
		if spell_choice.to_i == 1	
			spell_choice = "Firewhiskers"
			valid_input = TRUE
		elsif spell_choice.to_i == 2
			spell_choice = "Squeekendorf's Heavenly Cheese"
			valid_input = TRUE
		elsif spell_choice.to_i == 3
			spell_choice = "Mystical Mousetraps"
			valid_input = TRUE
		else puts "I'm sorry, I didn't understand that."
		end
	end
	character_stats = [character_name, [spell_choice], 1, 0, 0]
	character_stats
end



def cheesewright_inn(current_character)

	puts "The Cheesewright Inn is a cheerful place, full of warmth, clean beds, \n" +
         "and the best blue-veined Stilton to be found in the whole Forest. The \n" +
         "proprieter, Sam Butterwhiskers, waves to you as you enter. 'Ah, #{current_character.name}! \n" +
         "Good to see you again!'"
    valid_input = false
	until valid_input == TRUE
    	puts "Now, are you stopping by to [R]est, or were you going to [V]enture forth?"
    	answer = gets.chomp
    	if answer.downcase == "r"
    		puts "Well now, help yourself to one of the beds upstairs. I'm sure you'll \n" +
    		     "feel better once you've slept a bit."
    		save(current_character)
    		puts "After a short rest, you feel fit as a fiddle. Sam is delighted to see \n" +
    		     "you as you walk back down to the Common Room. 'Ah, #{current_character.name}!' \n" +
    		     "Sam beams at you, 'You look ten times the mouse you did before.'" 
    		valid_input = false
    	elsif answer.downcase == "v"
    		puts "Sam chuckles. 'Well then, good luck my brave little friend,' and waves \n" +
    			 "as you exit the inn."
    			  valid_input = true
    			  move(current_character)
    	else puts "'Eh?!? Speak up! I didn't understand a word of that.'"
    		 valid_input = false
    	end
    end
end


def move(current_character)
	valid_input = false
	x_axis = current_character.location[0]
	y_axis = current_character.location[1]
	until valid_input == TRUE
		puts "Would you like to travel [N]orth, [E]ast, [S]outh, or [W]est?"
		answer = gets.chomp
		if answer.downcase == "n"
			puts "You travel north..."
			current_character.location[1] = y_axis + 1
			valid_input = true
		elsif answer.downcase == "e"
			puts "You travel east..."
			current_character.location[0] = x_axis + 1
			valid_input = true
		elsif answer.downcase == "s"
			puts "You travel south..."
			current_character.location[1] = y_axis - 1
			valid_input = true
		elsif answer.downcase == "w"
			puts "You travel west..."
			current_character.location[0] = x_axis - 1	
			valid_input = true	
		else puts "That's not a valid direction!"
			valid_input = false
		end
	end
	new_location(current_character)
end


def new_location(current_character)

	forest_map = {
	[0,1]  => [1, "You come upon a cheerful glade in the forest. Wildflowers bloom in \n the dapples sunlight. You detect the faint smell of cheese to the South."],
	"tanglewood" => [3, "You find yourself lost in a dismal stretch of Tanglewood Swamp. \n Serptine vines coil themselves around the sickly, twisted trees. \n A heavy sense of unease hangs in the air."]
	}

	if current_character.location == [0,0]
		cheesewright_inn
	elsif current_character.location == [-5,1]
		tower
	elsif current_character.location == [1,-2]
		witches_hut
	elsif current_character.location[0].abs > 2 || current_character.location[1].abs > 2
		location = forest_map["tanglewood"]
		puts location[1]
		random_monster(location[0], current_character)
	else
		coordinates = current_character.location
		location = forest_map[coordinates] 
		puts location[1]
		random_monster(location[0], current_character)
	end 
end

# *** New Location Method ***

# 	-IF the Current Character's Location equals the coordinates of a special location,
# 	 run that location's method.
# 	-ELSIF the Current Character's x axis absolute value is greater than 2, PUTS the
# 	 description for the Tanglewood Swamp key of the Forest Map Hash and call the 
# 	 method listed in the hash
# 	-ELSE PUTS the description for the location Forest Map Hash whose key matches the
# 	 Current Character's Location and call the method listed in the hash 

def save(current_character)
	puts "I'm saving"
end

def load_character
	puts "load character"
end

def tower
	puts "you arrive at the tower"
end

def witches_hut
	puts "you arrive at the witches hut"
end

def random_monster(level, current_character)
	puts "The monster that #{current_character.name} is fighting is level " + level.to_s
end




###### DRIVER CODE #######

# ed = Character.new("Ed", ["fireball", "featherfall"], 2, 100, 15)

# puts ed.character_spellbook[0]

# black_adder = Monster.new("black_adder", 2, 5, 50, 50, 4, "bites you with his poison fangs")

# puts "the health is #{black_adder.health}"
# puts "the treasure is #{black_adder.treasure}"
# puts "the xp is #{black_adder.xp}"
# puts "the attack value is #{black_adder.attack_value}"

create_or_load = intro
	if create_or_load == "create_character"
		character_stats = create_character
	else
		character_stats = load_character
	end
current_character = Character.new(*character_stats)
cheesewright_inn(current_character)




