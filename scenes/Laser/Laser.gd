extends Area2D
class_name Laser

var velocity := Vector2.ZERO
var speed := 1000

func start(position: Vector2, rotation: float, lifetime: float = 1) -> void:
	self.rotation = rotation
	self.position = position
	self.velocity = Vector2(speed, 0).rotated(rotation)
	yield(get_tree().create_timer(lifetime), "timeout")
	queue_free()
	

func _physics_process(delta: float) -> void:
	self.position += velocity * delta


func _on_Laser_body_entered(body: Node) -> void:
	if body.is_in_group("asteroids"):
		body.explode(velocity.normalized())
	queue_free()
