*&---------------------------------------------------------------------*
*& Report ZR_STRING_CHARLEN_STRLEN
*&---------------------------------------------------------------------*
*
*   ... func( arg ) ...
*
*   CHARLEN E STRLEN
* Os argumentos arg de todas as funções de comprimento, exceto dbmaxlen, são posições de expressão
*  com características de caracteres (character-like expression positions).
*  O argumento de dbmaxlen é uma posição funcional de operandos com características de caracteres
*  (character-like functional operand position).
*  O valor de retorno de todas as funções de comprimento tem o tipo i.

**********************************************************************

*   CHARLEN
*  Comprimento do primeiro caractere de arg na página de código utilizada:
*    1 para um caractere Unicode único; 2 para pares substitutos (surrogate pairs).

" Nota: O CHARLEN() é mais útil quando você precisa verificar se um caractere específico é
"       um caractere Unicode único (retorna 1) ou um par substituto (retorna 2).

**********************************************************************

*   STRLEN
*  Número de caracteres em arg, onde espaços em branco no final não são considerados em objetos
*   de dados com comprimentos fixos, mas são considerados em objetos de dados do tipo string.

* Apesar de na documentação relatar que os espaços em branco são considerandos pra tipo string,
*   no exemplo em questão todos os valores retornram iguais para text2, text3, text4, text5

*&---------------------------------------------------------------------*

REPORT zr_string_charlen_strlen NO STANDARD PAGE HEADING.

DATA: lv_len TYPE i.

DATA(lv_text) = 'Às vezes parecia que de tanto acreditar'           && '\n'
                  && 'Em tudo que achávamos tão certo'              && '\n'
                  && 'Teríamos o mundo inteiro e até um pouco mais' && '\n'
                  && 'Faríamos floresta do deserto'                 && '\n'.

" Para testar strlen: string/char com e sem espaços no final -----------------------------------
DATA: lv_text2     TYPE string,
      lv_text3     TYPE string,
      lv_text4(80) TYPE c,
      lv_text5(76) type c.

lv_text2 = 'Às vezes parecia que era só improvisar e o mundo então seria um livro aberto    '.  " string 80
lv_text3 = 'Às vezes parecia que era só improvisar e o mundo então seria um livro aberto'.      " string 76

lv_text4 = 'Às vezes parecia que era só improvisar e o mundo então seria um livro aberto    '.  " char 80
lv_text5 = 'Às vezes parecia que era só improvisar e o mundo então seria um livro aberto'.      " char 76

**********************************************************************

SPLIT lv_text AT '\n' INTO TABLE DATA(lt_lines).

LOOP AT lt_lines INTO DATA(wa_lines).
  WRITE:/ wa_lines.
ENDLOOP.

ULINE. SKIP.

**********************************************************************

" CHALEN
*  Comprimento do primeiro caractere de arg na página de código utilizada:
*    1 para um caractere Unicode único; 2 para pares substitutos (surrogate pairs).

" Charlen retorna 1, pois é o comprimento do primeiro caracatere 'À'
lv_len = charlen( lv_text ).
WRITE:/ 'CHARLEN:', lv_len.
SKIP.

**********************************************************************

" STRLEN

*  Número de caracteres em arg, onde espaços em branco no final não são considerados em objetos
*   de dados com comprimentos fixos, mas são considerados em objetos de dados do tipo string.

lv_len = strlen( lv_text ).   " 150 caracteres
WRITE:/ 'STRLEN text 1:', lv_len.

* Todos retornam 76 -------------------------------
* String com espaços:
lv_len = strlen( lv_text2 ).
WRITE:/ 'STRLEN text 2:', lv_len.

* String sem espaços:
lv_len = strlen( lv_text3 ).
WRITE:/ 'STRLEN text 3:', lv_len.

* Char com espaços:
lv_len = strlen( lv_text4 ).
WRITE:/ 'STRLEN text 4:', lv_len.

* Char sem espaços:
lv_len = strlen( lv_text5 ).
WRITE:/ 'STRLEN text 5:', lv_len.
