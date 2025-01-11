*&---------------------------------------------------------------------*
*& Report ZR_STRING_FIND_END
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
*   É case sensitive por padrão, pode ser mudado no booleano 'case'.
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
*   FIND_END
*     A função find_end realiza a mesma busca que find, mas retorna a soma do deslocamento
*       da ocorrência com o comprimento da correspondência encontrada pela expressão regular.
*
**********************************************************************
*&---------------------------------------------------------------------*

REPORT zr_string_find_end NO STANDARD PAGE HEADING  .

DATA(lv_text) = 'O rato roeu a roupa do rei de Roma e ainda ficou com fome'.
DATA: lv_find TYPE i.

**********************************************************************
WRITE:/ lv_text. ULINE. SKIP.
**********************************************************************

" Find End --------------------------
" 2. ... find_end( val = text {sub = substring}|{pcre|regex = regex} [case = case]
"           [off = off] [len = len] [occ = occ] ) ...

" Nota: A diferença de find para find_end é que o find retorna apenas o deslocamento,
"         enquanto o find_end vai retornar o deslocamento (igual find) + o tamanho da substring encontrada

" Find
lv_find = find( val = lv_text sub = 'r' ).     " 2: 'r' da palavra 'rato'
WRITE:/ 'FIND:', lv_find.

" Find end ------------------------------------------------------
" Soma: deslocamento + comprimento da correspondência
lv_find = find_end( val = lv_text sub = 'r' ).     " 3 = 2 ('r' de 'r'ato) + 1 (comprimento da substring 'r')
WRITE:/ 'FIND_END:', lv_find.

lv_find = find_end( val = lv_text sub = 'rato' ).  " 6 = 2 ('r' de 'r'ato) + 4 (comprimento da substring 'rato')
WRITE:/ 'FIND_END:', lv_find.

lv_find = find_end( val = lv_text sub = 'o' ).     " 6 = 5 ('o' de rat'o') + 1 (comprimento da substring 'rato')
WRITE:/ 'FIND_END:', lv_find.

lv_find = find_end( val = lv_text sub = 'roupa' ). " 19 = 14 ('r' de 'r'oupa) + 5 (comprimento da substring 'roupa')
WRITE:/ 'FIND_END:', lv_find.


" OCC E LEN ------------------------------------------------------
" O rato roeu a roupa do rei de Roma e ainda ficou com fome

" OCC NEGATIVO (search right -> left) E LEN
" off = começo da string / len = 30 posições / occ -1: direita para esquerda
" Para busca reversa, off tem que ser maior ou igual a len
TRY .
    lv_find = find( val = lv_text sub = 'f' occ = -1 ).     " 53: f de 'f'ome
    WRITE:/ 'FIND:', lv_find.

    "---------------------------------------------------------------------------------------------------
    " Resultados iguais: -------------------------------------------------------------------------------
    " 54 = 53 (f de 'f'ome) + 1 (comprimento sub 'f')
    lv_find = find_end( val = lv_text sub = 'f' off = strlen( lv_text ) len = 30 occ = -1 ).
    WRITE:/ 'FIND_END:', lv_find.

    lv_find = find_end( val = lv_text sub = 'f'  occ = -1 ).
    WRITE:/ 'FIND_END:', lv_find.
    "---------------------------------------------------------------------------------------------------
    "---------------------------------------------------------------------------------------------------

    "---------------------------------------------------------------------------------------------------
    " Resultados iguais: -------------------------------------------------------------------------------
    " 48 = 43 (f de 'f'icou) + 5 (comprimento de 'ficou')
    lv_find = find_end( val = lv_text sub = 'ficou' off = strlen( lv_text ) len = strlen( lv_text ) occ = -1 ).
    WRITE:/ 'FIND_END:', lv_find.

    lv_find = find_end( val = lv_text sub = 'ficou' occ = -1 ).
    WRITE:/ 'FIND_END:', lv_find.
    "---------------------------------------------------------------------------------------------------
    "---------------------------------------------------------------------------------------------------

    " 57 = 53 (f de 'f'ome) + 4 (comprimento sub 'fome')
    lv_find = find_end( val = lv_text sub = 'fome' off = strlen( lv_text ) len = 10 occ = -1 ).
    WRITE:/ 'FIND_END:', lv_find.

    " 36 = 35 de ...roma 'e' ... + 1 (comprimento de 'e')
    lv_find = find_end( val = lv_text sub = 'e' occ = -2 ).
    WRITE:/ 'FIND_END:', lv_find.

  CATCH cx_root INTO DATA(lx_exception).
    WRITE: / 'Erro ocorrido:', lx_exception->get_text( ).

ENDTRY.
