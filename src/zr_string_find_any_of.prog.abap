*&---------------------------------------------------------------------*
*& Report ZR_STRING_FIND_ANY_OF
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
*   FIND_END_ANY_OF
*   A função find_any_of retorna o deslocamento da ocorrência de qualquer caractere contido em substring e sempre
*    é sensível a maiúsculas e minúsculas. Se substring estiver vazia, o valor -1 será retornado.
*
**********************************************************************
*&---------------------------------------------------------------------*

REPORT zr_string_find_any_of NO STANDARD PAGE HEADING  .

DATA(lv_text) = 'O rato roeu a roupa do rei de Roma e ainda ficou com fome'.
DATA: lv_find TYPE i.

**********************************************************************
WRITE:/ lv_text. ULINE. SKIP.
**********************************************************************

" Find any of --------------------------
* 3. ... find_any_of( val = text sub = substring
*                  [off = off] [len = len] [occ = occ] ) ...

" Obs.: any of e any not of trabalham no caractere e são case sensitive, sem possibilidade de mudança

" Diferença de find para find_any_of:
"   find busca pela substring exata e retorna o deslocamento
"   find_any_of retorna o deslocamento da ocorrência de qualquer caractere contido na substring

" Find
lv_find = find( val = lv_text sub = 'r' ).     " 2: 'r' da palavra 'rato'
WRITE:/ 'FIND:', lv_find.

" Find any of ------------------------------------------------------
" Retorna o deslocamento da ocorrência qualquer caractere contida na substring

" Nota: Mesmo tendo caracteres que não estão na string, vai achar, pois busca a ocorrência dentro da substring
"       Isso não ocorre com FIND, como demonstrado abaixo
lv_find = find_any_of( val = lv_text sub = '123456R78910' ).  " 30 - R de 'R'oma
WRITE:/ 'FIND_ANY_OF:', lv_find.

lv_find = find( val = lv_text sub = '123456R78910' ).  " Não encontra, retorna -1
WRITE:/ 'FIND:', lv_find.

"---------------------------------------------------------------------------------------------------

" O rato roeu a roupa do rei de Roma e ainda ficou com fome

" Resultados iguais: -------------------------------------------------------------------------------
" 2: 'r' da palavra rato
" Obs.: Todos irão retornar 2, porque, como o find_any_of busca a ocorrência dentro da substring,
"       ele vai encontrar o primeiro 'r' de 'rato', que é o index 2.
"  A palavra 'roeu' não irá fazer diferença nesse caso, pois o primeiro 'r' vai prevalecer
lv_find = find_any_of( val = lv_text sub = 'r' ).  "
WRITE:/ 'FIND_ANY_OF:', lv_find.

lv_find = find_any_of( val = lv_text sub = 'rato' ).  "
WRITE:/ 'FIND_ANY_OF:', lv_find.

lv_find = find_any_of( val = lv_text sub = 'roeu' ).  "
WRITE:/ 'FIND_ANY_OF:', lv_find.
"---------------------------------------------------------------------------------------------------
"---------------------------------------------------------------------------------------------------

" Obs.: Note que encontra o 'o' do index 5, da palavra rat'o'
lv_find = find_any_of( val = lv_text sub = 'ficou' ).  " 5: encontra o 'o' da substring 'ficou' em 'rat'o', index 5
WRITE:/ 'FIND_ANY_OF:', lv_find.

" OCC, LEN, OFF------------------------------------------------------
" O rato roeu a roupa do rei de Roma e ainda ficou com fome
lv_find = find_any_of( val = lv_text sub = 'ficou' occ = -1 ).  " 54: 'o' da substring 'ficou' em f'o'me, index 54
WRITE:/ 'FIND_ANY_OF:', lv_find.

lv_find = find_any_of( val = lv_text sub = 'ainda' occ = -1 ).  " 44: 'i' da substring 'ainda' em f'i'cou, index 44
WRITE:/ 'FIND_ANY_OF:', lv_find.

"---------------------------------------------------------------------------------------------------
" Resultados iguais: -------------------------------------------------------------------------------
" Usando OFF e LEN podemos controlar a área de busca
lv_find = find_any_of( val = lv_text sub = 'ainda' occ = -2 ).  " 41: Segunda ocorrência: 'a' da substring 'ainda' em aind'a', index 41
WRITE:/ 'FIND_ANY_OF:', lv_find.

" Delimitando intervalo e buscando a primeira ocorrência
lv_find = find_any_of( val = lv_text sub = 'ainda' off = 42 len = 30 occ = -1 ).  " 41: 'a' da substring aind'a'
WRITE:/ 'FIND_ANY_OF:', lv_find.
"---------------------------------------------------------------------------------------------------
"---------------------------------------------------------------------------------------------------
