
# ----- KEYBOARD CONSTANTS ----- #

.eqv KEYBOARD_READY 0xffff0000 # Keyboard MMIO address
.eqv KEYBOARD_VALUE 0xffff0004 # Keyboard MMIO address

# ----- KEYBOARD UTILITIES ----- #

.macro READ_KEYSTROKE(%out_value)
	lw %out_value, KEYBOARD_READY
	beqz %out_value, end
	lw %out_value, KEYBOARD_VALUE
end:
.end_macro
