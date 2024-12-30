*&---------------------------------------------------------------------*
*& Report ZR_ESTUDO_LOOPS
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

REPORT zr_estudo_loops.

TYPES: BEGIN OF ty_veiculo,
         marca  TYPE char20,
         modelo TYPE char20,
         ano    TYPE i,
       END OF ty_veiculo.

DATA: lt_veiculos TYPE TABLE OF ty_veiculo,
      wa_veiculo  TYPE  ty_veiculo,
      lt_modify   TYPE TABLE OF ty_veiculo,
      wa_modify   TYPE  ty_veiculo.

**********************************************************************

lt_veiculos = VALUE #(
  ( marca = 'FIAT' modelo = 'UNO' ano = 1996 )
  ( marca = 'FORD' modelo = 'KA' ano = 2005 )
  ( marca = 'TOYOTA' modelo = 'COROLLA' ano = 2010 )
  ( marca = 'HONDA' modelo = 'CIVIC' ano = 2012 )
  ( marca = 'RENAULT' modelo = 'CLIO' ano = 2008 )
  ( marca = 'NISSAN' modelo = 'VERSA' ano = 2015 )
  ( marca = 'HYUNDAI' modelo = 'HB20' ano = 2019 )
  ( marca = 'KIA' modelo = 'CERATO' ano = 2013 )
  ( marca = 'PEUGEOT' modelo = '208' ano = 2018 )
  ( marca = 'CITROËN' modelo = 'C3' ano = 2017 )
  ( marca = 'FIAT' modelo = 'PALIO' ano = 2004 )
  ( marca = 'CHEVROLET' modelo = 'PRISMA' ano = 2009 )
  ( marca = 'VW' modelo = 'PASSAT' ano = 1995 )
  ( marca = 'MITSUBISHI' modelo = 'LANCER' ano = 2014 )
  ( marca = 'FIAT' modelo = 'STRADA' ano = 2012 )
  ( marca = 'FORD' modelo = 'FIESTA' ano = 2006 )
  ( marca = 'VW' modelo = 'SAVEIRO' ano = 2010 )
  ( marca = 'CHEVROLET' modelo = 'ONIX' ano = 2020 )
  ( marca = 'RENAULT' modelo = 'DUSTER' ano = 2018 )
  ( marca = 'TOYOTA' modelo = 'YARIS' ano = 2021 )
  ( marca = 'HYUNDAI' modelo = 'TUCSON' ano = 2015 )
  ( marca = 'HONDA' modelo = 'FIT' ano = 2009 )
  ( marca = 'NISSAN' modelo = 'KICKS' ano = 2016 )
  ( marca = 'KIA' modelo = 'SPORTAGE' ano = 2022 )
  ( marca = 'PEUGEOT' modelo = '307' ano = 2007 )
  ( marca = 'CHEVROLET' modelo = 'SPIN' ano = 2013 )
  ( marca = 'FIAT' modelo = 'TORO' ano = 2019 )
  ( marca = 'VW' modelo = 'JETTA' ano = 2020 )
  ( marca = 'FORD' modelo = 'ECOSPORT' ano = 2017 )
  ( marca = 'TOYOTA' modelo = 'HILUX' ano = 2021 )
  ( marca = 'RENAULT' modelo = 'KWID' ano = 2022 )
).

**********************************************************************

START-OF-SELECTION.
  "PERFORM f_loop_at.
  "PERFORM f_write_loop_at.
  "PERFORM f_loop_for.
  PERFORM f_loop_do.

  PERFORM f_print_data.

**********************************************************************

*&---------------------------------------------------------------------*
*& Form F_WRITE_LOOP_AT - Write com Loop tradicional
*&---------------------------------------------------------------------*
FORM f_write .
  LOOP AT lt_modify INTO wa_modify.
    WRITE:/ wa_modify-marca,
            wa_modify-modelo,
            wa_modify-ano.
  ENDLOOP.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form F_PRINT_DATA - Display por método estático
*&---------------------------------------------------------------------*
FORM f_print_data .
  cl_demo_output=>write_data( lt_modify ).
  cl_demo_output=>display(  ).
ENDFORM.

*&---------------------------------------------------------------------*
*& Form F_LOOP_AT - Loop Tradicional
*&---------------------------------------------------------------------*
FORM f_loop_at .
  LOOP AT lt_veiculos INTO wa_veiculo WHERE ano > 2010.
    wa_modify-marca = wa_veiculo-marca.
    wa_modify-modelo = wa_veiculo-modelo.
    wa_modify-ano = wa_veiculo-ano.
    APPEND wa_modify TO lt_modify.
  ENDLOOP.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form f_loop_for
*&---------------------------------------------------------------------*
* Detalhes do VALUE #
*   - O símbolo # (chamado de placeholder) é um recurso introdutório em ABAP que significa "inferir o tipo automaticamente".
*     Ele assume o tipo da variável ou contexto no qual está sendo usado.
*     Portanto, você não precisa especificar explicitamente o tipo do dado sendo criado.
*   - No exemplo, o VALUE #( está criando uma tabela interna com base no tipo de dados da variável lt_modify.
*   -  O tipo dessa tabela é inferido automaticamente.
*&---------------------------------------------------------------------*
FORM f_loop_for .
  lt_modify = VALUE #(
    FOR ls_veiculo IN lt_veiculos WHERE ( ano <= 2010 )
      LET lv_marca = ls_veiculo-marca && ', a melhor'
       IN marca = lv_marca
        ( modelo = ls_veiculo-modelo
         	ano = ls_veiculo-ano )
  ).
ENDFORM.

*&---------------------------------------------------------------------*
*& Form F_LOOP_DO
*&---------------------------------------------------------------------*
FORM f_loop_do .
  " Teste simples
*  DATA: lv_count TYPE i VALUE 1.
*  DATA: lv_loop TYPE i VALUE 10.
*
*  DO lv_loop TIMES.
*    WRITE:/ lv_count.
*    lv_count = lv_count + 1.
*  ENDDO.

  DATA: lv_index TYPE sy-tabix.

  DO.
    " Index maior que a quantidade de linhas (registros) da tabela
    IF lv_index > lines( lt_veiculos ).
      EXIT.
    ENDIF.

    READ TABLE lt_veiculos INTO wa_veiculo INDEX lv_index.
    IF sy-subrc IS INITIAL.
      IF wa_veiculo-marca = 'CHEVROLET' .
        wa_modify-ano = wa_veiculo-ano.
        wa_modify-modelo = wa_veiculo-modelo.
        wa_modify-marca = wa_veiculo-marca.
        APPEND wa_modify TO lt_modify.
      ENDIF.
    ENDIF.

    lv_index = lv_index + 1.

  ENDDO.

ENDFORM.
