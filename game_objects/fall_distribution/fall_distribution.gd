extends Node2D

var endpoints: Dictionary

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func compute_locations():
	pass
	# need to count total number of paths
	# need to count how many paths terminate at each endpoint
	# endpoint / total to get a percentage

func clear_endpoints():
	endpoints = {}

func count_paths(peg: Peg):
	var total = 0
	if peg.connections.is_empty():
		if endpoints.has(peg.idx):
			endpoints[peg.idx] = endpoints[peg.idx] + 1
		else:
			endpoints[peg.idx] = 1
		return 1
	else:
		for peg_out in peg.connections:
			total += count_paths(peg_out)
	return total

func print_endpoints():
	print("Endpoints:")
	for p in endpoints:
		print(str(p) + ": " + str(endpoints[p]))

func get_endpoints():
	return endpoints
