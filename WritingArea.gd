extends VBoxContainer

@onready var prompt = $PromptLabel
@onready var prompt_text = prompt.text
@onready var ghost_prompt_text

@export var green = Color("#007b00")
@export var red = Color("#5e041a")
@export var gray = Color("#4b4442")
@export var light_gray = Color("#7c7c7c")

# Called when the node enters the scene tree for the first time.
func _ready():
	PlayerVariables._gen_ghost_prompt.connect(gen_ghost_prompt)
	gen_prompt("long long ago in a land far far away")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func gen_prompt(pt := ""):
	prompt_text = pt if pt.length() > 0 else PromptList.get_prompt()
	var next_character_index = 0
	set_next_character(next_character_index)
	#prompt.parse_bbcode(set_center_tags(get_bbcode_color_tag(red) + prompt_text + get_bbcode_end_color_tag()))

func gen_ghost_prompt(pt := ""): 
	ghost_prompt_text = pt if pt.length() > 0 else PromptList.get_prompt()
	get_node("PlayerPreview").text += ghost_prompt_text + " "

func set_next_character(next_character_index: int):
	var gray_text = get_bbcode_color_tag(gray) + prompt_text.substr(0, next_character_index) + get_bbcode_end_color_tag()
	var green_text = get_bbcode_color_tag(green) + prompt_text.substr(next_character_index, 1) + get_bbcode_end_color_tag()
	var red_text = ""
	if next_character_index != prompt_text.length():
		red_text = get_bbcode_color_tag(red) + prompt_text.substr(next_character_index+1, prompt_text.length() - next_character_index+1) + get_bbcode_end_color_tag()
	else:
		get_node("PlayerPreview").text += prompt_text + " "
		gen_prompt()
		return
	prompt.parse_bbcode(set_center_tags(gray_text + green_text + red_text))


func get_bbcode_color_tag(color: Color) -> String:
	return "[color=#" + color.to_html(false) + "]"
func get_bbcode_end_color_tag() -> String:
	return "[/color]"
func set_center_tags(string_to_center: String) -> String:
	return "[center]" + string_to_center + "[/center]"
