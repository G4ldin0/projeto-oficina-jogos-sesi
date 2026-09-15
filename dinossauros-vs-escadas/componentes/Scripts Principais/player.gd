class_name Player
extends Entidade

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
		$SpriteBlitz.flip_h = false # Deixa o personagem olhando para a direita, padrão
		posAtual = Vector2(80,0)
		rotaAtual = 0
	elif direcaoAtual == Vector2.LEFT:
		$SpriteBlitz.flip_h = true # para a esquerda
		posAtual = Vector2(-80,0)
		rotaAtual = 0
	elif direcaoAtual == Vector2.UP:
		posAtual = Vector2(0,-60)
		rotaAtual = 90
	elif direcaoAtual == Vector2.DOWN:
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

func arranhar() -> void:
	var corposNaArea = $Arranhar.get_overlapping_bodies() #Procura corpos que estão sobrepondo a colisão do arranhar
	var danoArranhar = dano * 0.5 #Feito para futuros cálculos de dano
	
	for corpo in corposNaArea: # 'para cada corpo na variável corposNaArea, faz o seguinte'
		if corpo is Inimigo: # procura se o corpo é um inimigo, classe do inimigo
			corpo.receber_dano(danoArranhar) #Puxa a função do inimigo receber_dano
			print("Inimigo atingido por arranhão!, Dano Entregue:", danoArranhar)

func mordida() -> void: # É basicamente replicado do arranhar.
	var corposNaArea = $Mordida.get_overlapping_bodies()
	var danoMordida = dano
	
	for corpo in corposNaArea:
		if corpo is Inimigo:
			corpo.receber_dano(danoMordida)
			print("Inimigo atingido por mordida!, Dano Entregue:", danoMordida)
