class_name InterfaceGameplay
extends Interface

@export var player_ref:Player = null

@export var sprite: Sprite2D
@export var barra_vida: ProgressBar
@export var barra_vida_label: Label
@export var cooldown_mordida: TextureProgressBar
@export var cooldown_arranhao: TextureProgressBar

@export var boss_hud: Control
@export var nome_boss: Label
@export var barra_vida_boss: ProgressBar
@export var barra_vida_boss_label: Label
@export var quantidade_bombas: Label
@export var quantidade_moedas: Label
@export var item_escolhido: TextureRect
@export var lista_reliquias: VBoxContainer

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
	_atualizar_quantidade_bombas(player_ref.componente_inventario.bombas)
	_atualizar_quantidade_moedas(player_ref.componente_inventario.moedas)
	player_ref.componente_inventario.recurso_alterado.connect(_atualizar_recurso)
	player_ref.componente_inventario.item_selecionado.connect(_atualizar_item_recurso)
	player_ref.componente_inventario.reliquias_alteradas.connect(_atualizar_reliquias)
	_atualizar_item_recurso(player_ref.componente_inventario.obter_item_selecionado())
	_atualizar_reliquias(player_ref.componente_inventario.obter_reliquias())

func _atualizar_quantidade_bombas(quantidade: int) -> void:
	quantidade_bombas.text = str(quantidade)

func _atualizar_quantidade_moedas(quantidade: int) -> void:
	quantidade_moedas.text = str(quantidade)

func _atualizar_recurso(nome_recurso: StringName, quantidade: int) -> void:
	match nome_recurso:
		&"bombas":
			_atualizar_quantidade_bombas(quantidade)
		&"moedas":
			_atualizar_quantidade_moedas(quantidade)
		&"item":
			_atualizar_item_escolhido(player_ref.componente_inventario.obter_item_selecionado())
		_: pass

func _atualizar_item_recurso(_item: Item) -> void:
	_atualizar_recurso(&"item", 0)

func _atualizar_item_escolhido(item: Item) -> void:
	item_escolhido.texture = item.sprite if item != null else null
	item_escolhido.visible = item != null

func _atualizar_reliquias(reliquias: Array[Reliquia]) -> void:
	for filho in lista_reliquias.get_children():
		filho.queue_free()

	lista_reliquias.visible = not reliquias.is_empty()
	for reliquia in reliquias:
		var linha := HBoxContainer.new()
		linha.add_theme_constant_override("separation", 6)
		lista_reliquias.add_child(linha)

		if reliquia.sprite != null:
			var icone := TextureRect.new()
			icone.custom_minimum_size = Vector2(32, 32)
			icone.texture = reliquia.sprite
			icone.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
			icone.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
			linha.add_child(icone)

		var nome := Label.new()
		nome.text = reliquia.nome
		nome.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		linha.add_child(nome)

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
