extends Node2D

onready var spawn_points := $AsteroidSpawn as Node
onready var asteroids := $Asteroids as Node
onready var frame_rate := $CanvasLayer/Framerate as Label

var asteroid := preload("res://scenes/Asteroid/Asteroid.tscn")
var break_pattern := {
	"lg": "md",
	"md": "sm",
	"sm": "tn",
	"tn": null
}


func _process(delta: float) -> void:
	frame_rate.text = "fps: " + str(Engine.get_frames_per_second())
	if asteroids.get_child_count() == 0:
		spawn_initial_asteroids(5)
		

func _ready() -> void:
	spawn_initial_asteroids(5)


func spawn_initial_asteroids(amount: int):
	for i in range(amount):
		spawn_asteroid("lg", (spawn_points.get_children()[i] as Position2D).position)


func spawn_asteroid(size: String, position: Vector2, velocity: Vector2 = Vector2.ZERO) -> void:
	var asteroid: Asteroid = self.asteroid.instance() as Asteroid
	asteroids.add_child(asteroid)
	asteroid.connect("exploded", self, "explode_asteroid")
	asteroid.init(size, position, velocity)


func explode_asteroid(size: String, pos: Vector2, velocity: Vector2, hit_velocity: Vector2) -> void:
	var new_size = break_pattern[size]
	if new_size:
		for offset in [-1, 1]:
			var new_pos = pos + hit_velocity.tangent().clamped(25) * offset
			var new_vel = velocity + hit_velocity.tangent() * offset
			print("spawning asteroid")
			spawn_asteroid(new_size, new_pos, new_vel)
		
