extends Area2D
class_name Projetil

var direcao:Vector2
@export var velocidade:float = 200.0

func _physics_process(delta: float) -> void:
	position += direcao * velocidade * delta

func _timeout() -> void:
	queue_free()


func _on_body_entered(_body: Node) -> void:
	pass


func _on_body_exited(_body: Node) -> void:
	pass
