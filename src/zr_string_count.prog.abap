*&---------------------------------------------------------------------*
*& Report ZR_STRING_COUNT
*&---------------------------------------------------------------------*
*  COUNT
*
*  As funções de busca count e count_... realizam a busca no texto da mesma forma
*  que as funções correspondentes find e find_..., procurando no texto completo ou em uma
*  subárea definida pelos parâmetros off e len, pelos caracteres especificados em substring
*  ou por uma correspondência com uma expressão regular especificada em regex.
*  Em vez de retornar um deslocamento, elas retornam o número total de ocorrências encontradas.
*
* ◾ Se o argumento pcre for usado, regex deve conter uma expressão regular PCRE.
* ◾ Se o argumento regex for usado, regex deve conter uma expressão regular POSIX.
*
*   O valor de retorno tem o tipo i.
*   Case sensitive por padrão
*
**********************************************************************

* Exceptions
*
* CX_SY_RANGE_OUT_OF_BOUNDS
* ◾Cause: Illegal offset or length specified in off and len.
* Runtime error: STRING_OFFSET_TOO_LARGE
*
* CX_SY_REGEX_TOO_COMPLEX
* ◾Cause: More information: Exceptions in Regular Expressions.
* Runtime error: REGEX_TOO_COMPLEX
*
* CX_SY_STRG_PAR_VAL
* ◾Cause: Substring in sub or regular expression in regex is empty or occurrence in occ is 0.
* Runtime error: STRG_ILLEGAL_PAR

*&---------------------------------------------------------------------*

REPORT zr_string_count NO STANDARD PAGE HEADING.

DATA: lv_count TYPE i.

DATA(lv_text) = 'Sou inquieto, áspero'                   && '\n'
                 && 'E desesperançado'                   && '\n'
                 && 'Embora amor dentro de mim eu tenha' && '\n'
                 && 'Só que eu não sei usar amor'        && '\n'
                 && 'Às vezes arranha'                   && '\n'
                 && 'Feito farpa'.

**********************************************************************

* COUNT
*1. ... count( val = text {sub = substring}|{pcre|regex = regex} [case = case]
*             [off = off] [len = len] ) ...

" Nota: Count retorna o número total de ocorrências encontradas.

**********************************************************************

SPLIT lv_text AT '\n' INTO TABLE DATA(lt_lines).

LOOP AT lt_lines INTO DATA(lv_line).
  WRITE: / lv_line.
ENDLOOP.

ULINE. SKIP.

**********************************************************************

lv_count = count( val = lv_text sub = 'a' ).  " 12 'a', sem acentos e case sensitive
WRITE:/ 'COUNT', lv_count.

lv_count = count( val = lv_text sub = 'E' ).  " 2 'E', sem acentos e case sensitive
WRITE:/ 'COUNT', lv_count.

lv_count = count( val = lv_text sub = 'à' case = abap_false ).  " 1 'À/à' crase, sem case sensitive
WRITE:/ 'COUNT', lv_count.

**********************************************************************
" OFF / LEN

" Embora amor dentro de mim eu tenha
lv_count = count( val = lv_text sub = 'e' off = 39 len = 33 case = abap_true ).  " 4 'e', sem acento e case sensitive
WRITE:/ 'COUNT', lv_count.

lv_count = count( val = lv_text sub = 'e' off = 39 len = 33 case = abap_false ).  " 5 'E/e', sem acento e sem case sensitive
WRITE:/ 'COUNT', lv_count.

SKIP.

**********************************************************************

* COUNT ANY OF
* 2. ... count_any_of( val = text  sub = substring
*                     [off = off] [len = len] ) ...

* Nota: count_any_of não possui o parâmetro 'case'
*       Faz basicamente a mesma coisa que o count, entretanto é case sensitive

*  COUNT_ANYT_OF conta todos os caracteres na string base (val)
*    que estão presentes na string de comparação (sub).
*    Ele analisa caractere por caractere de val e verifica se existe na sequência fornecida por sub.

**********************************************************************

" Embora amor dentro de mim eu tenha
lv_count = count_any_of( val = lv_text sub = 'e' off = 39 len = 33 ).  " 4 'e', sem acento e case sensitive
WRITE:/ 'COUNT_ANY_OF:', lv_count.

" ver
lv_count = count_any_of( val = lv_text sub = 'amor'  ).  " 4 'e', sem acento e case sensitive
WRITE:/ 'COUNT_ANY_OF', lv_count.

lv_count = count_any_of( val = lv_text sub = 'Só que eu não' ).  " 68 ocorrências de caracteres não presentes no lv_text
WRITE:/ 'COUNT_ANY_OF', lv_count.

SKIP.

**********************************************************************

" COUNT ANY NOT OF
* 3. ... count_any_not_of( val = text  sub = substring
*                         [off = off] [len = len] ) ...

* Nota: Assim como o count_any_of, o count_any_not_of não possui o parâmetros 'case'
*       Ao contrário do count_any_of, ele retorno a quantidade de ocorrências que não
*         estão na substring

* COUNT_ANY_NOT_OF conta todos os caracteres na string base (val)
*    que não estão presentes na string de comparação (sub).
*   Ele analisa caractere por caractere de val e verifica se não existe na sequência fornecida por sub.

**********************************************************************

" Embora amor dentro de mim eu tenha
lv_count = count_any_not_of( val = lv_text sub = 'e' off = 39 len = 33 ).  " 29 ocorrência que não são 'e'
WRITE:/ 'COUNT_ANY_NOT_OF', lv_count.

" Só que eu não
lv_count = count_any_not_of( val = lv_text sub = 'Só que eu não' ).  " 68 ocorrências de caracteres não presentes no lv_text
WRITE:/ 'COUNT_ANY_NOT_OF', lv_count.

SKIP.

**********************************************************************
