*&---------------------------------------------------------------------*
*& Report ZR_STRING_FIND_ANY_NOT_OF
*&---------------------------------------------------------------------*
*
* string_func - find, find_...
*
* As funções de busca find e find_... procuram texto pelos caracteres especificados
*   em substring ou por uma correspondência com uma expressão regular especificada em regex,
*   onde os parâmetros opcionais off e len determinam a subárea a ser pesquisada,
*   e a ocorrência da correspondência pode ser especificada no parâmetro opcional occ.
*
*   ◾ Se o argumento pcre for usado, regex deve conter uma expressão regular PCRE.
*   ◾ Se o argumento regex for usado, regex deve conter uma expressão regular POSIX.
*
*   O valor de retorno tem o tipo i .
*   É case sensitive por padrão
*
* Se uma busca não for bem-sucedida, todas as funções retornam o valor -1.
*
* Os parâmetros opcionais off, len e occ têm os seguintes significados quando combinados:
*   ◾ Se occ for positivo, a subárea definida por off e len será pesquisada da esquerda para a direita.
*   ◾ Se occ for negativo, a subárea definida por off e len será pesquisada da direita para a esquerda.
*
*   A ocorrência da correspondência especificada por occ refere-se ao intervalo de busca definido por off e len.
*
**********************************************************************
*
*   FIND_END_ANY_NOT_OF
*  A função find_any_not_of retorna o deslocamento da ocorrência de qualquer caractere que não esteja
*     em substring e também é sempre sensível a maiúsculas e minúsculas. Se substring estiver vazia, o valor -1 será retornado.
*
**********************************************************************
*&---------------------------------------------------------------------*

REPORT zr_string_find_any_not_of NO STANDARD PAGE HEADING  .

DATA(lv_text) = 'O rato roeu a roupa do rei de Roma e ainda ficou com fome'.
DATA: lv_find TYPE i.

**********************************************************************
WRITE:/ lv_text. ULINE. SKIP.
**********************************************************************

" Find any not of -----------------------------------------------
* 4. ... find_any_not_of( val = text  sub = substring
*                      [off = off] [len = len] [occ = occ] ) ...

" Obs.: any of e any not of trabalham no caractere e são case sensitive, sem possibilidade de mudança

" Nota: A diferença de find_any_of para find_any_not_of é que:
"   Enquanto find_any_of retorna o deslocamento da ocorrência de qualquer caractere dentro da substring,
"     o find_any_not_of retorna qualquer caractere que não esteja na substring

" Find
lv_find = find( val = lv_text sub = 'r' ).     " 2: 'r' da palavra 'rato'
WRITE:/ 'FIND:', lv_find.

" Find any not of ------------------------------------------------------
lv_find = find_any_not_of( val = lv_text sub = 'rato' ).     " 0: encontra o primeiro 'O' de 'O' rato ....
WRITE:/ 'FIND_ANY_NOT_OF:', lv_find.

" OCC, OFF, LEN ------------------------------------------------------
" O rato roeu a roupa do rei de Roma e ainda ficou com fome

" Obs.: Com essa função, é interessante utilizar esses outros parâmetros
lv_find = find_any_not_of( val = lv_text sub = 'rato' occ = 2 ).     " 1: encontra o space em O' 'rato
WRITE:/ 'FIND_ANY_NOT_OF:', lv_find.

" Note que aqui vai ter um resultado diferente
" off 8: 'o' da palavra 'roeu'. Como o 'o' está contido nessa palavra e também na substring,
"         então vai buscar a próxima ocorrência que estiver fora dessa substring.
"         Nesse caso, vai encontrar o 'e' da palavra 'roeu', index 9
lv_find = find_any_not_of( val = lv_text sub = 'rato' off = 8 len = 30 occ = 1 ).   " 9: encontra o space em O' 'rato
WRITE:/ 'FIND_ANY_NOT_OF:', lv_find.

lv_find = find_any_not_of( val = lv_text sub = 'rato roeu a roupa' off = 2 occ = 1 ).  " 20: encontra o 'd' em ... 'd'o rei ...
WRITE:/ 'FIND_ANY_NOT_OF:', lv_find.

" 55: encontra o 'm' em fo'm'e, index 55, pois é a primeira ocorrência de um caractere que não está na substring
lv_find = find_any_not_of( val = lv_text sub = 'rato roeu a roupa' off = strlen( lv_text ) occ = -1 ).
WRITE:/ 'FIND_ANY_NOT_OF:', lv_find.
