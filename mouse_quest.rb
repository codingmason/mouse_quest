=begin
	
========= CLASSES =========

*** Character Class ***






========= DATABASES =========





========= METHODS =========

*** Intro Method ***

	-PUTS text explaining the quest
	-UNTIL correct input is TRUE
		-Ask if the user would like to load a character or create a character
			-IF Load, run Load Character Method. Correct input is TRUE
			-IF Create, run Create Character Method. Correct input is TRUE
			-IF ELSE, PUTS an 'I didn't understand that' message. Correct input is FALSE

*** Create Character Method ***

	-PUTS a question asking for a character name
	-GETS the response. Assign as a variable 'character name'
	-PUTS a question asking if they would prefer a rapier and buckler or a greatsword
	-GETS the response. Assign as a variable 'current weapon'
	-CREATE an instance of the Character Class, assigning the character name and current weapon
	-Query SQLite to to add Character information to the Saved Characters database

*** Load Character Method ***

	-Query SQLite to PUTS names of saved characters and their primary keys 
	-Ask the player to choose 






	
=end