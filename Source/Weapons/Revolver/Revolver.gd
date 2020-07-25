extends Node2D

var barrelParticleSystem = preload("res://Source/Particle Systems/CollisionParticleSystem.tscn")
var collisionParticleSystem = preload("res://Source/Particle Systems/CollisionParticleSystem.tscn")

var tracerSystem = preload("res://Source/Tracer Systems/LineTracerSystem.tscn")

export var barrelOffset = Vector2(13, 0)
export var barrelParticlesColor = Color(0.5, 0.8, 1)
export var barrelParticlesAmount = 2

export var collisionParticlesColor = Color.white
export var collisionParticlesAmount = 5

export var tracerDuration = 0.2
export var tracerColor = Color(0.5, 0.8, 1, 0.5)

export var screenShakeTrauma = 0.2
export var chromaticAberrationDuration = 0.05
export var slowTimeDuration = 0.2
export var slowTimeStrength = 0.8

onready var sprite = $Sprite
onready var rayCast = $RayCast
onready var camera = get_parent().get_node("Camera")
onready var slowTime = get_node("/root/Game/Effects/SlowTime")

func _ready():
	rayCast.add_exception(owner)

func emit_effects():
	if rayCast.is_colliding():
		emit_collision_particles(collisionParticlesAmount, rayCast.get_collision_point(), rayCast.get_collision_normal(), collisionParticlesColor)
	else:
		pass
	
	var barrelNormal = Vector2(cos(rotation), sin(rotation))
	var barrelPosition = Vector2.ZERO
	barrelPosition.x = global_position.x + (barrelOffset.x * cos(rotation) - barrelOffset.y * sin(rotation))
	barrelPosition.y = global_position.y + (barrelOffset.x * sin(rotation) + barrelOffset.y * cos(rotation))
	emit_barrel_particles(barrelParticlesAmount, barrelPosition, barrelNormal, barrelParticlesColor)
	emit_tracer(barrelPosition, rayCast.global_transform.origin.distance_to(rayCast.get_collision_point() - (barrelPosition - global_position)), rotation, tracerDuration, tracerColor)

func emit_barrel_particles(amount: int, point: Vector2, normal: Vector2, color: Color):
	var particles = barrelParticleSystem.instance()
	particles.setup(amount, point, normal, color)
	get_tree().root.add_child(particles)

func emit_collision_particles(amount: int, point: Vector2, normal: Vector2, color: Color):
	var particles = collisionParticleSystem.instance()
	particles.setup(amount, point, normal, color)
	get_tree().root.add_child(particles)

func emit_tracer(point: Vector2, length: float, angle: float, duration: float, color: Color):
	var tracer = tracerSystem.instance()
	tracer.setup(point, length, angle, duration, color)
	get_tree().root.add_child(tracer)