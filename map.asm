
# ----- MAP CONSTANTS ----- #

.eqv MAP_WIDTH 0x20 # 32 units
.eqv MAP_HEIGHT 0x20 # 32 units

.eqv MAP_WIDTH_SHIFT 5 # 0x20 = 1 << 5

.eqv MAP_MEMORY_SIZE 0x1000 # 0x20 * 0x20 * 4 = 0x1000

# ----- TILE CONSTANTS ----- #

.eqv T_EMPTY  0x00
.eqv T_WALL   0x04
.eqv T_PLAYER 0x02
.eqv T_ENEMY  0x03
.eqv T_COIN   0x04
.eqv T_GOAL   0x05

# ----- MAP UTILITIES ----- #

.macro LOAD_MAP_OFFSET(%out_offset, %in_x_coord, %in_y_coord)
	or %out_offset, $zero, %in_y_coord
	sll %out_offset, %out_offset, MAP_WIDTH_SHIFT
	or %out_offset, %out_offset, %in_x_coord
.end_macro
