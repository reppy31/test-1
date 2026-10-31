extends AnimatedSprite2D

@export var corner_radius := 40.0
@export var padding := 0.0
@export var walk_speed := 170.0

var home: Vector2
var busy := false

func _ready():
	animation_finished.connect(_on_animation_finished)
	home = global_position
	await get_tree().process_frame  # let the litter join the group first
	for item in get_tree().get_nodes_in_group("litter"):
		item.clicked.connect(_on_litter_clicked)

func _unhandled_input(event):
	if busy:
		return
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if _hit(to_local(get_global_mouse_position())):
			get_viewport().set_input_as_handled()
			play("react")

func _hit(p: Vector2) -> bool:
	var half := sprite_frames.get_frame_texture(animation, frame).get_size() / 2 + Vector2(padding, padding)
	if not centered:
		p -= half
	var r: float = min(corner_radius, half.x, half.y)
	var q := p.abs() - (half - Vector2(r, r))
	return Vector2(max(q.x, 0.0), max(q.y, 0.0)).length() <= r

func _on_litter_clicked(item):
	if busy:
		return
	busy = true
	await _walk_to(Vector2(item.global_position.x, home.y))
	play("pickup")
	await animation_finished
	item.queue_free()
	await _walk_to(home)
	play("idle")
	flip_h = false
	busy = false

func _walk_to(target: Vector2):
	flip_h = target.x > global_position.x  # walk frames face left
	play("walk")
	var time := global_position.distance_to(target) / walk_speed
	var tween := create_tween()
	tween.tween_property(self, "global_position", target, time)
	await tween.finished

func _on_animation_finished():
	if animation == "react":
		play("idle")
