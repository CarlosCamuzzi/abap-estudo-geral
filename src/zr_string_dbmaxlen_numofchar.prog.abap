*&---------------------------------------------------------------------*
*& Report ZR_STRING_DBMAXLEN_NUMOFCHAR
*&---------------------------------------------------------------------*
* ... func( arg ) ...
*
*   DBMAXLENe NUMOFCHAR
*   Os argumentos arg de todas as funções de comprimento, exceto dbmaxlen, são posições de expressão
*    com características de caracteres (character-like expression positions).
*   O argumento de dbmaxlen é uma posição funcional de operandos com características de caracteres
*    (character-like functional operand position).
*   O valor de retorno de todas as funções de comprimento tem o tipo i.

**********************************************************************

*   DBMAXLEN
* Comprimento máximo de uma string definida no Dicionário ABAP (RAWSTRING, SSTRING, STRING ou GEOM_EWKB).
*  Se a string for irrestrita, é retornada a constante abap_max_db_string_ln ou abap_max_db_rawstring_ln do pool de tipos ABAP.
*  Para os tipos internos do ABAP string e xstring, o mesmo valor é retornado.

**********************************************************************
*   NUMOFCHAR
* Número de caracteres em arg, onde espaços em branco no final não são considerados
* em objetos de dados com comprimentos fixos ou no tipo string.

*&---------------------------------------------------------------------*

REPORT ZR_STRING_DBMAXLEN_NUMOFCHAR NO STANDARD PAGE HEADING.

DATA: lv_len TYPE i.

DATA(lv_text) = 'Às vezes parecia que de tanto acreditar'           && '\n'
                  && 'Em tudo que achávamos tão certo'              && '\n'
                  && 'Teríamos o mundo inteiro e até um pouco mais' && '\n'
                  && 'Faríamos floresta do deserto'                 && '\n'.

* ----------------------------------------------------------------------------------------

* Testando com numofchar
DATA: lv_text2     TYPE string,
      lv_text3     TYPE string,
      lv_text4(80) TYPE c,
      lv_text5(76) type c.

lv_text2 = 'Às vezes parecia que era só improvisar e o mundo então seria um livro aberto    '.  " string 80
lv_text3 = 'Às vezes parecia que era só improvisar e o mundo então seria um livro aberto'.      " string 76
lv_text4 = 'Às vezes parecia que era só improvisar e o mundo então seria um livro aberto    '.  " char 80
lv_text5 = 'Às vezes parecia que era só improvisar e o mundo então seria um livro aberto'.      " char 76

* ----------------------------------------------------------------------------------------

**********************************************************************

SPLIT lv_text AT '\n' INTO TABLE DATA(lt_lines).

LOOP AT lt_lines INTO DATA(wa_lines).
  WRITE:/ wa_lines.
ENDLOOP.

ULINE. SKIP.

**********************************************************************

* NUM OF CHAR
lv_len = numofchar( lv_text ).
WRITE:/ 'NUM OF CHAR:', lv_len.

ULINE. SKIP.

**********************************************************************

* NUM OF CHAR
* Todos retornam 76,pois numofchar não considera espaços em branco em string ou char fixo

lv_len = numofchar( lv_text2 ).
WRITE:/ 'NUM OF CHAR text2:', lv_len.

lv_len = numofchar( lv_text3 ).
WRITE:/ 'NUM OF CHAR text3:', lv_len.

lv_len = numofchar( lv_text4 ).
WRITE:/ 'NUM OF CHAR text4:', lv_len.

lv_len = numofchar( lv_text5 ).
WRITE:/ 'NUM OF CHAR text5:', lv_len.

ULINE. SKIP.

**********************************************************************
**********************************************************************

* DBMAXLEN
*  Comprimento máximo de uma string definida no Dicionário ABAP,
*   independente do conteúdo da string
* Ambos vão retornar o mesmo valor
lv_len = dbmaxlen( lv_text ).
WRITE:/ 'DBMAXLEN:', lv_len.

lv_len = dbmaxlen( lv_text2 ).
WRITE:/ 'DBMAXLEN:', lv_len.
