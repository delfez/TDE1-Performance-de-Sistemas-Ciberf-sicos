.data
	
array: .word 4, 3, 9, 5, 2, 1

size:  .word 6

.text
.globl main
main:
   
    la $s0, array #registrador $s0 agora contem o endereço na memória do primeiro elemento do array

    lw $s1, size #registrador $s1 agora contem o valor de size (6)

    li $t0, 0 # registrador $t0 agora contem o valor 0, servira como contador para o loop externo

loop_externo:
 
    add $t7, $s1, -1 #faz o calculo (size - 1) e guarda no registrador $t7, que sera a condicao de termino para o loop externo
	
    bge $t0, $t7, print_array #caso o contador do loop externo seja maior ou igual a (size - 1), pula para a label 'print_array'

    li $t1, 0 #contador do loop interno

loop_interno:

    sub $t2, $s1, $t0 #primeira parte do calculo do limite superior do loop interno ( size - contador ext.)

    #como queremos que a ultima comparacao seja entre o penultimo elemento, pelo contador iniciar em 0, subtraimos 1 alem do contador externo.
    addi $t2, $t2, -1 #segunda parte do calculo do limite superior do loop interno ( size - contador ext. - 1 ) 

    bge $t1, $t2, terminar_interno #verifica se o loop interior terminou (se $t1 >= size - contador ext. - 1)

    #Calcular enderecos e atribuir enderecos

    sll $t3, $t1, 2 #calcula o offset do elemento do array atual. Como cada elemento ocupa 4 bytes, o (offset sera 4 * contador interno)
    # esse calculo e feito usando o shift left logical, que move os bits de $t1 para a esquerda duas vezes, o que equivale a multiplicar por 2^2.
    
    add $t3, $s0, $t3 #calcula o endereço abosoluto do elemento da iteração, somando o endereço inicial do array com o offset
    
    lw  $t4, 0($t3) #atribui o valor obtido no endereço do elemento da iteração ao registrador $t4, para podermos fazer a comparação
    
    lw  $t5, 4($t3) #pega o valor encontrado no endereço adjascente ao primeiro valor obtido na ultima linha 
    
    # Comparar e trocar posicoes

    ble $t4, $t5, no_swap #se o valor do elemento atual for menor ou igual ao valor do proximo, não trocamos suas posições

    sw $t5, 0($t3)#coloca o valor do registrador $t5 no endereço apontado por $t3. 

    sw $t4, 4($t3)#coloca o valor do registrador $t4 no endereço apontado por $t3 + 4 bytes.

no_swap:
   
    add $t1, $t1, 1 #incrementa o contador do loop interno

    j loop_interno #volta para o inicio do loop interno

terminar_interno:

    add $t0, $t0, 1 #incrementa o contador do loop externo
    
    j loop_externo#volta pra o inicio do loop externo

# --- Printing the Sorted Array ---
print_array:

    li $t0, 0 #inicializa o contador do loop para imprimir o array

print_loop:
    			
    bge $t0, $s1, exit #se o contador do loop de impressão for maior ou igual ao tamanho do array, vai para label exit.

    sll $t1, $t0, 2 #calcula o offset do elemento atual
    add $t1, $s0, $t1 #calcula o endereço do elemento atual, somando o endereço inicial do array com o offset aproriado.
    
    lw $a0, 0($t1) #atribui o valor do registrador $t1 no registrador $a0, necessáro para impressão

    li $v0, 1 #codigo de servico 1 para imprimir um inteiro
    
    syscall

    add $t0, $t0, 1 #incrementa o contador do loop
    
    j print_loop #retorna ao inicio do loop

exit:

    li $v0, 10 #codigo de servico 10 para sair

    syscall 
