.data

total: 40
anterior: 1
atual: 1
contador: 2
prox: 0
fib:

.text

lw $s1, total
lw $s2, anterior
lw $s3, atual
lw $s4, contador
lw $s5, prox
la $s0, fib

sw $s2, 0($s0)
addi $s0, $s0, 4
sw $s3, 0($s0)
addi $s0, $s0, 4

while:
	slt $s6, $s4, $s1
	beq $s6, $zero, exit_while
	add $s5, $s3, $s2
        sw $s2, 0($s0)	
	addi $s0, $s0, 4
	add $s2, $s3, $zero
        add $s3, $s5, $zero
 	addi $s4, $s4, 1
	j while

exit_while:

sw $s1, total
sw $s2, anterior
sw $s3, atual
sw $s4, contador
sw $s5, prox




