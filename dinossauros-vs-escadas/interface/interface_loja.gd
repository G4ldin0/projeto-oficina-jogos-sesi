class_name InterfaceLoja
extends Interface

signal fechar_solicitado
signal cura_solicitada
signal item_compra_solicitada(produto: ProdutoLoja)

@onready var botao_cura: Button = %BotaoCura
@onready var lista_produtos: VBoxContainer = %ListaProdutos

@export var produtos: Array[ProdutoLoja] = []

func _ready() -> void:
	ocultar()
	_criar_lista_produtos()

func _unhandled_input(event: InputEvent) -> void:
	if visible and event.is_action_pressed("ui_cancel"):
		fechar_solicitado.emit()

func _on_fechar_pressed() -> void:
	fechar_solicitado.emit()

func _on_cura_pressed() -> void:
	cura_solicitada.emit()

func desativar_cura() -> void:
	botao_cura.disabled = true

func _criar_lista_produtos() -> void:
	for filho in lista_produtos.get_children():
		filho.queue_free()

	for produto in produtos:
		if produto == null or produto.item == null:
			continue

		var linha := HBoxContainer.new()
		linha.alignment = BoxContainer.ALIGNMENT_CENTER
		linha.add_theme_constant_override("separation", 12)
		lista_produtos.add_child(linha)

		var imagem := TextureRect.new()
		imagem.custom_minimum_size = Vector2(56, 56)
		imagem.texture = produto.item.sprite
		imagem.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		imagem.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		linha.add_child(imagem)

		var botao := Button.new()
		botao.custom_minimum_size = Vector2(220, 56)
		botao.text = "%s - %d moedas" % [produto.item.nome, produto.preco]
		botao.pressed.connect(_solicitar_compra.bind(produto))
		linha.add_child(botao)

func _solicitar_compra(produto: ProdutoLoja) -> void:
	item_compra_solicitada.emit(produto)
