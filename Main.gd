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
	
	$Background/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer2/BuyCoffeeButton.text = str("Buy Coffee ($", PlayerVariables.resources.coffee.cost, ")")
	$Background/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer2/BuyKittyButton.text = str("Buy Kitty ($", PlayerVariables.resources.kitty.cost, ")")
	flip_timer()
	var i = DialogueManager.show_dialogue_balloon(resource, "start")
	flip_timer()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update_labels()
	
func _unhandled_input(event: InputEvent):
	if event is InputEventKey and not event.is_pressed() and not PlayerVariables.resources.motivation == 0:
		var key_typed = OS.get_keycode_string(event.get_key_label_with_modifiers())
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
	

func _on_timer_timeout():
	PlayerVariables.updateResources()


func _on_buy_coffee_button_pressed():
	PlayerVariables.resources.coffee.count += 1
	PlayerVariables.resources.funds += PlayerVariables.resources.coffee.cost
	PlayerVariables.resources.coffee.amount = 100
	PlayerVariables.resources.motivation += clamp(PlayerVariables.resources.motivation + PlayerVariables.resources.coffee.motivationGain, 0, 100)
	activate_mps()

func _on_buy_kitty_button_pressed():
	PlayerVariables.resources.funds += PlayerVariables.resources.kitty.cost
	PlayerVariables.upgrades.kitty = true
	$Background/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer2/BuyKittyButton.visible = false


func _on_pet_kitty_button_pressed():
	PlayerVariables.resources.kitty.pet.count += 1
	PlayerVariables.resources.motivation += clamp(PlayerVariables.resources.motivation + PlayerVariables.resources.kitty.pet.motivationGain, 0, 100)
	PlayerVariables.resources.kitty.attention += PlayerVariables.resources.kitty.pet.attentionGain
	activate_mps()
		

func _on_get_job_button_pressed():
	PlayerVariables.upgrades.job = true
	$Background/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer2/GetJobButton.visible = false

func _on_motivation_half():
	$Background/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer2/BuyCoffeeButton.visible = true

func _on_funds_half():
	$Background/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer2/GetJobButton.visible = true
	
func _on_hundred_words():
	flip_timer()
	DialogueManager.show_dialogue_balloon(resource, "first_hundred")
	flip_timer()
	PlayerVariables.resources.mps += -1

func _on_thousand_words():
	pass
	
func _on_kitty_needs_attention():
	pass
	
func _on_dialogue_ended(): 
	pass
	
func flip_timer():
	if $Timer.paused:
		$Timer.set_paused(false)
	else:
		$Timer.set_paused(true)
	is_waiting_for_input = !is_waiting_for_input
	
	
func activate_mps():
	if PlayerVariables.resources.tmps > 0:
		PlayerVariables.resources.mps = PlayerVariables.resources.tmps
		PlayerVariables.resources.tmps = 0
