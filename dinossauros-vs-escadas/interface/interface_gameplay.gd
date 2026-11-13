extends Control

@export var player_ref:Player = null

@export var sprite: Sprite2D
@export var barra_vida: ProgressBar
@export var barra_vida_label: Label
@export var cooldown_mordida: TextureProgressBar
@export var cooldown_arranhao: TextureProgressBar

@onready var boss_hud: Control = %BossHUD
@onready var nome_boss: Label = %NomeBoss
@onready var barra_vida_boss: ProgressBar = %BarraVidaBoss
@onready var barra_vida_boss_label: Label = %BarraVidaBossLabel

var boss_atual: Inimigo

func _ready() -> void:
	boss_hud.visible = false
	#preciso colocar isso depois do gerenciador de mapas, que é quem está instanciando o nó do jogador
	barra_vida.max_value = player_ref.vida_maxima
	barra_vida.value = player_ref.vida
	barra_vida_label.text = "%.0f/%.0f" % [player_ref.vida, player_ref.vida_maxima]
	player_ref.vida_alterada.connect(_ui_dano)
	cooldown_arranhao.max_value = player_ref.timer_arranhao.wait_time
	cooldown_mordida.max_value = player_ref.timer_mordida.wait_time

func mostrar_boss(boss: Inimigo, nome: String) -> void:
	if is_instance_valid(boss_atual):
		_desconectar_boss(boss_atual)

	boss_atual = boss
	nome_boss.text = nome
	barra_vida_boss.max_value = boss.vida_maxima
	_atualizar_hud_boss(boss.vida, boss.vida_maxima)
	boss.vida_alterada.connect(_atualizar_hud_boss)
	boss.morreu.connect(ocultar_boss)
	boss_hud.visible = true

func ocultar_boss() -> void:
	boss_hud.visible = false
	_desconectar_boss(boss_atual)
	boss_atual = null

func _atualizar_hud_boss(vida_atual: float, vida_maxima: float) -> void:
	barra_vida_boss.max_value = vida_maxima
	barra_vida_boss.value = maxf(vida_atual, 0.0)
	barra_vida_boss_label.text = "%.0f/%.0f" % [maxf(vida_atual, 0.0), vida_maxima]

func _desconectar_boss(boss: Inimigo) -> void:
	if not is_instance_valid(boss):
		return
	if boss.vida_alterada.is_connected(_atualizar_hud_boss):
		boss.vida_alterada.disconnect(_atualizar_hud_boss)
	if boss.morreu.is_connected(ocultar_boss):
		boss.morreu.disconnect(ocultar_boss)

func _ui_dano(vida_atual: float, vida_maxima: float) -> void:
	#barra de vida
	barra_vida.max_value = vida_maxima
	barra_vida.value = vida_atual
	barra_vida_label.text = "%.0f/%.0f" % [vida_atual, vida_maxima]
	
	#imagem do rosto
	sprite.frame = 1
	get_tree().create_timer(0.5).timeout.connect(func(): sprite.frame = 0)

func _physics_process(_delta: float) -> void:
	cooldown_arranhao.value = player_ref.timer_arranhao.time_left
	cooldown_arranhao.modulate = Color(0,0,0,0) if player_ref.timer_arranhao.time_left == 0.0 else Color(1,1,1,1)
	cooldown_mordida.value = player_ref.timer_mordida.time_left
	cooldown_mordida.modulate = Color(0,0,0,0) if player_ref.timer_mordida.time_left == 0.0 else Color(1,1,1,1)
