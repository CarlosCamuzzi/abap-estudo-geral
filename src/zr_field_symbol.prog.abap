*&---------------------------------------------------------------------*
*& Report zr_field_symbol
*&---------------------------------------------------------------------*
*
*  FIELD SYMBOL
*   - É uma referência a uma variável.
*   - Pode ser um texto simples, uma estrutra, uma tabela
*   - Uma variável armazena valor, porém o field symbol não armazena
*     valor.
*   - Ao referenciar uma variável com field symbol, ele aponta
*     para a variável, sendo assim, quando modificamos algo no field symbol,
*     na verdade estamos modificando a variável para a qual ele aponta.
*   - O tipo deve ser compatível.
*
*  Funcionamento:
*   - Alterar o valor de uma variável referenciada por um Field Symbol,
*     também altera o FS e vice-e-versa.
*   - Para verificar se o FS tem alguma referência, usar um IF com IS ASSIGNED
*   - Para limpar a referência usar UNASSIGN

*&---------------------------------------------------------------------*
REPORT zr_field_symbol.

* Variável
DATA: ld_text TYPE char100 VALUE 'Teste'.

* Criando Field Symbol
FIELD-SYMBOLS <ld_text> TYPE char100.

* Verificando referência
IF <ld_text> IS ASSIGNED.
  WRITE:/ |Tem referência|.
ELSE.
  WRITE:/ |Não tem referência|.   " X
ENDIF.

* Apontado FS para a varíavel
ASSIGN ld_text TO <ld_text>.

* Verificando referência
IF <ld_text> IS ASSIGNED.
  WRITE:/ |Tem referência|.     " X
ELSE.
  WRITE:/ |Não tem referência|.
ENDIF.

* Limpando uma referência
UNASSIGN <ld_text>.

**********************************************************************
* Field Symbol com estruturas

* scarr é uma estrutura
DATA: ls_scarr TYPE scarr.

FIELD-SYMBOLS: <ls_scarr> TYPE scarr.

ls_scarr-carrid = 1.
ls_scarr-carrname = 'Teste_FS'.

ASSIGN ls_scarr TO <ls_scarr>.
UNASSIGN <ls_scarr>.

**********************************************************************
* Field Symbol para Linha da Tabela

DATA: lt_scarr TYPE TABLE OF scarr.

SELECT * FROM scarr
    INTO TABLE lt_scarr.

* Aqui ele vai funcionar como uma work area
* Atribuindo Field Symbol com LOOP
* Ao invés de usar uma estrutura para a tabela, vamos usar o FS
* o FS foi criado acima. Veja que podemos reutilizar, desde que seja do mesmo tipo
LOOP AT lt_scarr ASSIGNING <ls_scarr>.
  WRITE:/ <ls_scarr>-carrid, <ls_scarr>-carrname.
ENDLOOP.

UNASSIGN <ls_scarr>.

**********************************************************************
* Field Symbol para a Tabela

DATA: lt_scarr2 TYPE STANDARD TABLE OF scarr.

* Vai copiar o tipo da variável (tabela) para o FS
* Isso ocorre devido ao uso do like.
FIELD-SYMBOLS: <lt_scarr2> like lt_scarr2.

* Após o select, a tabela também será referenciada
ASSIGN lt_scarr2 to <lt_scarr2>.

SELECT * FROM scarr
    INTO TABLE lt_scarr2.

BREAK-POINT.

**********************************************************************
* Field Symbol com variáveis dinâmicas

DATA: ld_varname type char100.
DATA: ld_text2 type char100 value 'Teste variáveis dinâmicas'.

FIELD-SYMBOLS <ld_text2> type char100.

* Atribuindo o nome da variável que queremos apontar
ld_varname = 'ld_text2'.

* Ao invés de atribuir a ld_text2, usa a ld_varname
* Dessa forma, ao invés de pegar a referência de varname, pega de ld_text2
ASSIGN (ld_varname) to <ld_text2>.

* Equivalentes:
"ASSIGN ld_text2 to <ld_text2>.
"ASSIGN ('ld_text2') to <ld_text2>.

" Observação:
"ASSIGN ('Variavel nao existe') to <ld_text2>.
" Uma outra forma de verificar é o sy-subrc, pois uma variável não existente
" vai retornar uma valor maior que zero

**********************************************************************
* Field Symbol com variáveis dinâmicas em outros programas
" Ocorre muito em programas standard que são mais complexos

* Para isso, precisamos pegar o nome do programa
DATA: ld_varnam2 type char100.
DATA: ld_txt type char100 value 'Testes'.

FIELD-SYMBOLS <ld_txt> type char100.

ld_varnam2 = '(ZR_FIELD_SYMBOL)ld_txt'. " Nome do programa (outro programa) + variável

ASSIGN (ld_varnam2) to <ld_txt>.

**********************************************************************
* INSERT INITIAL LINE INTO LT_SCARR3 ASSIGNING <LS_SCARR3>

data: lt_scarr3 type STANDARD TABLE OF scarr.

FIELD-SYMBOLS <ls_scarr3> type scarr.

" Linha Vazia
INSERT INITIAL LINE INTO LT_SCARR3 ASSIGNING <LS_SCARR3>.  " FS aponta para a linha

**********************************************************************
* Field Symbol com Type Genérico
* Pode ocorrer de usar o mesmo fs para vários tipos, então usa o tipo genérico
data: ld_text3 type char100.

FIELD-SYMBOLS <ld_text3> type any.  " Tipo Genérico

ASSIGN ld_text to <ld_text>.
