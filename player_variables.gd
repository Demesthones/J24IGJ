extends Node

signal _on_motivation_half
signal _on_funds_half
signal _on_hundred_words
signal _on_kitty_needs_attention
signal _on_thousand_words


var resources = {
	"funds": 10000,
	"fps": -1,
	"wordCount": 0,
	"wps": 5,
	"wca": 1,
	"deadlineAmount": 0,
	"dps": 5,
	"motivation": 100,
	"mps": -5,
	"tmps": 0,
	"roadblock": false,
	"coffee": {
		"count": 0,
		"cost": -5,
		"motivationGain": 25,
		"amount": 0,
		"aps": -2
	},
	"kitty": {
		"cost": -300,
		"motivationGain": 1,
		"relationshipLevel": 0,
		"attentionLevel": 100,
		"aps": -1,
		"pet": {
			"count": 0,
			"motivationGain": 50,
			"attentionGain": 33
		}
	},
	"textPreview": {
		"wordAmount": 0
	},
	"ghostWriter": {
		"wps": .3
	},
	"job": {
		"pay": 1
	},
	"secondWritingJob": {
		"payPerWord": 1
	}
}
var upgrades = {
	"kitty": false,
	"coffeeSetup": false,
	"textPreview": false,
	"ghostWriter": false,
	"job": false,
	"secondWritingJob": false
}

var flags = {
	"coffeeActive": false,
	"coffeMachineActive": false,
	"hundredWords": false,
	"jobActive": false,
	"ghostWriterActive": false
}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func updateResources():
	resources.funds += resources.fps
	resources.wordCount += resources.wps
	if(upgrades.ghostWriter):
		resources.wordCount += resources.ghostWriter.wps
	resources.motivation = clamp(resources.motivation + resources.mps, 0, 100)
	if(resources.motivation == 0):
		resources.tmps = resources.mps
		resources.mps = 0
	resources.deadlineAmount += resources.dps
	
	if(upgrades.kitty):
		resources.kitty.attentionLevel += resources.kitty.aps
		resources.motivation = clamp(resources.motivation + resources.kitty.motivationGain, 0, 100)
	if(resources.coffee.amount > 0):
		resources.coffee.amount += resources.coffee.aps
	if(upgrades.job):
		resources.funds += resources.job.pay
	
	sendEmitters()

func sendEmitters():
	if(!PlayerVariables.flags.coffeeActive && PlayerVariables.resources.motivation < 50):
		PlayerVariables.flags.coffeeACtive = true
		_on_motivation_half.emit()
	if(!PlayerVariables.flags.hundredWords && PlayerVariables.resources.wordCount > 100):
		PlayerVariables.flags.hundredWords = true
		_on_hundred_words.emit()
	if(PlayerVariables.resources.funds < 5000):
		_on_funds_half.emit()
	if(!PlayerVariables.flags.ghostWriterActive && PlayerVariables.resources.wordCount > 1000):
		_on_thousand_words.emit()
		
	

