
# ----- MAP CONSTANTS ----- #

.eqv MAP_WIDTH 0x10 # 16 units
.eqv MAP_HEIGHT 0x10 # 16 units

.eqv MAP_WIDTH_SHIFT 4 # 0x10 = 1 << 4

.eqv MAP_MEMORY_SIZE 0x100 # 0x10 * 0x10 = 0x100

# ----- TILE CONSTANTS ----- #

.eqv T_EMPTY  0x00
.eqv T_COIN   0x01
.eqv T_ENEMY  0x02
.eqv T_PLAYER 0x04
.eqv T_WALL   0x08
.eqv T_GOAL   0x09


# ----- TILE COLORS ----- #

.macro TILE_COLORS
	.word C_LIGHT_GRAY
	.word C_YELLOW
	.word C_RED
	.word C_RED
	.word C_CYAN
	.word C_CYAN
	.word C_DARK_CYAN
	.word C_DARK_CYAN
	.word C_DARK_GRAY
	.word C_GREEN
.end_macro 

# ----- MAP UTILITIES ----- #

.macro LOAD_MAP_OFFSET(%out_offset, %in_x_coord, %in_y_coord)
	or %out_offset, $zero, %in_y_coord
	sll %out_offset, %out_offset, MAP_WIDTH_SHIFT
	or %out_offset, %out_offset, %in_x_coord
.end_macro

.macro SET_TILE(%inout_value, %in_mask)
	or %inout_value, %inout_value, %in_mask
.end_macro

.macro CLEAR_TILE(%inout_value, %in_mask)
	not %inout_value, %inout_value
	or %inout_value, %inout_value, %in_mask
	not %inout_value, %inout_value
.end_macro