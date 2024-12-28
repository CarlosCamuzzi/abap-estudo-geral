*&---------------------------------------------------------------------*
*& Report ZR_ESTUDO_REDUCE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZR_ESTUDO_REDUCE.

*  DATA: lv_where_clause TYPE string,
*        lv_count        TYPE i VALUE 0,
*        lv_len          TYPE i VALUE 0.
*
*  IF v_nome IS NOT INITIAL.
*    lv_where_clause = lv_where_clause && | nome LIKE '{ v_nome }%' AND |.
*    lv_count = lv_count + 1.
*  ENDIF.
*
*  IF v_cpf IS NOT INITIAL.
*    lv_where_clause = lv_where_clause && | cpf LIKE '{ v_cpf }%' AND |.
*    lv_count = lv_count + 1.
*  ENDIF.
*
*  IF v_cnh IS NOT INITIAL.
*    lv_where_clause = lv_where_clause && | cnh LIKE '{ v_cnh }%' AND |.
*    lv_count = lv_count + 1.
*  ENDIF.
*
*  IF v_stamot IS NOT INITIAL.
*    lv_where_clause = lv_where_clause && | status = '{ v_stamot }' AND |.
*    lv_count = lv_count + 1.
*  ENDIF.


CLASS demo DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS main.
ENDCLASS.

CLASS demo IMPLEMENTATION.
  METHOD main.


*    IF v_nome IS NOT INITIAL.
*    "  lv_where_clause = lv_where_clause && | nome LIKE '{ v_nome }%' AND |.
*     " lv_count = lv_count + 1.
*    ENDIF.
*
*    IF v_cpf IS NOT INITIAL.
*      "lv_where_clause = lv_where_clause && | cpf LIKE '{ v_cpf }%' AND |.
*      "lv_count = lv_count + 1.
*    ENDIF.

    " Cada registro é uma linha
*    lt_where_clause = VALUE #(
*      ( | status = ativo AND | )
*      ( | nome = Paulo AND | )
*    ).

    TYPES: BEGIN OF ty_where_clause,
             clause TYPE string,
             exist  TYPE abap_bool,
           END OF ty_where_clause.

    "DATA: lt_where_clause TYPE TABLE OF string.

    DATA: lt_where_clause TYPE TABLE OF ty_where_clause.

    DATA: lv_count TYPE i VALUE 0,
          lv_len   TYPE i VALUE 0,
          v_nome   TYPE string,
          v_cpf    TYPE string.


    v_nome = 'Carlos'.

    lt_where_clause = VALUE #(
      ( clause = | nome LIKE '{ v_nome }%' AND | exist = abap_true )
      ( clause = | nome LIKE '{ v_CPF }%' AND | exist = abap_false )
    ).

*    lt_where_clause = VALUE #(
*      "( | nome LIKE '{ v_nome }%' AND | )
*      "( | cpf LIKE '{ v_cpf }%' AND | )   " entra mesmo cpf estando vazio"
*      ( COND #(
*          WHEN v_nome IS NOT INITIAL
*            THEN | nome LIKE '{ v_nome }%' AND |
*          ELSE '' )
*          )
*       ( COND #(
*          WHEN v_cpf IS NOT INITIAL
*            THEN | cpf LIKE '{ v_cpf }%' AND |
*          ELSE '' )
*          )
*    ).
    " Talvez criar uma tabela com um bool pra marcar o campo que vem vazio ou não



    DATA(query) =
    REDUCE string(
      INIT text = `` sep = ``
      FOR where_clause IN lt_where_clause
      NEXT
        text = COND #(  " Passar a condição das variáveis
          WHEN where_clause IS NOT INITIAL
            THEN |{ text }{ sep }{ where_clause-clause }|
          ELSE text )
          sep = ` `
    ).

    lv_len = strlen( query ).

    IF lv_len > 0.
      TRY.
          query = substring_before( val = query sub = ` AND` occ = 1 ).

        CATCH cx_sy_range_out_of_bounds.
          MESSAGE: 'CX_SY_RANGE_OUT_OF_BOUNDS' TYPE 'E'.

        CATCH cx_sy_strg_par_val.
          MESSAGE: 'CX_SY_STRG_PAR_VAL' TYPE 'E'.

        CATCH cx_sy_regex_too_complex.
          MESSAGE: 'CX_SY_REGEX_TOO_COMPLEX' TYPE 'E'.
      ENDTRY.
    ENDIF.


*    DATA(query) =
*      REDUCE string(
*        INIT text = `` sep = ``
*        FOR where_clause IN lt_where_clause
*        NEXT text = |{ text }{ sep }{ where_clause }| sep = ` ` ).

    cl_demo_output=>write_data( query ).
    cl_demo_output=>display(  ).

  ENDMETHOD.
ENDCLASS.


START-OF-SELECTION.
  demo=>main( ).

**********************************************************************
  " ENTENDENDO O FUNCIONAMENTO
**********************************************************************
*CLASS demo IMPLEMENTATION.
*  METHOD main.
*
*    "DATA: lt_where_clause TYPE LINE OF strings.
*    DATA: lt_ztveiculos TYPE TABLE OF ztveiculos.
*          "wa_ztveiculos TYPE ztveiculos.
*
*    SELECT *
*      INTO TABLE @lt_ztveiculos
*      FROM ztveiculos.
*
*    " text é o acumulador, sep o separador
*    " Ambos são inicializados com vazio
*    " For percorre a tabela
*    " next vai avançando e concatenando a string
*    DATA(sentence) =
*      REDUCE string( INIT text = `` sep = ``
*        FOR wa_ztveiculos IN lt_ztveiculos
*        NEXT text = |{ text }{ sep }{ wa_ztveiculos-modelo }| sep = ` ` ) && '.'.
*    cl_demo_output=>write_data( sentence ).
*
**
*    cl_demo_output=>display(  ).
*  ENDMETHOD.
*ENDCLASS.


**********************************************************************
  " ALTERADO 1
**********************************************************************
*CLASS demo IMPLEMENTATION.
*  METHOD main.
*    TYPES strings TYPE STANDARD TABLE OF string WITH EMPTY KEY.
*    DATA(words) = VALUE strings(
*      ( `A` )
*      ( `B` )
*      ( `C` )
*      ( `D` )
*      ( `E` ) ).
*    cl_demo_output=>write( words ).
*
*    " Percorre o FOR no "array de strings" (tabela interna) 'words',
*    "   fazendo a troca das palavras, se não houver correspondência, retorna a palavra
*    DATA(switched_words) = VALUE strings(
*          FOR word IN words
*           ( SWITCH #( word WHEN `A`        THEN `ZZ`
*                            WHEN `E`        THEN `YY`
*                            ELSE word ) ) ).
*    cl_demo_output=>write_data( switched_words ).
*
*    " text é o acumulador, sep o separador
*    " Ambos são inicializados com vazio
*    " For percorre a tabela de switched words
*    " next vai avançando e concatenando a string
*    DATA(sentence) =
*      REDUCE string( INIT text = `` sep = ``
*        FOR word IN switched_words
*        NEXT text = |{ text }{ sep }{ word }| sep = ` ` ) && '.'.
*    cl_demo_output=>write_data( sentence ).
*
*    " mesma coisa, mas tudo de uma vez
*    "Obfuscation - all in one
**    ASSERT sentence =
**      REDUCE string( INIT text = `` sep = ``
**        "Table reduction
**        FOR word IN VALUE strings(
**          "Table comprehension
**          FOR word IN words
**           ( SWITCH #( word WHEN `All`        THEN `Some`
**                            WHEN `imperative` THEN `functional`
**                            ELSE word ) ) )
**        NEXT text = |{ text }{ sep }{ word }| sep = ` ` ) && '.'.
**
*    cl_demo_output=>display(  ).
*  ENDMETHOD.
*ENDCLASS.


**********************************************************************
  "ORIGINAL
**********************************************************************

*CLASS demo IMPLEMENTATION.
*  METHOD main.
*    TYPES strings TYPE STANDARD TABLE OF string WITH EMPTY KEY.
*    DATA(words) = VALUE strings(
*      ( `All` )
*      ( `ABAP` )
*      ( `constructs` )
*      ( `are` )
*      ( `imperative` ) ).
*    cl_demo_output=>write( words ).
*
*    "Table comprehension into helper table
*    DATA(switched_words) = VALUE strings(
*          FOR word IN words
*           ( SWITCH #( word WHEN `All`        THEN `Some`
*                            WHEN `imperative` THEN `functional`
*                            ELSE word ) ) ).
*    cl_demo_output=>write_data( switched_words ).
*
*    "Table reduction of helper table
*    DATA(sentence) =
*      REDUCE string( INIT text = `` sep = ``
*        FOR word IN switched_words
*        NEXT text = |{ text }{ sep }{ word }| sep = ` ` ) && '.'.
*    cl_demo_output=>write_data( sentence ).
*
*    "Obfuscation - all in one
*    ASSERT sentence =
*      REDUCE string( INIT text = `` sep = ``
*        "Table reduction
*        FOR word IN VALUE strings(
*          "Table comprehension
*          FOR word IN words
*           ( SWITCH #( word WHEN `All`        THEN `Some`
*                            WHEN `imperative` THEN `functional`
*                            ELSE word ) ) )
*        NEXT text = |{ text }{ sep }{ word }| sep = ` ` ) && '.'.
*
*    cl_demo_output=>display(  ).
*  ENDMETHOD.
*ENDCLASS.
