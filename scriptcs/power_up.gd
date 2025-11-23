extends Area3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	animation_player.play("Rotation")




func _on_body_entered(body: Node3D) -> void:
	if body.name == "player":
		var player = body
		queue_free()
		player.hp += 10
	pass # Replace with function body.
