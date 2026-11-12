extends Control

@export var player_ref:Player = null

@export var sprite: Sprite2D
@export var barra_vida: ProgressBar
@export var barra_vida_label: Label
@export var cooldown_mordida: TextureProgressBar
@export var cooldown_arranhao: TextureProgressBar

func _ready() -> void:
	#preciso colocar isso depois do gerenciador de mapas, que é quem está instanciando o nó do jogador
	_atualizar_ui_label_vida()
	barra_vida.max_value = player_ref.vida_maxima
	player_ref.tomou_dano.connect(_ui_dano)
	cooldown_arranhao.max_value = player_ref.timer_arranhao.wait_time
	cooldown_mordida.max_value = player_ref.timer_mordida.wait_time

func _atualizar_ui_label_vida() -> void:
	barra_vida_label.text = "%.0f/%.0f" % [player_ref.vida, player_ref.vida_maxima]

func _ui_dano() -> void:
	#barra de vida
	barra_vida.value = player_ref.vida
	_atualizar_ui_label_vida()
	
	#imagem do rosto
	sprite.frame = 1
	get_tree().create_timer(0.5).timeout.connect(func(): sprite.frame = 0)

func _physics_process(_delta: float) -> void:
	cooldown_arranhao.value = player_ref.timer_arranhao.time_left
	cooldown_arranhao.modulate = Color(0,0,0,0) if player_ref.timer_arranhao.time_left == 0.0 else Color(1,1,1,1)
	cooldown_mordida.value = player_ref.timer_mordida.time_left
	cooldown_mordida.modulate = Color(0,0,0,0) if player_ref.timer_mordida.time_left == 0.0 else Color(1,1,1,1)
