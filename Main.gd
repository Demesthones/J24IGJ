extends Node
var resource = load("res://Script.dialogue")
var is_waiting_for_input = false
var prompt = null
var current_letter_index: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	PlayerVariables._on_funds_half.connect(_on_funds_half)
	PlayerVariables._on_motivation_half.connect(_on_motivation_half)
	PlayerVariables._on_hundred_words.connect(_on_hundred_words)
	PlayerVariables._on_thousand_words.connect(_on_thousand_words)
	PlayerVariables._on_kitty_needs_attention.connect(_on_kitty_needs_attention)
	
	
	
	#flip_timer()
	var i = DialogueManager.show_dialogue_balloon(resource, "start")
	#flip_timer()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if PlayerVariables.resources.kitty.attentionLevel < 25:
		$Background/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer2/PetKittyButton.disabled = false
	else:
		$Background/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer2/PetKittyButton.disabled = true
	update_labels()
	
func _unhandled_input(event: InputEvent):
	if event is InputEventKey and not event.is_pressed() and not PlayerVariables.resources.motivation == 0:
		var key_typed = OS.get_keycode_string(event.get_key_label_with_modifiers())
		print(key_typed)
		if !event.shift_pressed:
			key_typed = key_typed.to_lower()
		
		var prompt = $Background/VBoxContainer/HBoxContainer/WritingArea.prompt_text
		var next_character = prompt.substr(current_letter_index, 1)
		if key_typed == next_character:
			current_letter_index += 1
			$Background/VBoxContainer/HBoxContainer/WritingArea.set_next_character(current_letter_index)
			if current_letter_index == prompt.length():
				PlayerVariables.resources.wordCount += PlayerVariables.resources.wca
				current_letter_index = 0
				


func update_labels(): 
	%CompletionBarLabel.text = str(PlayerVariables.resources.wordCount, "/", %CompletionBar.max_value)
	%FundsAmountLabel.text = str(PlayerVariables.resources.funds)
	%MotivationAmountLabel.text = str(PlayerVariables.resources.motivation)
	%CoffeeAmountLabel.text = str(PlayerVariables.resources.coffee.amount)
	%KittyAttentionAmountLabel.text = str(PlayerVariables.resources.kitty.attentionLevel)
	%WalkTimerAmountLabel.text = str($RoadblockTimer.time_left)
	%CorruptionAmountLabel.text = str(PlayerVariables.resources.ghostWriter.corruption)
	
	$Background/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer2/BuyCoffeeButton.text = str("Buy Coffee ($", PlayerVariables.resources.coffee.cost, ")")
	$Background/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer2/BuyKittyButton.text = str("Buy Kitty ($", PlayerVariables.resources.kitty.cost, ", $", PlayerVariables.resources.kitty.fps, "/s)")
	$Background/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer2/BuyAutoTyperButton.text = str("Employ Ghost Writer ($", PlayerVariables.resources.ghostWriter.cost, ", $", PlayerVariables.resources.ghostWriter.fps, "/s)")
	$Background/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer2/BuyCoffeeMachineButton.text = str("Buy Coffee Machine ($", PlayerVariables.resources.coffeeMachine.cost, ", $", PlayerVariables.resources.coffeeMachine.fps, "/s, ", PlayerVariables.resources.coffeeMachine.aps, "/s")
	
	
	

func _on_timer_timeout():
	PlayerVariables.updateResources()


func _on_buy_coffee_button_pressed():
	PlayerVariables.resources.coffee.count += 1
	PlayerVariables.resources.funds += PlayerVariables.resources.coffee.cost
	PlayerVariables.resources.coffee.amount = 100
	PlayerVariables.resources.motivation = clamp(PlayerVariables.resources.motivation + PlayerVariables.resources.coffee.motivationGain, 0, 100)


func _on_ten_coffees():
	DialogueManager.show_dialogue_balloon(resource, "on_ten_coffees")
	$Background/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer2/BuyCoffeeMachineButton.visible = true
	
	
func _on_buy_kitty_button_pressed():
	PlayerVariables.resources.funds += PlayerVariables.resources.kitty.cost
	PlayerVariables.resources.kitty.count += 1
	PlayerVariables.upgrades.kitty = true


func _on_pet_kitty_button_pressed():
	PlayerVariables.resources.kitty.pet.count += 1
	PlayerVariables.resources.motivation += clamp(PlayerVariables.resources.motivation + PlayerVariables.resources.kitty.pet.motivationGain, 0, 100)
	PlayerVariables.resources.kitty.attention += PlayerVariables.resources.kitty.pet.attentionGain
	PlayerVariables.unblock()
	

func _on_get_job_button_pressed():
	PlayerVariables.upgrades.job = true
	$Background/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer2/GetJobButton.visible = false

func _on_motivation_half():
	$Background/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer2/BuyCoffeeButton.visible = true
	$Background/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer/VBoxContainer/CoffeeLabel.visible = true

func _on_funds_half():
	$Background/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer2/GetJobButton.visible = true
	
func _on_roadblock():
	DialogueManager.show_dialogue_balloon(resource, "roadblock1")
	$Background/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer2/TakeWalkButton.visible = true
	
func _on_hundred_words():
	#flip_timer()
	DialogueManager.show_dialogue_balloon(resource, "first_hundred")
	#flip_timer()
	PlayerVariables.resources.mps += -1
	
func _on_five_hundred_words():
	$Background/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer2/BuyAutoTyperButton.visible = true
	DialogueManager.show_dialogue_balloon(resource, "five_hundred")

func _on_thousand_words():
	$Background/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer2/BuyKittyButton.visible = true
	DialogueManager.show_dialogue_balloon(resource, "thousand_words")
	pass
	
func _on_kitty_needs_attention():
	$Background/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer2/PetKittyButton.visible = true
	$Background/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer/VBoxContainer/KittyAttentionLabel.visible = true
	$Background/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer/VBoxContainer2/KittyAttentionAmountLabel.visible = true
	DialogueManager.show_dialogue_balloon(resource, "on_kitty_needs_attention")
	
	
	
func _on_dialogue_ended(): 
	pass
	
#func flip_timer():
	#if $Timer.paused:
		#$Timer.set_paused(false)
	#else:
		#$Timer.set_paused(true)
	#is_waiting_for_input = !is_waiting_for_input


func _on_buy_auto_typer_button_pressed():
	PlayerVariables.upgrades.ghostWriter = true
	PlayerVariables.resources.ghostWriter.level += 1
	PlayerVariables.resources.funds += PlayerVariables.resources.ghostWriter.cost
	


func _on_take_walk_button_pressed():
	$RoadblockTimer.start
	$Background/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer/VBoxContainer/WalkTimerLabel.visible = true
	#Display some kind of bar for timer status
	

func _on_roadblock_timer_timeout():
	PlayerVariables.unblock()
	$Background/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer/VBoxContainer/WalkTimerLabel.visible = false
	pass # Replace with function body.


func _on_buy_coffee_machine_button_pressed():
	PlayerVariables.upgrades.coffeeSetup = true
	PlayerVariables.resources.coffeeMachine.count += 1
	PlayerVariables.resources.funds += PlayerVariables.resources.coffeeMachine.cost


func _on_corruption_ten():
	$CorruptionLabel.visible = true
	$CorruptionAmountLabel.visible = true
	DialogueManager.show_dialogue_balloon(resource, "on_corruption_ten")
	
