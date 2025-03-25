extends Node3D

var turnInvisible = false;
var delayStart = 0;
@export var timeToDelay = 1000;

func _ready():
	$"../cookiekid".playerTradedSuccessfully.connect(_turnInvisible);

func _process(delta):
	if(turnInvisible and abs(Time.get_ticks_msec() - delayStart) > timeToDelay):
		queue_free()

func _turnInvisible():
	turnInvisible = true;
	delayStart = Time.get_ticks_msec();
