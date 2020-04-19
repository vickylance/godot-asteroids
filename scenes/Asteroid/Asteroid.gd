extends KinematicBody2D
class_name Asteroid

signal exploded

var size: String
var velocity := Vector2.ZERO
var rotation_speed := 0.0
var screen_size := Vector2.ZERO
var asteroid_size := 0.0
var textures := {
	"lg": [
		"res://sheets/sheet.sprites/Meteors/meteorGrey_big1.tres",
		"res://sheets/sheet.sprites/Meteors/meteorGrey_big2.tres",
		"res://sheets/sheet.sprites/Meteors/meteorGrey_big3.tres",
		"res://sheets/sheet.sprites/Meteors/meteorGrey_big4.tres"
	],
	"md": [
		"res://sheets/sheet.sprites/Meteors/meteorGrey_med1.tres",
		"res://sheets/sheet.sprites/Meteors/meteorGrey_med2.tres"
	],
	"sm": [
		"res://sheets/sheet.sprites/Meteors/meteorGrey_small1.tres",
		"res://sheets/sheet.sprites/Meteors/meteorGrey_small2.tres"
	],
	"tn": [
		"res://sheets/sheet.sprites/Meteors/meteorGrey_tiny1.tres",
		"res://sheets/sheet.sprites/Meteors/meteorGrey_tiny2.tres"
	]
}

onready var puff := $Puff as Particles2D
onready var sprite := $Sprite as Sprite
onready var collision_shape := $Shape as CollisionShape2D


func _ready() -> void:
	randomize()
	screen_size = get_viewport_rect().size
	init("tn", screen_size/2)


func _physics_process(delta: float) -> void:
	move(delta)
	wrap_around()


func init(init_size: String, init_position: Vector2, init_velocity: Vector2 = Vector2.ZERO) -> void:
	self.size = init_size
	self.position = init_position
	if init_velocity == Vector2.ZERO:
		velocity = Vector2(rand_range(30, 100), 0).rotated(rand_range(0, 2*PI))
	else:
		velocity = init_velocity
	rotation_speed = rand_range(-2.0, 2.0)
	
	var texture := load(textures[size][randi() % textures[size].size()] as String) as Texture
	self.sprite.texture = texture
	asteroid_size = min(sprite.get_rect().size.x, sprite.get_rect().size.y)
	var shape := CircleShape2D.new()
	shape.radius = asteroid_size / 2
	self.collision_shape.shape = shape
	

func move(delta: float) -> void:
	velocity = velocity.clamped(300)
	var collision := move_and_collide(velocity * delta)
	if collision:
		velocity = velocity.bounce(collision.normal)
		puff.global_position = collision.position
		puff.emitting = true
	rotation += rotation_speed * delta


func wrap_around() -> void:
	# wrap around
	if (self.position.x > (screen_size.x + asteroid_size/2)):
		self.position.x = -asteroid_size/2
	if (self.position.x < -asteroid_size/2):
		self.position.x = screen_size.x + asteroid_size/2
	if (self.position.y > (screen_size.y + asteroid_size/2)):
		self.position.y = -asteroid_size/2
	if (self.position.y < -asteroid_size/2):
		self.position.y = screen_size.y + asteroid_size/2


func explode(hit_velocity: Vector2) -> void:
#	puff.global_position = position
#	puff.amount = 60
#	puff.speed_scale = 4
#	puff.process_material.scale = 10
#	puff.emitting = true
#	yield(get_tree().create_timer(puff.lifetime), "timeout")
	emit_signal("exploded", size, self.position, velocity, hit_velocity)
	queue_free()
