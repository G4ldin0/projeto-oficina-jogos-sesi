extends AudioStreamPlayer

const MUSICA_INICIAL: AudioStream = preload("res://assets/audio/musica-do-djabo.mp3")
const MUSICA_BOSS: AudioStream = preload("res://assets/audio/Steel_Haze_(Rusted_Pride).wav")
const MUSICA_FINAL: AudioStream = preload("res://assets/audio/His_Theme.wav")
const VOLUME_MINIMO := -80.0
const VOLUME_MAXIMO := 0.0
const PASSO_VOLUME := 3.0

func _ready() -> void:
	tocar_musica_inicial()

func tocar_musica_inicial() -> void:
	_tocar(MUSICA_INICIAL)

func tocar_musica_boss() -> void:
	_tocar(MUSICA_BOSS)

func tocar_musica_final() -> void:
	_tocar(MUSICA_FINAL)

func silenciar() -> void:
	stop()

func aumentar_volume() -> void:
	volume_db = minf(volume_db + PASSO_VOLUME, VOLUME_MAXIMO)

func diminuir_volume() -> void:
	volume_db = maxf(volume_db - PASSO_VOLUME, VOLUME_MINIMO)

func obter_volume_percentual() -> int:
	return roundi((volume_db - VOLUME_MINIMO) * 100.0 / -VOLUME_MINIMO)

func _tocar(nova_musica: AudioStream) -> void:
	if stream == nova_musica and playing:
		return

	stop()
	stream = nova_musica
	play()
