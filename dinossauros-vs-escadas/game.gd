extends Node

@onready var jogador: Player = $GerenciadorDeMapa/Jogador
@onready var interface_gameplay: InterfaceGameplay = $CanvasLayer/InterfaceGameplay
@onready var interface_loja: InterfaceLoja = $CanvasLayerLoja/InterfaceLoja
@onready var loja: ObjetoInteragivel = $GerenciadorDeMapa/salas/SalaLoja/ObjetoInteragivel

var loja_aberta := false
var cura_da_loja_usada := false

func _ready() -> void:
	loja.interagido.connect(abrir_loja)
	interface_loja.fechar_solicitado.connect(fechar_loja)
	interface_loja.cura_solicitada.connect(comprar_cura)

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
