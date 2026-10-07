extends Node2D

@export var barra_equilibrio: ProgressBar
@export var texto_qte: Label
@export var temporizador_qte: Timer
@export var espera_qte: Timer

var equilibrio: float = 100.0
var perdida_equilibrio: float = 2.0
var qte_activo: bool = false

var accion_correcta: StringName = &"qte_left"
var tecla_correcta: String = "A"


func _ready() -> void:
	barra_equilibrio.value = equilibrio
	texto_qte.visible = false

	temporizador_qte.timeout.connect(fallar_qte)
	espera_qte.timeout.connect(iniciar_qte)


func _process(delta: float) -> void:
	equilibrio -= perdida_equilibrio * delta

	if qte_activo:
		revisar_teclas()

	equilibrio = clamp(equilibrio, 0.0, 100.0)

	barra_equilibrio.value = equilibrio

func revisar_teclas() -> void:
	# A
	if Input.is_action_just_pressed("qte_left"):
		if accion_correcta == &"qte_left":
			acertar_qte()
		else:
			fallar_qte()

	# D
	elif Input.is_action_just_pressed("qte_right"):
		if accion_correcta == &"qte_right":
			acertar_qte()
		else:
			fallar_qte()

	# W
	elif Input.is_action_just_pressed("qte_up"):
		if accion_correcta == &"qte_up":
			acertar_qte()
		else:
			fallar_qte()

	# S
	elif Input.is_action_just_pressed("qte_down"):
		if accion_correcta == &"qte_down":
			acertar_qte()
		else:
			fallar_qte()


func iniciar_qte() -> void:
	qte_activo = true

	var numero: int = randi_range(0, 3)

	if numero == 0:
		accion_correcta = &"qte_left"
		tecla_correcta = "A"

	elif numero == 1:
		accion_correcta = &"qte_right"
		tecla_correcta = "D"

	elif numero == 2:
		accion_correcta = &"qte_up"
		tecla_correcta = "W"

	else:
		accion_correcta = &"qte_down"
		tecla_correcta = "S"

	texto_qte.text = "PRESIONA " + tecla_correcta
	texto_qte.visible = true

	temporizador_qte.start()

func acertar_qte() -> void:
	qte_activo = false
	temporizador_qte.stop()

	equilibrio += 8.0

	texto_qte.text = "¡ACIERTO!"

	espera_qte.start()


func fallar_qte() -> void:
	if not qte_activo:
		return

	qte_activo = false
	temporizador_qte.stop()

	equilibrio -= 20.0

	texto_qte.text = "¡FALLASTE!"

	espera_qte.start()
