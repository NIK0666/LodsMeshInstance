extends MeshInstance

export var Dist_L1 = 20
export var Dist_L2 = 30
export var Dist_L3 = 40

var distance = 0
var lod_number = -1
var lod_meshes = []

onready var player_node = get_tree().get_root().get_node("Level/Player")

# Called when the node enters the scene tree for the first time.
func _ready():
	prepare()

func _physics_process(delta):
	distance = self.global_transform.origin.distance_to(player_node.get_global_transform().origin)
	if distance < Dist_L1:
		change_lod(0)
	elif distance < Dist_L2:
		change_lod(1)
	elif distance < Dist_L3:
		change_lod(2)
	elif distance >= Dist_L3:
		change_lod(3)

func prepare():
	lod_meshes = [self.mesh]
	
	materials_from_instance(self.mesh)
	
	var res_path = self.mesh.resource_path
	var res_type = get_res_type(res_path)
	for i in range(3):
		var mesh = load(res_path.split("." + res_type).join("_LOD" + str(i + 1) + "." + res_type)) as Mesh
		materials_from_instance(mesh)
		lod_meshes.push_back(mesh)


func materials_from_instance(mesh):
	for mat_ind in range(self.get_surface_material_count()):
		var mat = self.get_surface_material(mat_ind)
		mesh.surface_set_material(mat_ind, mat)

func get_res_type(res_path):
	var temp = res_path.split(".")
	return temp[temp.size() - 1]

func change_lod(num):
	if lod_number == num:
		return
	
	lod_number = num
	self.mesh = lod_meshes[num]





