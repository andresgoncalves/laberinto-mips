
# ----- VIDEO CONSTANTS ----- #

.eqv VIDEO_WIDTH 0x20 # 1024/32 = 0x20
.eqv VIDEO_HEIGHT 0x20 # 1024/32 = 0x20
.eqv VIDEO_DEPTH 4 # 1 word = 4 bytes

.eqv VIDEO_WIDTH_SHIFT 5 # 0x20 = 1 << 5
.eqv VIDEO_DEPTH_SHIFT 2 # 4 = 1 << 2

.eqv VIDEO_MEMORY_SIZE 0x1000 # 0x20 * 0x20 * 4 = 0x1000

# ----- COLOR CONSTANTS ----- #

.eqv C_BLACK 0x000000
.eqv C_WHITE 0xffffff

.eqv C_GRAY       0x808080
.eqv C_LIGHT_GRAY 0xc0c0c0
.eqv C_DARK_GRAY  0x404040

.eqv C_RED     0xff0000
.eqv C_GREEN   0x00ff00
.eqv C_BLUE    0x0000ff
.eqv C_CYAN    0x00ffff
.eqv C_YELLOW  0xffff00
.eqv C_MAGENTA 0xff00ff

.eqv C_LIGHT_RED     0xff8080
.eqv C_LIGHT_GREEN   0x80ff80
.eqv C_LIGHT_BLUE    0x8080ff
.eqv C_LIGHT_CYAN    0x80ffff
.eqv C_LIGHT_YELLOW  0xffff80
.eqv C_LIGHT_MAGENTA 0xff80ff

.eqv C_DARK_RED     0x800000
.eqv C_DARK_GREEN   0x008000
.eqv C_DARK_BLUE    0x000080
.eqv C_DARK_CYAN    0x008080
.eqv C_DARK_YELLOW  0x808000
.eqv C_DARK_MAGENTA 0x800080

# ----- VIDEO UTILITIES ----- #

.macro LOAD_VIDEO_OFFSET(%out_offset, %in_x_coord, %in_y_coord)
	or %out_offset, $zero, %in_y_coord
	sll %out_offset, %out_offset, VIDEO_WIDTH_SHIFT
	or %out_offset, %out_offset, %in_x_coord
	sll %out_offset, %out_offset, VIDEO_DEPTH_SHIFT
.end_macro
