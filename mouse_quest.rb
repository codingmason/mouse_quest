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
	-Master spellbook with each spell:
		-Name
		-Description
		-Flavor text
		-Attack value
		-Heal Value
		-Price


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
	-Character Spellbook
	-Money 
	-XP
	-Level


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

*** Forest Map Method ***
	-Create a 3-d array with asterisks for each point on the map and numbers
	 for named location
	-When method is called, add brackets around the current asterisk using the location
	 x and y axis 
	-print the array
	-PUTS a map key
	-GETS to exit and call a MOVE method

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






#============= Require Statements ================

require 'sqlite3'
require 'faker'

#============= Class Declarations================
class Character

	attr_reader :name, :master_spellbook, :id
	attr_accessor :unlearned_spells, :character_spellbook, :level, :location, :health, :treasure,  :xp


	def initialize(id, name, character_spellbook, level, treasure, xp)
		@id = id
		@name = name
		@character_spellbook = character_spellbook
		@unlearned_spells = ["Arcane Shopping Spree", "Camembert's Sorcerous Habedashery", "Firewhiskers", "Squeekendorf's Heavenly Cheese", "Mystical Mousetraps", "Furball Fireball", "Ice Mice", "Magical Mouse Door"] - @character_spellbook
		@location = [0,0]
		@level = level
		@health = level + 9
		@treasure = treasure
		@xp = xp
		@master_spellbook = {
		    "Arcane Shopping Spree" => ["Default", "\nDrawing on your sorcerous energies, you summon a \nmagical box from the ethereal plane. When you open \nit, you find a Mystic #{Faker::Commerce.product_name}. Just \nwhat every sorceror's apprentice needs.", 0, 0, 50, "Arcane Shopping Spree"],
		 	"Camembert's Sorcerous Habedashery" => ["Default", "\nCalling on your arcane powers, you create a mystical #{Faker::Color.color_name} hat \nto appear on its head. Very dashing.", 0, 0, 50,"Camembert's Sorcerous Habedashery"],
		 	"Firewhiskers" => ["This spell will scorch your enemies with blazing tendrils of flame", "\nTendrils of fire burst from your hands, singing them a bit, while your enemy erupts in flames", 3, -1, 200, "Firewhiskers"],
		 	"Squeekendorf's Heavenly Cheese" => ["This spell will create a magical wedge of cheddar that will heal \nyour wounds and fill your belly.", "\nA delicious wheel of mystic cheddar appears before you, and you devour it.", 0, 3, 200, "Squeekendorf's Heavenly Cheese"],
			"Mystical Mousetraps" => ["This spell will cause ghostly mousetraps to appear and snap on your foes' \ntoes. Very painful.", "\nYour traps go snap snap snap!", 2, 0, 200, "Mystical Mousetraps"],
			"Furball Fireball" => ["This spell causes a gigantic sphere of flaming mice to appear and roll \nover your enemies", "\nSummoning a giant ball of flaming fur, you hurl the fiery sphere at your foe.", 5, 0, 500, "Furball Fireball"] ,
     		"Ice Mice" => ["This spell causes a swarm of spectral Frost Mice to appear, who will cut your \nfoes to ribbons.", "\nA wintry wind fills the air as a swarm of spectral Frost Mice pounce on your enemy", 5, 0, 500, "Ice Mice"],
     		"Magical Mouse Door" => ["This spell can cause a mystical opening to appear, allowing access \nto the most impregnable places.", "\nA hole appears underneath your foe, twisting his ankle viciously", 2, 0, 1000, "Magical Mouse Door"]
     	}
     end

	def heal(int)
		@health += int 
		if @health > (@level + 9)
			@health = (@level + 9)
		end
	end

	def gain_treasure(int)
		@treasure += int
	end

	def gain_xp(int)
		@xp += int
		new_level = (@xp * 0.01) + 1
		if new_level.floor > @level
			@level = new_level.floor
			puts "\nYou are now level #{@level}"
		else
		end
	end

	def learn_spell(new_spell)
		@character_spellbook << new_spell
		@unlearned_spells = @unlearned_spells - @character_spellbook
		puts "\nYou just learned how to cast #{new_spell}"
	end

	def pay(amount)
		@treasure -= amount
		puts "You now have #{@treasure} gold pieces.\n"
	end

	def spell_store
		valid_input = false
		until valid_input == true

			puts "\n**Available Spells**\n"
				@unlearned_spells.each do |spell_name|
					spell_stats = @master_spellbook[spell_name]
					puts (@unlearned_spells.index(spell_name) + 1).to_s + ". " + spell_name + " - " +
					"#{spell_stats[0]} " +
					"It costs #{spell_stats[4]} gold pieces\n"
				end
			puts "\nYou have #{@treasure} gold coins."
			puts "\nWhat would you like to purchase? Or would you rather [E]xit the shop?"
			choice = gets.chomp
			if choice.downcase == "e"
				puts "\nWell, lovely seeing you #{@name}! Stop by any time."
				valid_input = true
			elsif choice.to_i == 0 || choice.to_i > @unlearned_spells.length
				puts "Don't trifle with me, #{@name}! Choose a spell on offer!"
			else
				choice_index = choice.to_i
				choice_index -= 1
				spell_name = @unlearned_spells[choice_index]
				spell_stats = @master_spellbook[spell_name]
				if spell_stats[4] > @treasure
					puts "You can't afford that spell"
				else
					puts "\n'Excellent choice, #{@name}!' Madame Squeekendorf enthuses." 
					self.learn_spell(spell_stats[5])
					self.pay(spell_stats[4])
				end
			end
		end
	end

	def save_character
		db = SQLite3::Database.new("mouse_quest_save_data.db")
		create_table_cmd = <<-SQL
		CREATE TABLE IF NOT EXISTS save_character(
		  id INTEGER PRIMARY KEY,
		  name VARCHAR(100),
		  character_spellbook VARCHAR(500),
		  level INTEGER,
		  treasure INTEGER,
		  xp INTEGER
		)
		SQL
		db.execute(create_table_cmd)
		db.execute("INSERT OR REPLACE INTO save_character(id, name, character_spellbook, level, treasure, xp) VALUES (?, ?, ?, ?, ?, ?)", [@id, @name, @character_spellbook.to_s, @level, @treasure, @xp]) 
		puts "Your character #{@name} has been saved."
	end

	def take_damage(int)
		@health -= (int - rand(0..int))
	end
end


class Monster

	attr_reader :name, :level, :treasure, :xp, :attack_value, :attack_flavor_text
	attr_accessor :health

	def initialize(name, level, health, treasure, xp, attack_value,	attack_flavor_text)
		@name = name
		@level = level
		@treasure = treasure
		@health = health + (level * 2)
		@treasure = rand(1..treasure) * level
		@xp = (xp * level) - rand(1..xp)
		@attack_value = attack_value + level
		@attack_flavor_text = attack_flavor_text
	end

	def take_damage(int)
		@health -= int + rand(0..int)
	end

end

#============= Method Declarations================

def character_death(current_character)
	puts "You died!!!!"
	play_again = true
	until play_again == false
		puts "\nWould you like to play again? [Y]es or [N]o?"
		choice = gets.chomp
			if choice.downcase == "y" 
				create_or_load = intro
					if create_or_load == "create_character"
						character_stats = create_character
					else
						character_stats = load_character
					end
				current_character = Character.new(*character_stats)
				cheesewright_inn(current_character)
			elsif choice.downcase == "n"
				puts "\nGoodbye #{current_character.name}! You were a brave and valiant mouse.\n"
				exit
			else puts "\nI'm sorry, I didn't understand that."
			end
		end
end

def combat(current_character, current_monster)
	victory = false
	until victory == true
		puts "\nYou have #{current_character.health} hit points. The #{current_monster.name} has #{current_monster.health}."
		puts "\nWould you like to cast a [S]pell or try to [R]un away?"
		choice = gets.chomp
		if choice.downcase == "r"
			escape_probability = rand(1..10)
			if escape_probability > 5
				puts "\nYou manage to escape the #{current_monster.name} by the skin of your teeth."
				move(current_character)
			else puts "\nOh no! The #{current_monster.name} catches you!"
				current_character.take_damage(current_monster.attack_value)
				if current_character.health <= 0
					character_death(current_character)
				end
			end
		elsif choice.downcase == "s"
			valid_input = false
			until valid_input == true
				puts "\nWhat spell would you like to cast?"
				current_character.character_spellbook.each do |spell|
					puts (current_character.character_spellbook.index(spell) + 1).to_s + ". " + spell 
				end
				spell_choice = gets.chomp
				spell_choice = spell_choice.to_i - 1
				if spell_choice < current_character.character_spellbook.length && spell_choice >= 0
					puts "\nYou cast #{current_character.character_spellbook[spell_choice]} at the #{current_monster.name}."
					spell_name = current_character.character_spellbook[spell_choice]
					spell_stats = current_character.master_spellbook[spell_name]
					puts spell_stats[1]
					current_monster.take_damage(spell_stats[2])
					current_character.heal(spell_stats[3])
					puts "\nYou currently have #{current_character.health} hit points. The #{current_monster.name} has #{current_monster.health} hit points."
						if current_monster.health <= 0
							puts "\nYou have slain the #{current_monster.name}."
							victory = true
							combat_resolution(current_character, current_monster)
						elsif current_character.health <= 0
							character_death(current_character)
						else 
							valid_input = true
						end
				else
					puts "\nI'm sorry, I don't understand which spell you're trying to cast."
				end
			end
		else puts "\nI'm sorry, I know it's scary, but if you don't enter a real choice, you forfeit your turn."
		end
		puts "\nThe #{current_monster.name} #{current_monster.attack_flavor_text}"
		current_character.take_damage(current_monster.attack_value)
		if current_character.health <= 0
			character_death(current_character)
		end
	end
end


def combat_resolution(current_character, current_monster)
	current_character.gain_xp(current_monster.xp)
		puts "\nYou gain #{current_monster.xp} experience points."
	current_character.gain_treasure(current_monster.treasure)
		puts "You find #{current_monster.treasure} pieces of gold on the body of the #{current_monster.name}."
	    puts "You now have #{current_character.treasure} pieces of gold and have #{current_character.xp} points of experience."
	move(current_character)
end
def create_character
	puts "\nWhat is the name of the mouse you would like to create?" + "\n\n"
	character_name = gets.chomp
	valid_input = false
	until valid_input == TRUE
		puts "\nWhich spell would you like to start #{character_name} off with?" + "\n\n" +
		     "  1. Firewhiskers - This spell will scorch your enemies with blazing tendrils of flame, \n" +
		     "     but will singe you at the same time.\n" +
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
    db = SQLite3::Database.new("mouse_quest_save_data.db")
    id_array = db.execute("SELECT MAX(id) FROM save_character")
    id = id_array[0][0]
    id = id.to_i
    id += 1
	character_stats = [id, character_name, ["Arcane Shopping Spree", "Camembert's Sorcerous Habedashery", spell_choice], 1, 0, 0]
	character_stats
end

def continue(current_character)
	valid_input = false
	until valid_input == true
		puts "\nWould you like to continue your adventure? [Y]es or [N]o?"
    	choice = gets.chomp
    	if choice.downcase == "n"
			puts "\nGoodbye #{current_character.name}! You were a brave and valiant mouse.\n"
			exit
		elsif choice.downcase == "y"
			puts "\nExcellent! On to the adventure!!!"
			valid_input = true
		else 
			puts "\nI'm sorry, I didn't understand that."
    	end
    end
end


def cheesewright_inn(current_character)

	puts "\nThe Cheesewright Inn is a cheerful place, full of warmth, clean beds, \n" +
         "and the best blue-veined Wenslydale to be found in the whole Forest. The \n" +
         "proprieter, Sam Butterwhiskers, waves to you as you enter. 'Ah, #{current_character.name}!\n" +
         "Good to see you again!'"
    valid_input = false
	until valid_input == TRUE
    	puts "\nNow, are you hoping to [R]est here for a while, or were you going to [V]enture forth?"
    	answer = gets.chomp
    	if answer.downcase == "r"
    		puts "\nWell now, help yourself to one of the beds upstairs. I'm sure you'll \n" +
    		     "feel better once you've slept a bit.\n\n"
    		current_character.heal(10)
    		current_character.save_character
    		continue(current_character)
    		puts "\nAfter a short rest, you feel fit as a fiddle. Sam is delighted to see \n" +
    		     "you as you walk back down to the Common Room. 'Ah, #{current_character.name}!' \n" +
    		     "Sam beams at you, 'You look ten times the mouse you did before.'\n" 
    		valid_input = false
    	elsif answer.downcase == "v"
    		puts "\nSam chuckles. 'Well then, good luck my brave little friend,' and waves \n" +
    			 "as you exit the inn.\n"
    			  valid_input = true
    			  move(current_character)
    	else puts "\n'Eh?!? Speak up! I didn't understand a word of that.'\n"
    		 valid_input = false
    	end
    end
end

def forest_map(current_character)
	map_array = [
		["*", "*", "*", "*", "*"], 
		["4", "*", "*", "*", "*"], 
		["*", "*", "1", "*", "*"], 
		["*", "3", "*", "*", "*"], 
		["*", "*", "*", "2", "*"]
	]

	x_axis = current_character.location[0]
	y_axis = current_character.location[1]
	
	if x_axis.abs > 2 || y_axis.abs > 2
		puts "You're off the map!!!! Lost in the Tanglewood Swamp!" 
		gets
		move(current_character)
	else
		map_array[(y_axis + 3) * -1].to_a[(x_axis + 2)] = "X"

		puts "\nMAP OF THE FOREST" +
		     "\n================="
		map_array.each {|location| puts location.join("   ") }
		puts "\nX. Your current location" +
			 "\n1. The Cheesewright Inn" +
		     "\n2. Madame Squeekendorf's House of Wonders" +
		     "\n3. The Peddler's Wagon" +
		     "\n4. The Dead Oak\n" +
		     "\nPress any key to exit" 
		gets
		move(current_character)
	end
end

def intro
# Initiate Database 
	db = SQLite3::Database.new("mouse_quest_save_data.db")
	create_table_cmd = <<-SQL
	CREATE TABLE IF NOT EXISTS save_character(
		 id INTEGER PRIMARY KEY,
		 name VARCHAR(100),
		 character_spellbook VARCHAR(500),
		 level INTEGER,
		 treasure INTEGER,
		 xp INTEGER
		)
		SQL
	db.execute(create_table_cmd)

	puts "\nWelcome brave adventurer! For many years the Old Forest and all the gentle Mouse-folk" +
		 "\nwho live in it have been terrorized by roving bands of brigands and beasts. Dark" +
		 "\ntimes indeed for the peaceful inhabitants of the woods! But there is a legend," +
		 "\nwhispered about from mouse to mouse, that there exists a hidden tower somewhere" +
		 "\nlost in the forest depths. And inside that tower, is the most potent arcane artifact" +
		 "\never created by the Cheese Wizards of old, the Sacred Stilton!" + "\n" +
		 "\nYou are a just a pipsqueek of a sorcerer's apprentice, small even by mouse standards," +
		 "\nwith only a few minor cantrips in your spellbook. But bravery knows no size! You have" +
		 "\nset out on a quest to retrieve the Sacred Stilton and save the people of the Old Forest!" +
		 "\nAdventure awaits..."

	valid_input = FALSE
	until valid_input == TRUE
		puts "\nWould you like to [C]reate a character, [L]oad a character, or [D]elete a saved character?" + "\n\n" 
		answer = gets.chomp
		if answer.downcase == "c"
			valid_input = TRUE
			return "create_character"
		elsif answer.downcase == "l" && db.execute("SELECT * FROM save_character") == []
			puts "You don't have any saved characters."
		elsif answer.downcase == "d" && db.execute("SELECT * FROM save_character") == []
			puts "You don't have any saved characters to delete."
		elsif answer.downcase == "d" 
			puts "Which saved character would you like to delete?\n"
			id = db.execute("SELECT id FROM save_character")
			name = db.execute("SELECT name FROM save_character")
			puts id.zip(name).join(" ")
			answer = gets.chomp
			if answer.to_i == 0 || db.execute("SELECT * FROM save_character WHERE id='#{answer.to_i}'") == []
				puts "I'm sorry, I didn't undersand you. Pick a valid number"
			else
				deleted_character_name = db.execute("SELECT name FROM save_character WHERE id='#{answer.to_i}'")
				character_array = db.execute("DELETE FROM save_character WHERE id='#{answer.to_i}'")
				puts "The record for #{deleted_character_name[0][0]} has been deleted."
			end
		elsif answer.downcase == "l"
			valid_input = TRUE
			return "load_character"
		else 
			puts "\nI'm sorry, I didn't understand that. Please enter a valid input."
		end
	end
end


def load_character
	valid_input = false
	until valid_input == true
		db = SQLite3::Database.new("mouse_quest_save_data.db")
		puts "Which character would you like to load?"

		id = db.execute("SELECT id FROM save_character")
		name = db.execute("SELECT name FROM save_character")
		puts id.zip(name).join(" ")
		answer = gets.chomp

		if answer.to_i == 0 || answer.to_i > id.length
			puts "I'm sorry, I didn't undersand you. Pick a valid number"
		else
			valid_input = true
			character_array = db.execute("SELECT * FROM save_character WHERE id='#{answer.to_i}'")
		    character_stats = character_array[0] 
		    character_spellbook = character_stats[2].split(", ")
		    character_spellbook.map! {|word| word.delete('"[]')}
		    character_stats[2] = character_spellbook
		    return character_stats
		end
	end
end

def move(current_character)
	valid_input = false
	x_axis = current_character.location[0]
	y_axis = current_character.location[1]
	until valid_input == TRUE
		puts "\nWould you like to travel [N]orth, [E]ast, [S]outh, [W]est, look at the [M]ap, or [Q]uit?\n"
		answer = gets.chomp
		if answer.downcase == "n"
			puts "\nYou travel north..."
			current_character.location[1] = y_axis + 1
			valid_input = true
		elsif answer.downcase == "e"
			puts "\nYou travel east..."
			current_character.location[0] = x_axis + 1
			valid_input = true
		elsif answer.downcase == "s"
			puts "\nYou travel south..."
			current_character.location[1] = y_axis - 1
			valid_input = true
		elsif answer.downcase == "w"
			puts "\nYou travel west..."
			current_character.location[0] = x_axis - 1	
			valid_input = true	
		elsif answer.downcase == "m"
			forest_map(current_character)
		elsif answer.downcase == "q"
			puts "Are you sure you want to quit? [Y]es or [N]o?"
			quit_answer = gets.chomp
				if quit_answer.downcase == "y"
			  		puts "\nGoodbye #{current_character.name}! You were a brave and valiant mouse.\n"
					exit
				else
					puts "The adventure continues!!!"
					valid_input = false
				end
		else puts "\nThat's not a valid direction!"
			valid_input = false
		end
	end
	new_location(current_character)
end


def new_location(current_character)
	forest_map = {
	[0,1]  => [1, "\nYou come upon a cheerful glade in the forest. Wildflowers bloom in \nthe dappled sunlight. You detect the faint smell of cheese to the South.\n"],
	[0,2]  => [2, "\nYou creep into a silent stretch of the woods. Even the crickets have \nstopped chirping here. You shudder. There might be owls about.\n"],
	[0,-1] => [1, "\nYou cross a lovely babbling brook. Robins are singing in the trees \nand you can hear the sound of faint laughter drifting on the wind \nfrom the North, and the scent of woodsmoke from the East.\n"],
	[0,-2] => [2, "\nYou spy an enormous elm tree, and high in it's branches, squirrels \nhave built a tidy little cottage. Woodsmoke drifts up from its \nchimney. But however loud you call up to them, no one answers.\n"],
	[1,0]  => [0, "\nThe sight of a tumbledown old cottage greets you as you round the \nbend. It's owner, a grey-whiskered old mouse is sitting on the \nporch, whistling a tune. He tips his hat to you as you \npass. You can see a well-trodden path to the West.\n"],
	[1,1]  => [1, "\nYou find yourself in a mossy dell, shaded with giant ferns that \ngrow thick and verdant. A cool mist hangs in the air, and you \nthink you can catch glimpses of something darting through the ferns.\n"],
	[1,2]  => [2, "\nThis is a dark stretch of the forest. The ferns have grown to  \ngargantuan proportions, choking out the sunlight. A flint-eyed raven \nsits staring in the darkness at you.\n"],
	[1,-1] => [1, "\nYou cross a merry little stream, glinting in the sunlight. And you \nthink you can make out, almost playing a countermelody stream \nthe faint strains of a tin whistle coming from the South.\n"],
	[2,0]  => [2, "\nA broken tower pokes its head out of the tangled briars and fallen \nleaves. It looks old beyond reckoning, the cracked stones riddled \nwith lichen. You can't imagine what could have caused it to fall.\n"],
	[2,1]  => [2, "\nYou wander into an area of the forest still ravaged by a recent \nwildfire. Blackened stumps have given way to scrub brush and a tangle \nof new vines, coiling up out of the blackened husks of great trees.\n"],
	[2,2]  => [0, "\nYou find a clear and still pool of water, shining like a mirror  \nin the midday sun. There seems to be some sort of crumbled \nstatuary scattered in the depths. You can make out a stone \nhand, with what look to be talons, reaching out towards the surface.\n"],
	[2,-1] => [1, "\nA reed-lined lake stands before you, emptying into a little stream  \nto the west. A pair of otters are playing chess out on the \nwater, with the board balanced between their upturned \nbellies. You wave hello and when the wave back, the whole game tumbles into the deep.\n"],
	[2,-2] => [3, "\nCreeping through the underbrush, you spy a silent glade with a \na fairy circle of mushrooms growing in a ring. But on closer \ninspection, the mushrooms turn out to be toadstools, and they \nsend the fur on the back of your neck straight up when you \ntouch them. You hear the faint melody of a tin whistle to the West.\n"],
	[-1,0] => [1, "\nThe path winds its way through the trees until you see a small \nsign nailed to a tree, painted with neat red letters, that \nthat reads 'Second Mouse Gets The Cheese.' Words to live by, \nyou suppose. Speaking of cheese, you detect the rich odor of \nblue-veined Wenslydale from the East. You also see a curl of \nwoodsmoke to the South.\n"],
	[-1,1] => [1, "\nA chorus of magpies clatteres and caws madly in the trees. You try \nthe birds are getting so worked up about, but when you ask \nthem, they just titter 'It's coming!!! It's coming!!!!' with \na distinct air of malice.\n"],
	[-1,2] => [0, "\nYou come across a sleeping fawn, bedded down in a circle of fallen \nleaves. The shadows of the Tanglewood Swamp leer in from \nthe north, but this place seems strangely peaceful.\n"],
	[-1,-2]=> [2, "\nYou enter into a glade with a stone well rising up from the matted \nmoss and leaves of the forest floor. There's no bucket or \nrope left, and when you drop a pebble in it takes a full \nminute before you can hear a faint splash.\n"],
	[-2, 0]=> [2, "\nScattered across the forest floor are hundreds upon thousands of \ngrey moths, covering everything like a twitching woolen blanket. \nThey seem to be clustered thickest around a large shape \nin the middle of the glade, but you can't make out exactly what it is under there.\n"],
	[-2, 1]=> [2, "\nA vast and scraggly dead oak stands alone in a clearing in the forest, \nit's massive bare branches creaking in the gentle breeze.\n"],
	[-2, 2]=> [3, "\nYou come upon a dense thicket of willow trees, greedily thrusting their \nroots into the swampy soil. You can smell the bogs and rotting \nvines of the Tanglewood Swamp close by.\n"],
	[-2,-1]=> [2, "\nA sweet little rivulet empties into the swamps to the west. But upstream, \nto the east, you see a column of woodsmoke that speaks of \na cozy fireplace and warm food.\n"],
	[-2,-2]=> [3, "\nNothing in this stretch of forest seems to be moving at all, although \nthe breeze has picked up. It's almost as if the trees were made \nof iron and cunningly painted to disguise their dead, frozen nature.\n"],
	"tanglewood" => [3, "\nYou find yourself lost in a dismal stretch of Tanglewood Swamp. \nSerptine vines coil themselves around the sickly, twisted trees. \nA heavy sense of unease hangs in the air.\n"]
	}

	if current_character.location == [0,0]
		cheesewright_inn(current_character)
	elsif current_character.location == [-5,1]
		tower(current_character)
	elsif current_character.location == [1,-2]
		witches_hut(current_character)
	elsif current_character.location == [-1,-1]
		peddlar(current_character)
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

def peddlar(current_character)
	puts "\nStumbling into a clearing, you see a merry little campfire sending up a fragrant" +
	     "\ncolumn of woodsmoke. Beside it is a brightly painted caravan, and no sooner do you" +
	     "\nenter into the light of the fire than an aged chipmunk steps out of the wagon. 'Hello!'" +
	     "\nhe says, 'Make yourself comfortable, friend. I'm a peddlar, but the only stock I have is" +
	     "\ninformation. I know where a secret treasure is hidden, but you'll have to cross my palm" +
	     "\nwith gold to get me to tell!'\n" + 
	     "\nIt will cost you perfectly reasonable 500 gold pieces."
	valid_input = false
	until valid_input == true
	    puts "\nIs it a deal? [Y]es or [N]o?"
		answer = gets.chomp
		if answer.downcase == "y"
			if current_character.treasure < 500
				puts "'Gah!!! You don't even have the coin to buy this information with. Come back when you're richer."
				valid_input = true
			else
				puts "\n'The treasure lies three leagues west of the Dead Oak. Fare thee well, traveler!'"
				current_character.pay(500)
				valid_input = true
			end
		elsif answer.downcase == "n"
			puts "\n'Well then, stranger. Your loss! But come again any time. Now if you'll excuse me...'"
			valid_input = true
		else
			puts "\nEh?!?!! I didn't understand that one bit."
		end
	end
	move(current_character)
end



def random_monster(level, current_character)
	monster_library = {
		1 => ["Black Adder", 3, 5, 50, 50, 4, "bites you with his poison fangs"],
		2 => ["Red Weasel", 1, 2, 25, 25, 2, "slashes at you with a dagger"],
		3 => ["Wharf Rat", 2, 3, 80, 35, 4, "hacks at you with a cutlass"],
		4 => ["Sewer Rat", 3, 1, 10, 35, 3, "swings a club at you"],
		5 => ["Fiendish Stoat", 1, 4, 50, 35, 3, "stabs at you with a rapier"], 
		6 => ["One-Eyed Tomcat", 3, 6, 100, 100, 6, "bats at you with his massive paws"],
		7 => ["Common Raven", 1, 2, 10, 10, 1, "stabs at you with his crooked beak"], 
		8 => ["Evil Churchmouse", 1, 2, 80, 20, 1, "swings at you with an axe"],
	}
	encounter_probability = level * rand(1..3)
	if encounter_probability < 3
		move(current_character)	
	else
		monster_selector = rand(1..monster_library.length)
		monster_stats = monster_library[monster_selector.to_i]
		current_monster = Monster.new(*monster_stats)
		puts "\nA #{current_monster.name} leaps at you from the forest."
		combat(current_character, current_monster)
	end
end

def tower(current_character)
	puts "\nStumbling through the endless vines and treacherous bogs of the Tanglewood" +
	     "\nSwamp, you see a tower rising up from verdant undergrowth. This must be the" +
	     "\nplace! The Tower of the Sacred Stilton!!! But there doesn't seem to be a door." +
	     "\nIf only there were some magical means of ingress..."
	if current_character.character_spellbook.include? "Magical Mouse Door"
		puts "\nAha!!! That's it!!! The Magical Mouse Door Spell!!!! Press any key to cast it."
		gets.chomp
		puts "\nA magical hole appears in the side of the tower. You can smell the heavenly" +
		     "\naroma of the most potent acrane cheese known to Mousedom, the Sacred Stilton!" +
		     "\nYour quest is victorious!!!! Congratulations #{current_character.name}! Your" +
		     "\nname will go down in Mousey History!!!!" +
		     "\n" + "\nTHE END"
		exit
	else
		move(current_character)
	end
end

def witches_hut(current_character)
	puts "\nYou come across a curious structure. It appears to be a house standing on\n" + 
	     "a giant chicken's foot. It's the home of Madame Squeekendorf, Mistress of\n" +
	     "Magics! The front door is flung wide open, and the Madame squeeks in delight\n" +
	     "as she see's you approach. 'Ah #{current_character.name}! So good to see you!'\n" +
	     "\n'I have spells for sale! I can teach you any of these, for a price.'\n"
	current_character.spell_store
	move(current_character)
end



#============= OLD DRIVER CODE ================

# ed = Character.new("Ed", ["fireball", "featherfall"], 2, 100, 15)

# puts ed.character_spellbook[0]

# black_adder = Monster.new("black_adder", 2, 5, 50, 50, 4, "bites you with his poison fangs")

# puts "the health is #{black_adder.health}"
# puts "the treasure is #{black_adder.treasure}"
# puts "the xp is #{black_adder.xp}"
# puts "the attack value is #{black_adder.attack_value}"


#============= CURRENT DRIVER CODE ================

create_or_load = intro
	if create_or_load == "create_character"
		character_stats = create_character
	else
		character_stats = load_character
	end
current_character = Character.new(*character_stats)
cheesewright_inn(current_character)

