extends Node

signal _on_motivation_half
signal _on_funds_half
signal _on_hundred_words
<<<<<<< HEAD
signal _on_kitty_needs_attention
signal _on_five_hundred_words
signal _on_thousand_words
signal _gen_ghost_prompt
=======
signal _on_five_hundred_words
signal _on_thousand_words
signal _on_kitty_needs_attention
>>>>>>> bc110a8c2c5f8460d55e032ba88967ff3dfd31c1
signal _on_roadblock
signal _on_ten_coffees
signal _on_corruption_ten
signal _on_corruption_fourty
signal _on_corruption_ninety
<<<<<<< HEAD
=======
signal _on_publisher_offer
signal _on_deadline_increase_one


signal _gen_ghost_prompt
>>>>>>> bc110a8c2c5f8460d55e032ba88967ff3dfd31c1

var resources = {
	"funds": 10000,
	"fps": -1,
	"wordCount": 0,
	"wps": 5,
	"wca": 1,
	"deadlineAmount": 10,
	"dps": 5,
	"motivation": 100,
	"mps": -5,
	"tmps": 0,
	"roadblock": false,
<<<<<<< HEAD
=======
	"rps": {
		"fpsTotal": 0,
		"mpsTotal": 0,
		"cpsTotal": 0
	},
>>>>>>> bc110a8c2c5f8460d55e032ba88967ff3dfd31c1
	"coffee": {
		"count": 0,
		"cost": -5,
		"motivationGain": 25,
<<<<<<< HEAD
=======
		"mps": 1,
>>>>>>> bc110a8c2c5f8460d55e032ba88967ff3dfd31c1
		"amount": 0,
		"aps": -2
	},
	"coffeeMachine": {
		"count": 0,
		"cost": -500,
		"fps": -1,
		"aps": .25
	},
	"kitty": {
		"cost": -300,
		"fps": -1,
<<<<<<< HEAD
		"motivationGain": 1,
=======
		"mps": 1,
>>>>>>> bc110a8c2c5f8460d55e032ba88967ff3dfd31c1
		"count": 0,
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
		"cost": -500,
		"fps": -1,
		"level": 0,
		"wps": .2,
		"currentWordCount": 0,
		"corruption": 0,
		"cps": .01
	},
	"job": {
		"pay": 1,
		"level": 0
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
<<<<<<< HEAD
	"coffeeActive": false,
	"coffeeMachineActive": false,
	"hundredWords": false,
	"jobActive": false,
	"ghostWriterActive": false,
	"kittyActive": false,
	"corruptionStageOne": false,
	"corruptionStageTwo": false,
	"corruptionStageThree": false
=======
	"currentRoadblockSent": false,
	"coffeeActive": false,
	"coffeeMachineActive": false,
	"hundredWords": false,
	"fiveHundredWords": false,
	"thousandWords": false,
	"jobActive": false,
	"corruptionStageOne": false,
	"corruptionStageTwo": false,
	"corruptionStageThree": false,
	"publisherOffer": false,
	"deadlineIncrease1": false
>>>>>>> bc110a8c2c5f8460d55e032ba88967ff3dfd31c1
}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func updateResources():
<<<<<<< HEAD
	resources.funds += resources.fps
	resources.wordCount += resources.wps
	resources.deadlineAmount += resources.dps
	

	if(!resources.roadblock):
		resources.motivation = clamp(resources.motivation + resources.mps, 0, 100)
	if(resources.motivation == 0):
		resources.roadblock = true
	
	
	if(upgrades.kitty):
		resources.kitty.attentionLevel += resources.kitty.aps
		resources.kitty.attentionLevel = clamp(resources.kitty.attentionLevel + randi_range(-25,25), 0, 100)
		resources.motivation = clamp(resources.motivation + resources.kitty.motivationGain, 0, 100)
=======
	
	resources.rps.fpsTotal = resources.fps
	resources.rps.mpsTotal = resources.mps
	resources.rps.cpsTotal = resources.coffee.aps
	
	
	resources.deadlineAmount += resources.dps
	resources.funds += resources.fps
	
	
	if(!resources.roadblock):
		resources.rps.mpsTotal = resources.mps
		resources.motivation = clamp(resources.motivation + resources.mps, 0, 100)
		resources.wordCount += resources.wps
	if(resources.motivation == 0):
		resources.rps.mpsTotal = 0
		resources.roadblock = true
		
	
	if(upgrades.kitty):
		resources.rps.mpsTotal += resources.kitty.mps
		resources.rps.fpsTotal += resources.kitty.fps
		resources.kitty.attentionLevel += resources.kitty.aps
		resources.kitty.attentionLevel = clamp(resources.kitty.attentionLevel + randi_range(-25,25), 0, 100)
		resources.motivation = clamp(resources.motivation + resources.kitty.mps, 0, 100)
>>>>>>> bc110a8c2c5f8460d55e032ba88967ff3dfd31c1
		resources.funds += resources.kitty.fps
		if(resources.kitty.attentionLevel <= 0):
			_on_kitty_needs_attention.emit()
		
		
	if(resources.coffee.amount > 0):
<<<<<<< HEAD
=======
		resources.rps.mpsTotal += resources.coffee.mps
		resources.motivation += resources.coffee.mps
>>>>>>> bc110a8c2c5f8460d55e032ba88967ff3dfd31c1
		resources.coffee.amount += resources.coffee.aps
		
	
	if(upgrades.coffeeSetup):
<<<<<<< HEAD
		resources.coffee.amount += resources.coffeeMachine.aps
=======
		resources.rps.fpsTotal += resources.coffeeMachine.fps
		resources.rps.cpsTotal += resources.coffeeMachine.aps
		resources.coffee.amount += resources.coffeeMachine.aps * resources.coffeeMachine.count
>>>>>>> bc110a8c2c5f8460d55e032ba88967ff3dfd31c1
		resources.funds += resources.coffeeMachine.fps
		
		
	if(upgrades.job):
		resources.funds += resources.job.pay
<<<<<<< HEAD
		
		
	if(upgrades.ghostWriter):
=======
		resources.rps.fpsTotal += resources.job.pay
		
		
	if(upgrades.ghostWriter && !resources.roadblock):
		resources.rps.fpsTotal += resources.ghostWriter.fps
>>>>>>> bc110a8c2c5f8460d55e032ba88967ff3dfd31c1
		resources.funds += resources.ghostWriter.fps
		resources.ghostWriter.corruption += resources.ghostWriter.cps
		resources.ghostWriter.currentWordCount += resources.ghostWriter.wps
		if(resources.ghostWriter.currentWordCount >= 1):
			var i = resources.ghostWriter.currentWordCount
			while i > 1:
				i += -1
				resources.wordCount += 1
				resources.ghostWriter.currentWordCount += -1
				_gen_ghost_prompt.emit()
				
	
<<<<<<< HEAD
	
	
	sendEmitters()

func sendEmitters():
	if(!PlayerVariables.flags.coffeeActive && PlayerVariables.resources.motivation < 50):
=======
	sendEmitters()

func sendEmitters():
	if(!PlayerVariables.flags.coffeeActive && PlayerVariables.resources.motivation <= 50):
>>>>>>> bc110a8c2c5f8460d55e032ba88967ff3dfd31c1
		PlayerVariables.flags.coffeeACtive = true
		_on_motivation_half.emit()
	if(!PlayerVariables.flags.coffeeMachineActive && PlayerVariables.resources.coffee.count >= 10):
		PlayerVariables.flags.coffeeMachineActive = true
		_on_ten_coffees.emit()
<<<<<<< HEAD
	if(!PlayerVariables.flags.hundredWords && PlayerVariables.resources.wordCount > 100):
		PlayerVariables.flags.hundredWords = true
		_on_hundred_words.emit()
	if(PlayerVariables.resources.funds < 5000):
		_on_funds_half.emit()
	if(!PlayerVariables.flags.ghostWriterActive && PlayerVariables.resources.wordCount > 500):
		PlayerVariables.flags.ghostWriterActive = true
		_on_five_hundred_words.emit()
	if(!PlayerVariables.flags.kittyActive && PlayerVariables.resources.wordCount > 1000):
		PlayerVariables.flags.kittyActive = true
		_on_thousand_words.emit()
=======
		
		
	if(!PlayerVariables.flags.hundredWords && PlayerVariables.resources.wordCount >= 100):
		PlayerVariables.flags.hundredWords = true
		_on_hundred_words.emit()
	if(!PlayerVariables.flags.fiveHundredWords && PlayerVariables.resources.wordCount >= 500):
		PlayerVariables.flags.fiveHundredWords = true
		_on_five_hundred_words.emit()
	if(!PlayerVariables.flags.thousandWords && PlayerVariables.resources.wordCount > 1000):
		PlayerVariables.flags.kittyActive = true
		_on_thousand_words.emit()
		
		
	if(PlayerVariables.resources.funds < 5000):
		_on_funds_half.emit()
>>>>>>> bc110a8c2c5f8460d55e032ba88967ff3dfd31c1
	if(!PlayerVariables.flags.corruptionStageOne && PlayerVariables.resources.ghostWriter.corruption >= 10):
		_on_corruption_ten.emit()
	if(!PlayerVariables.flags.corruptionStageTwo && PlayerVariables.resources.ghostWriter.corruption >= 40):
		_on_corruption_fourty.emit()
	if(!PlayerVariables.flags.corruptionStageThree && PlayerVariables.resources.ghostWriter.corruption >= 90):
		_on_corruption_ninety.emit()
	
<<<<<<< HEAD
	if(PlayerVariables.resources.motivation == 0):
=======
	if(!PlayerVariables.flags.currentRoadblockSent && PlayerVariables.resources.roadblock):
		PlayerVariables.flags.currentRoadblockSent = true
>>>>>>> bc110a8c2c5f8460d55e032ba88967ff3dfd31c1
		_on_roadblock.emit()
	

func unblock():
<<<<<<< HEAD
	resources.roadblock = false
=======
	flags.currentRoadblockSent = false
	resources.roadblock = false
	resources.motivation = 100
>>>>>>> bc110a8c2c5f8460d55e032ba88967ff3dfd31c1

