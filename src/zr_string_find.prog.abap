*&---------------------------------------------------------------------*
*& Report ZR_STRING_FIND
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
*   FIND
*   A função find busca pela substring exata especificada em substring ou por uma correspondência com
*      a expressão regular regex e retorna o deslocamento da ocorrência em relação ao comprimento total do texto.
*   A busca é sensível a maiúsculas e minúsculas por padrão, mas isso pode ser alterado usando o parâmetro case.
*      Se substring estiver vazia, uma exceção da classe CX_SY_STRG_PAR_VAL será lançada.
*
**********************************************************************
*
* Obs.: Regex, PCRE E POSIX abordados em outro arquivo
*
**********************************************************************

* Dicas:
*   ◾ Utilizando as funções de busca relacionadas count e count_...,
*      é possível determinar o número total de ocorrências em vez de um deslocamento.
*   ◾ Assim como a instrução FIND, as funções de busca podem ser significativamente mais
*      rápidas do que o operador de comparação CS.

*&---------------------------------------------------------------------*

REPORT zr_string_find NO STANDARD PAGE HEADING  .

DATA(lv_text) = 'O rato roeu a roupa do rei de Roma e ainda ficou com fome'.
DATA: lv_find TYPE i.

**********************************************************************
WRITE:/ lv_text. ULINE. SKIP.
**********************************************************************

" Find --------------------------
" 1. ... find( val = text {sub = substring}|{pcre|regex = regex} [case = case]
"           [off = off] [len = len] [occ = occ] ) ...

" Nota: FIND vai retornar o index do match, ou seja:
" 'rato' retorna 2 e 'r' também retornará 2

lv_find = find( val = lv_text sub = 'r'  ).       " 2: 'r' da palavra 'r'ato
WRITE:/ 'FIND:', lv_find.

lv_find = find( val = lv_text sub = 'rato'  ).    " 2: 'r' da palavra 'r'ato
WRITE:/ 'FIND:', lv_find.

lv_find = find( val = lv_text sub = 'a'  ).       " 3: 'a' da palavra r'a'to
WRITE:/ 'FIND:', lv_find.

lv_find = find( val = lv_text sub = 'roupa'  ).   " 14: 'r' a palavra 'r'oupa
WRITE:/ 'FIND:', lv_find.

lv_find = find( val = lv_text sub = 'Roma'  ).    " 30: 'R' da palavra 'R'oma
WRITE:/ 'FIND:', lv_find.

" OCC POSITIVO (search left -> right) E LEN
" off = começa do index x / len = termina no index y / occ = primeira ocorrência
" Qualquer busca fora dessa subarea retornará -1 (não encontrado)

lv_find = find( val = lv_text sub = 'a' off = 1 len = 3 occ = 1  ).   " 3: 'a' da palavra r'a'to
WRITE:/ 'FIND:', lv_find.

" Return -1, pois dentro da subárea 1 a 3 não tem uma segunda ocorrência de 'a'
lv_find = find( val = lv_text sub = 'a' off = 1 len = 3 occ = 2  ).   " -1
WRITE:/ 'FIND:', lv_find.

" Correspondência encontrada, segunda ocorrência de 'a'
lv_find = find( val = lv_text sub = 'a' off = 1 len = 14 occ = 2  ).   " 12: 'a' de ... 'a' roupa ...
WRITE:/ 'FIND:', lv_find.

" OCC NEGATIVO (search right -> left) E LEN
" off = index que começa a busca na string / len = 30 posições / occ -1: direita para esquerda
" Para busca reversa, off tem que ser maior ou igual a len
lv_find = find( val = lv_text sub = 'Roma' off = strlen( lv_text ) len = 30 occ = -1 ).   " 30: 'R' da palavra 'R'oma
WRITE:/ 'FIND:', lv_find.

lv_find = find( val = lv_text sub = 'a' off = strlen( lv_text ) len = 30 occ = -1 ).      " 41: último 'a' da palavra aind'a'
WRITE:/ 'FIND:', lv_find.


**********************************************************************
" CASOS DE DUMP
**********************************************************************
" Dump: CX_SY_RANGE_OUT_OF_BOUNDS
" len ou off maior que o comprimento de val

" occ não pode ser negativo
*lv_find = find( val = lv_text sub = 'a' off = -1 len = 20 occ = 2  ).
*WRITE:/ 'FIND:', lv_find.

" len não pode ser negativo
*lv_find = find( val = lv_text sub = 'd' off = 1 len = -20 occ = 1  ).
*WRITE:/ 'FIND:', lv_find.

" para busca reversa, off tem que ser maior ou igual que len
"lv_find = find( val = lv_text sub = 'a' off = 1 len = 10 occ = -1 ).

*Catchable Exceptions
*
*CX_SY_RANGE_OUT_OF_BOUNDS
*◾Cause: Illegal offset or length specified in off and len.
*Runtime error: STRING_OFFSET_TOO_LARGE
*
*CX_SY_REGEX_TOO_COMPLEX
*◾Cause: More information: Exceptions in Regular Expressions.
*Runtime error: REGEX_TOO_COMPLEX
*
*CX_SY_STRG_PAR_VAL
*◾Cause: Substring in sub or regular expression in regex is empty or occurrence in occ is 0.
*Runtime error: STRG_ILLEGAL_PAR
