extends PopupPanel

signal deleteComfirm(cat_id)
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.

func resize(screen_size):
	# $"InfoField".set_position(Vector2(0,0.1*screen_size.y))
	$"InfoField".add_constant_override("separation",0.02*screen_size.y)
	# $"InfoField/cat_description".set_position(
	# 	Vector2(0.04*screen_size.x,screen_size.y*0.5))
	$"InfoField/cat_description".add_constant_override("separation",0.08*screen_size.x)
	# $"InfoField/cat_description".set_size(
	# 	Vector2(screen_size.x-0.08*screen_size.x,screen_size.y*0.4))

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	resize()
#	pass
func set_value(value:Array):
	$InfoField/cat_id/Label2.text = value[0]
	$InfoField/cat_name/Label2.text = value[1]
	$InfoField/cat_sex/Label2.text = value[2]
	$InfoField/cat_kind/Label2.text = value[3]
	$InfoField/cat_color/Label2.text = value[4]
	$InfoField/cat_description/Label2/TextEdit.text = value[5]
	pass


func _on_Delete_pressed():
	$ConfirmationDialog.popup_centered(get_viewport().get_visible_rect().size*0.4)
	pass # Replace with function body.


func _on_ConfirmationDialog_confirmed():
	emit_signal("deleteComfirm",$InfoField/cat_id/Label2.text)
	pass # Replace with function body.
func hide_button():
	$InfoField/HBoxContainer.queue_free()
	$InfoField/HSeparator.queue_free()
