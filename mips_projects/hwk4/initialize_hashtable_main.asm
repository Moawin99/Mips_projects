# Hashtable of Book objects
.data
.align 2
capacity: .word 11
element_size: .word 28
hashtable:
.word 61904738 # capacity
.word 23643763 # size
.word 1536138 # element_size
.byte 83 218 169 58 223 46 44 1 129 41 126 155 209 6 163 229 38 250 95 209 105 109 229 92 141 35 166 158 
.byte 133 176 207 183 68 251 221 237 191 212 196 186 94 207 65 67 220 191 244 201 131 169 210 52 138 234 72 203 
.byte 187 11 180 236 157 148 75 103 30 134 249 1 217 251 86 30 53 204 80 200 220 168 194 5 199 67 168 106 
.byte 214 215 127 103 232 40 250 213 28 211 100 237 19 84 45 77 247 254 215 228 120 211 156 163 182 95 117 244 
.byte 124 200 176 170 73 42 87 135 224 197 221 45 49 119 243 170 102 84 33 240 189 126 185 46 188 35 70 113 
.byte 242 244 207 248 218 237 155 2 255 223 194 57 45 171 235 125 170 189 162 110 217 219 226 41 197 30 216 68 
.byte 41 67 145 114 7 22 61 67 109 1 136 211 22 176 192 114 68 42 211 44 206 203 223 118 233 108 209 182 
.byte 109 218 70 50 3 22 10 182 204 233 228 254 20 130 62 239 157 165 230 231 147 10 185 157 128 53 166 97 
.byte 128 234 16 248 127 225 35 28 79 52 193 161 123 82 193 181 158 216 160 42 21 209 53 140 58 48 49 13 
.byte 84 25 219 57 105 35 184 88 113 229 201 205 198 35 85 8 145 221 106 48 127 181 254 119 118 27 86 122 
.byte 68 222 187 113 41 26 234 4 13 54 169 18 191 237 96 184 199 232 7 24 156 133 149 116 218 228 235 69 

.text
.globl main
main:
la $a0, hashtable
lw $a1, capacity
lw $a2, element_size
jal initialize_hashtable

move $t0, $v0

# Write code to check the correctness of your code!
li $v0, 10
syscall

.include "hwk4.asm"
