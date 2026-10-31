extends Sprite2D

signal clicked(item)

@export var corner_radius := 20.0
@export var padding := 0.0

func _ready():
	add_to_group("litter")

func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if _hit(to_local(get_global_mouse_position())):
			get_viewport().set_input_as_handled()
			clicked.emit(self)

func _hit(p: Vector2) -> bool:
	var half := texture.get_size() / 2 + Vector2(padding, padding)
	if not centered:
		p -= half
	var r: float = min(corner_radius, half.x, half.y)
	var q := p.abs() - (half - Vector2(r, r))
	return Vector2(max(q.x, 0.0), max(q.y, 0.0)).length() <= r
