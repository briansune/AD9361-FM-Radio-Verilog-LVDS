
reg_231 = 0x50
reg_232 = 0x00

reg_233 = 0x2D
reg_234 = 0x2D
reg_235 = 0x2D

print('The PLL fractional value:')
print((0x2D << 16) + (reg_234 << 8) + reg_233)
print('The PLL integer value:')
print(((reg_232 & 0x7) << 8) + reg_231)

# For register 005, 2^(N+1)
# if 70M to 93.75M use divide 128, code = 6
# if 93.5M to 187.5M use divide 64, code = 5
