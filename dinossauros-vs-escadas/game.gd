extends Node

@onready var jogador: Player = $GerenciadorDeMapa/Jogador
@onready var interface_gameplay: InterfaceGameplay = $CanvasLayer/InterfaceGameplay
@onready var interface_loja: InterfaceLoja = $CanvasLayerLoja/InterfaceLoja
@onready var loja: ObjetoInteragivel = $GerenciadorDeMapa/salas/SalaLoja/ObjetoInteragivel
@onready var sala_reliquia: SalaReliquia = $GerenciadorDeMapa/salas/SalaReliquia

var loja_aberta := false
var cura_da_loja_usada := false
var reliquia_da_sala: Reliquia
var reliquia_da_loja: Reliquia

const RELIQUIAS_DISPONIVEIS: Array[Reliquia] = [
	preload("res://elementos/item/reliquias/novo_coracao.tres"),
	preload("res://elementos/item/reliquias/botas.tres"),
	preload("res://elementos/item/reliquias/ovos.tres"),
	preload("res://elementos/item/reliquias/six_e_seven.tres")
]

func _ready() -> void:
	var reliquias := RELIQUIAS_DISPONIVEIS.duplicate()
	reliquia_da_sala = reliquias.pick_random()
	reliquias.erase(reliquia_da_sala)
	reliquia_da_loja = reliquias.pick_random()
	sala_reliquia.definir_reliquia(reliquia_da_sala)
	interface_loja.adicionar_reliquia(reliquia_da_loja, 20)
	loja.interagido.connect(abrir_loja)
	interface_loja.fechar_solicitado.connect(fechar_loja)
	interface_loja.cura_solicitada.connect(comprar_cura)
	interface_loja.item_compra_solicitada.connect(comprar_item)

func abrir_loja(_jogador: Player) -> void:
	if loja_aberta:
		return

	loja_aberta = true
	interface_gameplay.ocultar()
	interface_loja.exibir()
	jogador.set_physics_process(false)

func fechar_loja() -> void:
	if not loja_aberta:
		return

	loja_aberta = false
	interface_loja.ocultar()
	interface_gameplay.exibir()
	jogador.set_physics_process(true)

func comprar_cura() -> void:
	const CUSTO_CURA := 5
	const VALOR_CURA := 7

	if cura_da_loja_usada or jogador.componente_inventario.moedas < CUSTO_CURA:
		return

	jogador.componente_inventario.moedas -= CUSTO_CURA
	jogador.curar_vida(VALOR_CURA)
	cura_da_loja_usada = true
	interface_loja.desativar_cura()

func comprar_item(produto: ProdutoLoja) -> void:
	if produto == null or (produto.item == null and produto.reliquia == null):
		return
	if produto.reliquia != null and jogador.componente_inventario.possui_reliquia(produto.reliquia):
		return
	if jogador.componente_inventario.moedas < produto.preco:
		return

	jogador.componente_inventario.moedas -= produto.preco
	if produto.quantidade_bombas > 0:
		jogador.componente_inventario.bombas += produto.quantidade_bombas
	elif produto.reliquia != null:
		jogador.componente_inventario.add_reliquia(produto.reliquia)
	else:
		jogador.componente_inventario.add_item(produto.item)
