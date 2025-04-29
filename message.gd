extends RichTextLabel

@export var messages_bbcode: Array[String] = [
	"[center][color=#846e59]Happy Birthday, [color=#e7e700ff][wave]Shelly[/wave][/color]![/color][/center]",
	"[center][color=#846e59]You have learned a DIY recipe for a [color=blue][wave]Nookazon Gift Card[/wave][/color]![/color][/center]",
	"[center][color=#846e59]Enjoy![/color][/center]"
]


@export var diy_card: Node3D
@export var nook_card: Node3D

var plain_messages: Array[String] = []
var current_message_index := 0
var typing_speed := 0.03
var is_typing := false
var char_index := 0
var full_plain_message := ""
var full_bbcode_message := ""

func _ready():
	for msg in messages_bbcode:
		var stripped = strip_bbcode(msg)
		plain_messages.append(stripped)
	show_next_message()

func strip_bbcode(text: String) -> String:
	var regex = RegEx.new()
	regex.compile("\\[.*?\\]")
	return regex.sub(text, "", true)

func show_next_message():
	if current_message_index >= messages_bbcode.size():
		return
	full_bbcode_message = messages_bbcode[current_message_index]
	full_plain_message = strip_bbcode(full_bbcode_message)
	text = ""
	char_index = 0
	is_typing = true
	set_process(true)

func _process(_delta):
	if is_typing:
		if char_index < full_plain_message.length():
			var partial_text = "[center]" + full_plain_message.substr(0, char_index + 1) + "[/center]"
			text = partial_text
			char_index += 1
		else:
			is_typing = false
			set_process(false)
			text = full_bbcode_message

func _unhandled_input(event):
	if event.is_action_pressed("ui_accept") and not is_typing:
		# Play animation depending on the *previous* message finished
		match current_message_index:
			0:
				if diy_card and diy_card.has_node("AnimationPlayer"):
					diy_card.get_node("AnimationPlayer").play("FlipCard2")
			1:
				if nook_card and nook_card.has_node("AnimationPlayer"):
					nook_card.get_node("AnimationPlayer").play("FlipCard2")
		
		current_message_index += 1
		show_next_message()
