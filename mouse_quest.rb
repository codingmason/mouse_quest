
#============= Require Statements ================#

require 'sqlite3'
require 'faker'

#============= Class Declarations================#
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
			"Furball Fireball" => ["This spell causes a gigantic sphere of flaming mice to appear and roll \nover your enemies.", "\nSummoning a giant ball of flaming fur, you hurl the fiery sphere at your foe.", 5, 0, 500, "Furball Fireball"] ,
     	"Ice Mice" => ["This spell causes a swarm of spectral Frost Mice to appear, who will cut your \nfoes to ribbons.", "\nA wintry wind fills the air as a swarm of spectral Frost Mice pounce on your enemy", 5, 0, 500, "Ice Mice"],
     	"Magical Mouse Door" => ["This spell can cause a mystical opening to appear, allowing access \nto the most impregnable places.", "\nA hole appears underneath your foe, twisting his ankle viciously", 2, 0, 1000, "Magical Mouse Door"]
     	}
	end

# Adds hit points to character and sets maximum allowed by character's level
	def heal(int)
		@health += int 
		if @health > (@level + 9)
		   @health = (@level + 9)
		end
	end

# Adds treasure to character
	def gain_treasure(int)
		@treasure += int
	end

# Adds experience points to character and levels character up
	def gain_xp(int)
		@xp += int
		new_level = (@xp * 0.01) + 1
		if new_level.floor > @level
			@level = new_level.floor
			puts "\nYou are now level #{@level}"
		else
		end
	end

# Adds new spell to character's spellbook
	def learn_spell(new_spell)
		@character_spellbook << new_spell
		@unlearned_spells = @unlearned_spells - @character_spellbook
		puts "\nYou just learned how to cast #{new_spell}"
	end

# Subtracts from character's treasure
	def pay(amount)
		@treasure -= amount
		puts "You now have #{@treasure} gold pieces.\n"
	end


# Saves character
	def save_character
		db = SQLite3::Database.new("save_data.db")
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

# Subtracts a random amount of hit points based on the monster's level
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

# Subtracts a random amount of hit points based on the character's level
	def take_damage(int)
		@health -= int + rand(0..int)
	end

end

#============= Method Declarations================

# Script for when a character dies
def character_death(character)
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
				character = Character.new(*character_stats)
				cheesewright_inn(character)
			elsif choice.downcase == "n"
				puts "\nGoodbye #{character.name}! You were a brave and valiant mouse.\n\n"
				exit
			else puts "\nI'm sorry, I didn't understand that."
			end
		end
end

# Script for the initial location of the character as well as the place 
# in the game where you can rest, heal, and save your character.
def cheesewright_inn(character)

	puts "\nThe Cheesewright Inn is a cheerful place, full of warmth, clean beds, \n" +
         "and the best blue-veined Wenslydale to be found in the whole Forest. The \n" +
         "proprieter, Sam Butterwhiskers, waves to you as you enter. 'Ah, #{character.name}!\n" +
         "Good to see you again!'"
    valid_input = false
	until valid_input == TRUE
    	puts "\nNow, are you hoping to [R]est here for a while, or were you going to [V]enture forth?\n\n"
    	answer = gets.chomp
    	if answer.downcase == "r"
    		puts "\nWell now, help yourself to one of the beds upstairs. I'm sure you'll \n" +
    		     "feel better once you've slept a bit.\n\n"
    		character.heal(10)
    		character.save_character
    		puts "After resting, you now have #{character.health} hit points."
    		continue(character)
    		puts "\nAfter a short nap, you feel fit as a fiddle. Sam is delighted to see \n" +
    		     "you as you walk back down to the Common Room. 'Ah, #{character.name}!' \n" +
    		     "Sam beams at you, 'You look ten times the mouse you did before.'\n" 
    		valid_input = false
    	elsif answer.downcase == "v"
    		puts "\nSam chuckles. 'Well then, good luck my brave little friend,' and waves \n" +
    			 "as you exit the inn.\n"
    			  valid_input = true
    			  move(character)
    	else puts "\n'Eh?!? Speak up! I didn't understand a word of that.'\n"
    		 valid_input = false
    	end
    end
end

# Method for combating monsters using spells
def combat(character, current_monster)
	victory = false
	until victory == true
		puts "\nYou have #{character.health} hit points. The #{current_monster.name} has #{current_monster.health}."
		puts "\nWould you like to cast a [S]pell or try to [R]un away?"
		choice = gets.chomp
		if choice.downcase == "r"
			escape_probability = rand(1..10)
			if escape_probability > 5
				puts "\nYou manage to escape the #{current_monster.name} by the skin of your teeth."
				move(character)
			else puts "\nOh no! The #{current_monster.name} catches you!"
				character.take_damage(current_monster.attack_value)
				if character.health <= 0
					character_death(character)
				end
			end
		elsif choice.downcase == "s"
			valid_input = false
			until valid_input == true
				puts "\nWhat spell would you like to cast?"
				character.character_spellbook.each do |spell|
					puts (character.character_spellbook.index(spell) + 1).to_s + ". " + spell 
				end
				spell_choice = gets.chomp
				spell_choice = spell_choice.to_i - 1
				if spell_choice < character.character_spellbook.length && spell_choice >= 0
					puts "\nYou cast #{character.character_spellbook[spell_choice]} at the #{current_monster.name}."
					spell_name = character.character_spellbook[spell_choice]
					spell_stats = character.master_spellbook[spell_name]
					puts spell_stats[1]
					current_monster.take_damage(spell_stats[2])
					character.heal(spell_stats[3])
					puts "\nYou currently have #{character.health} hit points. The #{current_monster.name} has #{current_monster.health} hit points."
						if current_monster.health <= 0
							puts "\nYou have slain the #{current_monster.name}."
							victory = true
							combat_resolution(character, current_monster)
						elsif character.health <= 0
							character_death(character)
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
		character.take_damage(current_monster.attack_value)
		if character.health <= 0
			character_death(character)
		end
	end
end

# Method for resolving the effects of combat
def combat_resolution(character, current_monster)
	character.gain_xp(current_monster.xp)
		puts "\nYou gain #{current_monster.xp} experience points."
	character.gain_treasure(current_monster.treasure)
		puts "You find #{current_monster.treasure} pieces of gold on the body of the #{current_monster.name}."
	    puts "You now have #{character.treasure} pieces of gold and have #{character.xp} points of experience."
	move(character)
end

# Creates a new character
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
    db = SQLite3::Database.new("save_data.db")
    id_array = db.execute("SELECT MAX(id) FROM save_character")
    id = id_array[0][0]
    id = id.to_i
    id += 1
	character_stats = [id, character_name, ["Arcane Shopping Spree", "Camembert's Sorcerous Habedashery", spell_choice], 1, 0, 0]
	character_stats
end

# Offers the user a chance to resume play after saving
def continue(character)
	valid_input = false
	until valid_input == true
		puts "\nWould you like to continue your adventure? [Y]es or [N]o?"
    	choice = gets.chomp
    	if choice.downcase == "n"
			puts "\nGoodbye #{character.name}! You were a brave and valiant mouse.\n\n"
			exit
		elsif choice.downcase == "y"
			puts "\nExcellent! On to the adventure!!!"
			valid_input = true
		else 
			puts "\nI'm sorry, I didn't understand that."
    	end
    end
end

# Keeps track of the character's location and displays a map of the forest
def forest_map(character)
	map_array = [
		["*", "*", "*", "*", "*"], 
		["4", "*", "*", "*", "*"], 
		["*", "*", "1", "*", "*"], 
		["*", "3", "*", "*", "*"], 
		["*", "*", "*", "2", "*"]]
	x_axis = character.location[0]
	y_axis = character.location[1]
	if x_axis.abs > 2 || y_axis.abs > 2
		puts "You're off the map!!!! Lost in the Tanglewood Swamp! Now, if only you could remember" +
			"\nhow you got here, maybe you could back-track." 
		gets
		move(character)
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
		move(character)
	end
end

# Displays intro text and allows users to create, load, or delete a character
def intro
	db = SQLite3::Database.new("save_data.db")
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

# Loads an existing character
def load_character
	valid_input = false
	until valid_input == true
		db = SQLite3::Database.new("save_data.db")
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

# Changes the character's location
def move(character)
	valid_input = false
	x_axis = character.location[0]
	y_axis = character.location[1]
	until valid_input == TRUE
		puts "\nWould you like to travel [N]orth, [E]ast, [S]outh, [W]est, look at the [M]ap, or [Q]uit?\n"
		answer = gets.chomp
		if answer.downcase == "n"
			puts "\nYou travel north..."
			character.location[1] = y_axis + 1
			valid_input = true
		elsif answer.downcase == "e"
			puts "\nYou travel east..."
			character.location[0] = x_axis + 1
			valid_input = true
		elsif answer.downcase == "s"
			puts "\nYou travel south..."
			character.location[1] = y_axis - 1
			valid_input = true
		elsif answer.downcase == "w"
			puts "\nYou travel west..."
			character.location[0] = x_axis - 1	
			valid_input = true	
		elsif answer.downcase == "m"
			forest_map(character)
		elsif answer.downcase == "q"
			puts "Are you sure you want to quit? [Y]es or [N]o?"
			quit_answer = gets.chomp
				if quit_answer.downcase == "y"
			  		puts "\nGoodbye #{character.name}! You were a brave and valiant mouse.\n\n"
					exit
				else
					puts "The adventure continues!!!"
					valid_input = false
				end
		else puts "\nThat's not a valid direction!"
			valid_input = false
		end
	end
	new_location(character)
end

# Displays location information when a character enters a new place
def new_location(character)
	forest_map = {
	[0,1]  => [1, "\nYou come upon a cheerful glade in the forest. Wildflowers bloom in \nthe dappled sunlight. You detect the faint smell of cheese to the South.\n"],
	[0,2]  => [2, "\nYou creep into a silent stretch of the woods. Even the crickets have \nstopped chirping here. You shudder. There might be owls about.\n"],
	[0,-1] => [1, "\nYou cross a lovely babbling brook. Robins are singing in the trees \nand you can hear the sound of faint laughter drifting on the wind \nfrom the North, and the scent of woodsmoke from the East.\n"],
	[0,-2] => [2, "\nYou spy an enormous elm tree, and high in it's branches, squirrels \nhave built a tidy little cottage. Woodsmoke drifts up from its \nchimney. But however loud you call up to them, no one answers.\n"],
	[1,0]  => [0, "\nThe sight of a tumbledown old cottage greets you as you round the \nbend. It's owner, a grey-whiskered old mouse is sitting on the \nporch, whistling a tune. He tips his hat to you as you \npass. You can see a well-trodden path to the West.\n"],
	[1,1]  => [1, "\nYou find yourself in a mossy dell, shaded with giant ferns that \ngrow thick and verdant. A cool mist hangs in the air, and you \nthink you can catch glimpses of something darting through the ferns.\n"],
	[1,2]  => [2, "\nThis is a dark stretch of the forest. The ferns have grown to  \ngargantuan proportions, choking out the sunlight. A flint-eyed raven \nsits staring in the darkness at you.\n"],
	[1,-1] => [1, "\nYou cross a merry little stream, glinting in the sunlight. And you \nthink you can make out, almost playing a countermelody to the \nstream the faint strains of a tin whistle coming from the South.\n"],
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
	if character.location == [0,0]
		cheesewright_inn(character)
	elsif character.location == [-5,1]
		tower(character)
	elsif character.location == [1,-2]
		witches_hut(character)
	elsif character.location == [-1,-1]
		peddlar(character)
	elsif character.location[0].abs > 2 || character.location[1].abs > 2
		location = forest_map["tanglewood"]
		puts location[1]
		random_monster(location[0], character)
	else
		coordinates = character.location
		location = forest_map[coordinates] 
		puts location[1]
		random_monster(location[0], character)
	end 
end

# Script that plays out when visiting the Peddlers Camp. 
def peddlar(character)
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
			if character.treasure < 500
				puts "'Gah!!! You don't even have the coin to buy this information with. Come back when you're richer."
				valid_input = true
			else
				puts "\n'The treasure lies three leagues west of the Dead Oak. Fare thee well, traveler!'"
				character.pay(500)
				valid_input = true
			end
		elsif answer.downcase == "n"
			puts "\n'Well then, stranger. Your loss! But come again any time. Now if you'll excuse me...'"
			valid_input = true
		else
			puts "\nEh?!?!! I didn't understand that one bit."
		end
	end
	move(character)
end

# Generates a random monster for the player to encounter when moving to a new location
def random_monster(level, character)
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
		move(character)	
	else
		monster_selector = rand(1..monster_library.length)
		monster_stats = monster_library[monster_selector.to_i]
		current_monster = Monster.new(*monster_stats)
		puts "\nA #{current_monster.name} leaps at you from the forest."
		combat(character, current_monster)
	end
end

# Runs script for buying spells at the Witches Hut
def spell_store(character)
	valid_input = false
	until valid_input == true
		puts "\n**Available Spells**\n"
			character.unlearned_spells.each do |spell_name|
				spell_stats = character.master_spellbook[spell_name]
				puts (character.unlearned_spells.index(spell_name) + 1).to_s + ". " + spell_name + " - " +
				"#{spell_stats[0]} " +
				"It costs #{spell_stats[4]} gold pieces\n"
			end
		puts "\nYou have #{character.treasure} gold coins."
		puts "\nWhat would you like to purchase? Or would you rather [E]xit the shop?"
		choice = gets.chomp
		if choice.downcase == "e"
			puts "\nWell, lovely seeing you #{character.name}! Stop by any time."
			valid_input = true
		elsif choice.to_i == 0 || choice.to_i > character.unlearned_spells.length
			puts "Don't trifle with me, #{character.name}! Choose a spell on offer!"
		else
			choice_index = choice.to_i
			choice_index -= 1
			spell_name = character.unlearned_spells[choice_index]
			spell_stats = character.master_spellbook[spell_name]
			if spell_stats[4] > character.treasure
				puts "\nYou can't afford that spell!"
			else
				puts "\n'Excellent choice, #{character.name}!' Madame Squeekendorf enthuses." 
				character.learn_spell(spell_stats[5])
				character.pay(spell_stats[4])
			end
		end
	end
end

# Runs script for the Tower, the secret location the player is trying to find
def tower(character)
	puts "\nStumbling through the endless vines and treacherous bogs of the Tanglewood" +
	     "\nSwamp, you see a tower rising up from verdant undergrowth. This must be the" +
	     "\nplace! The Tower of the Sacred Stilton!!! But there doesn't seem to be a door." +
	     "\nIf only there were some magical means of ingress..."
	if character.character_spellbook.include? "Magical Mouse Door"
		puts "\nAha!!! That's it!!! The Magical Mouse Door Spell!!!! Press any key to cast it."
		gets.chomp
		puts "\nA magical hole appears in the side of the tower. You can smell the heavenly" +
		     "\naroma of the most potent acrane cheese known to Mousedom, the Sacred Stilton!" +
		     "\nYour quest is victorious!!!! Congratulations #{character.name}! Your" +
		     "\nname will go down in Mousey History!!!!" +
		     "\n" + "\nTHE END"
		exit
	else
		move(character)
	end
end

# Runs script for the Witches Hut
def witches_hut(character)
	puts "\nYou come across a curious structure. It appears to be a house standing on\n" + 
	     "a giant chicken's foot. It's the home of Madame Squeekendorf, Mistress of\n" +
	     "Magics! The front door is flung wide open, and the Madame squeeks in delight\n" +
	     "as she see's you approach. 'Ah #{character.name}! So good to see you!'\n" +
	     "\n'I have spells for sale! I can teach you any of these, for a price.'\n"
	spell_store(character)
	move(character)
end


#============= CURRENT DRIVER CODE ================

create_or_load = intro
	if create_or_load == "create_character"
		character_stats = create_character
	else
		character_stats = load_character
	end
character = Character.new(*character_stats)
cheesewright_inn(character)

