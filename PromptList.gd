extends Node

var words = [
	"test",
	"alpha",
	"bravo",
	"charlie",
	"delta",
	"echo",
	"foxtrot"
]
var special_characters = [
	".",
	",",
	"?",
	"!"
]

func get_prompt() -> String:
	var word_index = randi() % words.size()
	var word = words[word_index]
	
	#if randi() % 10+1 == 10:
	#	word = word.substr(0, 1).to_upper() + word.substr(1)
	#if randi() % 10+1 == 10:
	#	word = word + special_characters[randi() % 4]
	
	return word
