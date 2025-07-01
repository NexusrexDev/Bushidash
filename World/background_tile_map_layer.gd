extends TileMapLayer

var arena_size: Vector2 = Vector2(480, 360)
var tile_size: int = 16

var horizontal_vectors: Array[Vector2] = [Vector2(-2, 1), Vector2(31, 1)]
var vertical_vectors: Array[Vector2] = [Vector2(1, -2), Vector2(1, 23)]

func _ready() -> void:
    get_tree().root.connect("size_changed", Callable(self, "_update_background"))
    _update_background()

func _update_background() -> void:
    clear()
    var offset: Vector2 = _calculate_offset()
    _place_background_tiles(offset.x, offset.y)

func _calculate_offset() -> Vector2:
    var viewport_size: Vector2 = get_viewport().get_visible_rect().size

    var extra_width: int = max(0, viewport_size.x - arena_size.x)
    var extra_height: int = max(0, viewport_size.y - arena_size.y)
    var extra_tiles_x: int = int(ceil(extra_width / tile_size))
    var extra_tiles_y: int = int(ceil(extra_height / tile_size))
    var offset_x: int = int(ceil(extra_tiles_x / 2))
    var offset_y: int = int(ceil(extra_tiles_y / 2))
    
    if extra_tiles_x % 2 == 0:
        offset_x += 1 
    if extra_tiles_y % 2 == 0:
        offset_y += 1 

    return Vector2(offset_x, offset_y)    

func _place_background_tiles(offset_x: int, offset_y: int) -> void:
    for i in range(offset_x):
        set_pattern(horizontal_vectors[0] - Vector2(i, 0), tile_set.get_pattern(0))
        set_pattern(horizontal_vectors[1] + Vector2(i, 0), tile_set.get_pattern(0))
    
    for i in range(offset_y):
        set_pattern(vertical_vectors[0] - Vector2(0, i), tile_set.get_pattern(1))
        set_pattern(vertical_vectors[1] + Vector2(0, i), tile_set.get_pattern(1))