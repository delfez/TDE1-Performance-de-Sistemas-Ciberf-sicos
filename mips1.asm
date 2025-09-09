.data

doismilevintecinco: .word 2025
aniversario: .word 2003

.text
.globl main

main: 

lw $s0, doismilevintecinco
lw $t0, aniversario 

add $t1, $s0, $t0

move $a0, $t1 #atribui o valor do registrador $t1 no registrador $a0, necessáro para impressão

li $v0, 1 #codigo de servico 1 para imprimir um inteiro
    
syscall

li $v0, 10 #codigo de servico 10 para sair

syscall 