extends KinematicBody2D
class_name Player

signal shoot
signal damaged

export var ACCELERATION := 300
export var CROUCH_SPEED := 50
export var NORMAL_SPEED := 100
export var SPRINT_SPEED := 200
export var FRICTION := 300
export var ROTATION_SPEED := 10
export var HEALTH := 100
export var FIRE_RATE := 10.0 # Fire rate 10 bullets per second
export var bullet_scene: PackedScene

var velocity := Vector2.ZERO
var screen_size := Vector2.ZERO
var player_size := 0.0
var bullet_delay := 0.0

onready var bullets := $Bullets
onready var sprite := $Sprite as Sprite
onready var gun_nozzle := $GunNozzle as Position2D
onready var update_delta: float = 1 / FIRE_RATE


func _ready() -> void:
	screen_size = get_viewport_rect().size
	player_size = min(sprite.get_rect().size.x, sprite.get_rect().size.y)


func _physics_process(delta: float) -> void:
	move(delta)
	wrap_around()
	rotate(delta)
	shoot(delta)


func move(delta: float) -> void:
	# movement
	var input_vector := Vector2.ZERO
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	input_vector = input_vector.normalized()
	get_tree().get_root().get_node("Main/CanvasLayer/Debug").text = str(input_vector)
	
	var curr_speed := NORMAL_SPEED
	if Input.get_action_strength("crouch"):
		curr_speed = CROUCH_SPEED
	elif Input.get_action_strength("sprint"):
		curr_speed = SPRINT_SPEED
	
#	# move in the direction on mouse pointer
#	var mouse_direction := (get_global_mouse_position() - position).normalized()
#	input_vector = input_vector.rotated(mouse_direction.angle() + PI/2)
	
	if input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(input_vector * curr_speed, ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
#	set_linear_velocity(velocity)
	move_and_slide(velocity)


func wrap_around() -> void:
	# wrap around
	if (self.position.x > (screen_size.x + player_size/2)):
		self.position.x = -player_size/2
	if (self.position.x < -player_size/2):
		self.position.x = screen_size.x + player_size/2
	if (self.position.y > (screen_size.y + player_size/2)):
		self.position.y = -player_size/2
	if (self.position.y < -player_size/2):
		self.position.y = screen_size.y + player_size/2


func rotate(delta: float) -> void:
	# direction
	var mpos := Vector2.ZERO
	var angle := 0.0
	if Global.joystickConnected:
		print("yolo")
		var direction_vector := Vector2.ZERO
		direction_vector.x = Input.get_action_strength("joy_look_right") - Input.get_action_strength("joy_look_left")
		direction_vector.y = Input.get_action_strength("joy_look_down") - Input.get_action_strength("joy_look_up")
		mpos = direction_vector.normalized()
		angle = Vector2.ZERO.angle_to(direction_vector)
#		mpos = Vector2(Input.get_joy_axis(0, JOY_AXIS_2), Input.get_joy_axis(0, JOY_AXIS_3))
	else:
		mpos = get_local_mouse_position()
		angle = mpos.angle()
	get_tree().get_root().get_node("Main/CanvasLayer/Debug").text += str(angle)
#	self.rotation += (mpos.angle() + PI/2) * ROTATION_SPEED * delta


func shoot(delta: float) -> void:
	# shoot
	bullet_delay += delta
	if (bullet_delay < update_delta):
		return

	if Input.is_action_pressed("shoot"):
		#fire weapon
		bullet_delay = 0
		var bullet = bullet_scene.instance()
		bullets.add_child(bullet)
		bullet.set_global_position(gun_nozzle.get_global_position())
		bullet.start(gun_nozzle.get_global_position(), rotation - PI/2)
		emit_signal("shoot")

