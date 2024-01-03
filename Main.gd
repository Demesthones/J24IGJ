extends Node
var resource = load("res://Script.dialogue")
var is_waiting_for_input = false
var prompt = null
var current_letter_index: int = 0
@onready var wa = $Background/VBoxContainer/HBoxContainer/WritingArea

# Called when the node enters the scene tree for the first time.
func _ready():

	PlayerVariables._on_motivation_half.connect(_on_motivation_half)
	PlayerVariables._on_funds_half.connect(_on_funds_half)
	PlayerVariables._on_hundred_words.connect(_on_hundred_words)
	PlayerVariables._on_two_hundred_words.connect(_on_two_hundred_words)
	PlayerVariables._on_five_hundred_words.connect(_on_five_hundred_words)
	PlayerVariables._on_kitty_needs_attention.connect(_on_kitty_needs_attention)
	PlayerVariables._on_roadblock.connect(_on_roadblock)
	PlayerVariables._on_ten_coffees.connect(_on_ten_coffees)
	PlayerVariables._on_corruption_ten.connect(_on_corruption_ten)
	PlayerVariables._on_corruption_fourty.connect(_on_corruption_fourty)
	PlayerVariables._on_funds_half.connect(_on_funds_half)
	PlayerVariables._on_corruption_ninety.connect(_on_corruption_ninety)
	PlayerVariables._on_publisher_offer.connect(_on_publisher_offer)
	PlayerVariables._on_deadline_increase_one.connect(_on_deadline_increase_one)
	
	
	%CoffeeAmountLabel.visible_characters = 0
	%CorruptionAmountLabel.visible_characters = 0
	%WalkTimerAmountLabel.visible_characters = 0
	%KittyAttentionAmountLabel.visible_characters = 0
	%CoffeeChangeLabel.visible_characters = 0
	%CorruptionAmountChangeLabel.visible_characters = 0
	%PayPerWordAmountLabel.visible_characters = 0
	%PurificationPerWordAmountLabel.visible_characters = 0
	%GhostWriterAmountLabel.visible_characters = 0
	%GhostWriterChangeLabel.visible_characters = 0
	
	DialogueManager.show_dialogue_balloon(resource, "start")

	
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
		if next_character == " " && key_typed.to_lower() == "space":
			current_letter_index += 1
			$Background/VBoxContainer/HBoxContainer/WritingArea.set_next_character(current_letter_index)
			if current_letter_index == prompt.length():
				PlayerVariables.resources.wordCount += PlayerVariables.resources.wca
				current_letter_index = 0
		elif key_typed == next_character:
			current_letter_index += 1
			$Background/VBoxContainer/HBoxContainer/WritingArea.set_next_character(current_letter_index)
			if current_letter_index == prompt.length():
				PlayerVariables.resources.wordCount += PlayerVariables.resources.wca
				current_letter_index = 0
				

func update_labels(): 
	%CompletionBar.value = PlayerVariables.resources.wordCount
	%DeadlineBar.value = PlayerVariables.resources.deadlineAmount
	%DeadlineBar.max_value = PlayerVariables.resources.deadlineMax
	%CompletionBarLabel.text = str(PlayerVariables.resources.wordCount, "/", %CompletionBar.max_value)
	%FundsAmountLabel.text = str(PlayerVariables.resources.funds)
	if !PlayerVariables.resources.roadblock:
		%MotivationAmountLabel.text = str(PlayerVariables.resources.motivation)
	else:
		%MotivationAmountLabel.text = "Roadblock"
	%CoffeeAmountLabel.text = str(PlayerVariables.resources.coffee.amount)
	%KittyAttentionAmountLabel.text = str(PlayerVariables.resources.kitty.attentionLevel)
	%WalkTimerAmountLabel.text = str(snapped($RoadblockTimer.time_left, .01))
	%CorruptionAmountLabel.text = str(PlayerVariables.resources.ghostWriter.corruption)
	
	%FundsChangeLabel.text = str(PlayerVariables.resources.rps.fpsTotal)
	%MotivationChangeLabel.text = str(PlayerVariables.resources.rps.mpsTotal)
	%CoffeeChangeLabel.text = str(PlayerVariables.resources.rps.cpsTotal)
	%CorruptionAmountChangeLabel.text = str(PlayerVariables.resources.rps.crpsTotal)
	%PurificationPerWordAmountLabel.text = str(PlayerVariables.resources.purification.ppw * PlayerVariables.resources.purification.level)
	%PayPerWordAmountLabel.text = str(PlayerVariables.resources.publisher.ppw * PlayerVariables.resources.publisher.level)
	%GhostWriterAmountLabel.text = str(PlayerVariables.resources.ghostWriter.level)
	%GhostWriterChangeLabel.text = str(PlayerVariables.resources.ghostWriter.wps * PlayerVariables.resources.ghostWriter.level, "/s")
	
	$Background/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer2/PetKittyButton.disabled = false if PlayerVariables.resources.kitty.attentionLevel < 25 && PlayerVariables.resources.kitty.pet.timeout == 0 else true
	$Background/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer2/TakeWalkButton.disabled = true if PlayerVariables.resources.roadblock == false else false
	$Background/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer2/BuyCoffeeButton.text = str("Buy Coffee ($", PlayerVariables.resources.coffee.cost, ")")
	$Background/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer2/BuyKittyButton.text = str("Buy Kitty ($", PlayerVariables.resources.kitty.cost, ", $", PlayerVariables.resources.kitty.fps, "/s)")
	$Background/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer2/BuyAutoTyperButton.text = str("Employ Ghost Writer ($", PlayerVariables.resources.ghostWriter.cost, ", $", PlayerVariables.resources.ghostWriter.fps, "/s)")
	$Background/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer2/BuyCoffeeMachineButton.text = str("Buy Coffee Machine ($", PlayerVariables.resources.coffeeMachine.cost, ", $", PlayerVariables.resources.coffeeMachine.fps * (PlayerVariables.resources.coffeeMachine.count+1), "/s, ", PlayerVariables.resources.coffeeMachine.aps * (PlayerVariables.resources.coffeeMachine.count+1), "/s")
	$Background/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer2/UpgradeAutoTyperButton.text = str("Increase Ghost Writer Pay ($", PlayerVariables.resources.ghostWriter.cost, ", $", PlayerVariables.resources.ghostWriter.fps * (PlayerVariables.resources.ghostWriter.level +1), "/s)")
	$Background/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer2/PurificationKeyboardButton.text = str("Buy Purifying Keyboard ($", PlayerVariables.resources.purification.cost, ", -", PlayerVariables.resources.purification.ppw, "/word)")
	$Background/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer2/PurificationUpgradeButton.text = str("Upgrade Purifying Keyboard ($", PlayerVariables.resources.purification.cost, ", -", PlayerVariables.resources.purification.ppw * (PlayerVariables.resources.purification.level+1), "/word)")

func _on_timer_timeout():
	PlayerVariables.updateResources()


func _on_buy_coffee_button_pressed():
	PlayerVariables.resources.coffee.count += 1
	PlayerVariables.resources.funds += PlayerVariables.resources.coffee.cost
	PlayerVariables.resources.coffee.amount = 100
	PlayerVariables.resources.motivation = clamp(PlayerVariables.resources.motivation + PlayerVariables.resources.coffee.motivationGain, 0, 100)
func _on_ten_coffees():
	wa.gen_prompt("coffee coffee coffee")
	DialogueManager.show_dialogue_balloon(resource, "on_ten_coffees")
	$Background/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer2/BuyCoffeeMachineButton.visible = true
	
func _on_buy_kitty_button_pressed():
	PlayerVariables.resources.funds += PlayerVariables.resources.kitty.cost
	PlayerVariables.resources.kitty.count += 1
	PlayerVariables.upgrades.kitty = true
	%KittyAttentionLabel.visible = true
	%KittyAttentionAmountLabel.visible_characters = -1
	$Background/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer2/BuyKittyButton.visible = false
	$Background/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer2/PetKittyButton.visible = true
	
	if PlayerVariables.upgrades.ghostWriter:
		wa.gen_ghost_prompt("hisnameischarlesthecat")
		wa.gen_ghost_prompt("besuretogivehimlotsofattention")

func _on_pet_kitty_button_pressed():
	PlayerVariables.resources.kitty.pet.count += 1
	PlayerVariables.resources.kitty.pet.timeout = 30
	PlayerVariables.resources.motivation += clamp(PlayerVariables.resources.motivation + PlayerVariables.resources.kitty.pet.motivationGain, 0, 100)
	PlayerVariables.resources.kitty.attentionLevel += PlayerVariables.resources.kitty.pet.attentionGain
	PlayerVariables.unblock()
	
func _on_get_job_button_pressed():
	PlayerVariables.upgrades.job = true
	$Background/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer2/GetJobButton.visible = false
	$Background/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer2/QuitJobButton.visible = true
	
func _on_quit_job_button_pressed():
	PlayerVariables.upgrades.job = false
	$Background/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer2/GetJobButton.visible = true
	$Background/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer2/QuitJobButton.visible = false

func _on_motivation_half():
	$Background/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer2/BuyCoffeeButton.visible = true
	%CoffeeLabel.visible = true
	%CoffeeAmountLabel.visible_characters = -1
	%CoffeeChangeLabel.visible_characters = -1

func _on_funds_half():
	$Background/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer2/GetJobButton.visible = true
	
func _on_roadblock():
	DialogueManager.show_dialogue_balloon(resource, "roadblock1")
	$Background/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer2/TakeWalkButton.visible = true
	
func _on_hundred_words():
	#flip_timer()
	DialogueManager.show_dialogue_balloon(resource, "first_hundred")
	#flip_timer()

func _on_two_hundred_words():
	$Background/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer2/BuyAutoTyperButton.visible = true
	DialogueManager.show_dialogue_balloon(resource, "two_hundred")

func _on_five_hundred_words():
	$Background/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer2/BuyKittyButton.visible = true
	DialogueManager.show_dialogue_balloon(resource, "five_hundred_words")
	
func _on_kitty_needs_attention():
	print(PlayerVariables.resources.kitty.attentionLevel)
	var c = PlayerVariables.resources.ghostWriter.corruption
	if c < 10:
		wa.gen_prompt("pet pls")
	elif c >= 10 && c < 40:
		wa.gen_prompt("pet me now human")
	elif c >= 40 && c < 90:
		wa.gen_prompt("you will pet me or suffer")
	else:
		wa.gen_prompt("petmepetmepetmepetmepetmepetmepetmepetme")
		
	$Background/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer2/PetKittyButton.disabled = false
	DialogueManager.show_dialogue_balloon(resource, "on_kitty_needs_attention")
	
func _on_buy_auto_typer_button_pressed():
	wa.gen_ghost_prompt("yourofferingisaccepted")
	PlayerVariables.upgrades.ghostWriter = true
	PlayerVariables.resources.ghostWriter.level += 1
	PlayerVariables.resources.funds += PlayerVariables.resources.ghostWriter.cost
	$Background/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer2/BuyAutoTyperButton.visible = false
	$Background/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer2/UpgradeAutoTyperButton.visible = true
	%GhostWriterLabel.visible = true
	%GhostWriterAmountLabel.visible_characters = -1
	%GhostWriterChangeLabel.visible_characters = -1
	
func _on_take_walk_button_pressed():
	PlayerVariables.resources.roadblock = true
	$RoadblockTimer.start()
	%WalkTimerLabel.visible = true
	%WalkTimerAmountLabel.visible_characters = -1
	#Display some kind of bar for timer status
	
func _on_roadblock_timer_timeout():
	PlayerVariables.unblock()
	pass # Replace with function body.

func _on_buy_coffee_machine_button_pressed():
	PlayerVariables.upgrades.coffeeSetup = true
	PlayerVariables.resources.coffeeMachine.count += 1
	PlayerVariables.resources.funds += PlayerVariables.resources.coffeeMachine.cost

func _on_corruption_ten():
	%CorruptionLabel.visible = true
	%CorruptionAmountLabel.visible_characters = -1
	%CorruptionAmountChangeLabel.visible_characters = -1
	$Background/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer2/PurificationKeyboardButton.visible = true
	wa.gen_ghost_prompt("whispersinthedark")
	DialogueManager.show_dialogue_balloon(resource, "on_corruption_ten")
	
func _on_corruption_fourty():
	wa.gen_ghost_prompt("thereisonlyonewaythisends")
	DialogueManager.show_dialogue_balloon(resource, "on_corruption_fourty")
	
func _on_corruption_ninety():
	wa.gen_ghost_prompt("yesyesyesyesyesyesyesyesyesyesyeswearesoclosenow")
	DialogueManager.show_dialogue_balloon(resource, "on_corruption_ninety")

func _on_publisher_offer():
	DialogueManager.show_dialogue_balloon(resource, "on_publisher_offer")
	$Background/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer2/AcceptPublisherOfferButton.visible = true
	
func _on_deadline_increase_one():
	DialogueManager.show_dialogue_balloon(resource, "on_deadline_increase_one")
	$Background/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer2/UpgradePublisherOfferButton.visible = true
	
func _on_upgrade_auto_typer_button_pressed():
	wa.gen_ghost_prompt("yourofferingisaccepted")
	PlayerVariables.resources.funds += PlayerVariables.resources.ghostWriter.cost
	PlayerVariables.resources.ghostWriter.level += 1
	
func _on_accept_publisher_offer_button_pressed():
	PlayerVariables.upgrades.publisherAccepted = true
	PlayerVariables.resources.publisher.level += 1
	%PayPerWordLabel.visible = true
	%PayPerWordAmountLabel.visible_characters = -1
	$Background/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer2/AcceptPublisherOfferButton.visible = false
	
func _on_purification_keyboard_button_pressed():
	PlayerVariables.upgrades.purification = true;
	PlayerVariables.resources.purification.level += 1
	%PurificationPerWordLabel.visible = true
	%PurificationPerWordAmountLabel.visible_characters = -1
	$Background/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer2/PurificationKeyboardButton.visible = false
	$Background/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer2/PurificationUpgradeButton.visible = true

func _on_purification_upgrade_button_pressed():
	PlayerVariables.resources.funds += PlayerVariables.resources.purification.cost
	PlayerVariables.resources.purification.level += 1

func _on_upgrade_publisher_offer_button_pressed():
	PlayerVariables.resources.publisher.level += 1
	$Background/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer2/UpgradePublisherOfferButton.visible = false
