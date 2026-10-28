extends AnimatedSprite2D

func _ready():
	animation_finished.connect(_on_animation_finished)

func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if _is_clicked():
			play("react")

func _is_clicked() -> bool:
	var local := to_local(get_global_mouse_position())
	var size := sprite_frames.get_frame_texture(animation, frame).get_size()
	var rect := Rect2(-size / 2 if centered else Vector2.ZERO, size)
	return rect.has_point(local)

func _on_animation_finished():
	if animation == "react":
		play("idle")
