class_name Player
extends Entidade
@onready var mordida_sfx: AudioStreamPlayer = $Mordida/Mordida_sfx
@onready var arranhar_sfx: AudioStreamPlayer = $Arranhar/arranhar_sfx

func _ready() -> void:
	super._ready()


var direcaoAtual = Vector2.RIGHT
var posAtual = Vector2(80,0)
var rotaAtual = 0


func _physics_process(_delta: float) -> void:
	var direcao = Input.get_vector("Esquerda", "Direita", "Cima", "Baixo") #procura o input para cada vetor
	
	if direcao != Vector2.ZERO:
		direcaoAtual = direcao
	
	if direcaoAtual == Vector2.RIGHT:
		$SideBlitz.flip_h = false # Deixa o personagem olhando para a direita, padrão
		$SideBlitz.visible = true
		$UpBlitz.visible = false
		posAtual = Vector2(80,0)
		rotaAtual = 0
	elif direcaoAtual == Vector2.LEFT:
		$SideBlitz.flip_h = true # para a esquerda
		$SideBlitz.visible = true
		$UpBlitz.visible = false
		posAtual = Vector2(-80,0)
		rotaAtual = 0
	elif direcaoAtual == Vector2.UP:
		$UpBlitz.flip_v = false
		$UpBlitz.visible = true
		$SideBlitz.visible = false
		posAtual = Vector2(0,-60)
		rotaAtual = 90
	elif direcaoAtual == Vector2.DOWN:
		$UpBlitz.flip_v = true
		$UpBlitz.visible = true
		$SideBlitz.visible = false
		posAtual = Vector2(0,60)
		rotaAtual = 90
	$Arranhar.position = posAtual
	$Mordida.position = posAtual
	$Arranhar.rotation_degrees = rotaAtual
	$Mordida.rotation_degrees = rotaAtual
	
	if abs(direcao.x) > abs(direcao.y): #Força jogador a ir em uma direção outra
		direcao.y = 0 
	else: 
		direcao.x = 0 
	
	velocity = direcao * velocidade #dependendo da direção e variável velocidade do indivíduo, aplica o movimento
	
	move_and_slide() #permite movimentação e colisão em base do velocity
	
	if Input.is_action_just_pressed("ArranharAtk"):
		arranhar()
	if Input.is_action_just_pressed("MordidaAtk"):
		mordida()

var podeArranhar = true
var podeMorder = true
var arranharKnockback = 200
var mordidaKnockback = 500
var cooldownArranhar = 0.5
var cooldownMordida = 1.2

func arranhar() -> void:
	arranhar_sfx.play()
	realizar_ataque("Arranhar", $Arranhar, dano * 0.5, arranharKnockback, cooldownArranhar)

func mordida() -> void:
	mordida_sfx.play()
	realizar_ataque("Mordida", $Mordida, dano, mordidaKnockback, cooldownMordida)

var ataquesDisponiveis = {
	"Arranhar" = true,
	"Mordida" = true
}

func realizar_ataque(nome, area, dano_ataque:float, knockback:float, cooldown:float) -> void:
	if not ataquesDisponiveis[nome]:
		return
	ataquesDisponiveis[nome] = false
	
	var corposNaArea = area.get_overlapping_bodies()
	
	for corpo in corposNaArea:
		if corpo is Inimigo:
			var direcao = global_position.direction_to(corpo.global_position)
			corpo.knockback(direcao, knockback)
			corpo.receber_dano(dano_ataque)
			print("Inimigo atingido por ", nome, " , Dano Entregue:", dano_ataque)
	await get_tree().create_timer(cooldown).timeout
	ataquesDisponiveis[nome] = true

func receber_dano(valor: float) -> void:
	super.receber_dano(valor)
	
	if vida <= 0:
		morrer()

func morrer() -> void:
	get_tree().reload_current_scene()
