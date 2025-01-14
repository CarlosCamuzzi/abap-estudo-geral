*&---------------------------------------------------------------------*
*& Report ZR_ESTUDO_REDUCE_2
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zr_estudo_reduce_2.


TYPES: BEGIN OF ty_where_clause,
         clause TYPE string,
         exist  TYPE abap_bool,
       END OF ty_where_clause.

DATA: lt_where_clause TYPE TABLE OF ty_where_clause,
      wa_where_clause TYPE ty_where_clause.

DATA: t_ztmotoristas TYPE TABLE OF ztmotoristas.

DATA: lv_count TYPE i VALUE 0,
      lv_len   TYPE i VALUE 0.

PARAMETERS: v_nome   TYPE ztmotoristas-nome,
            v_cpf    TYPE ztmotoristas-cpf,
            v_cnh    TYPE ztmotoristas-cnh,
            v_status TYPE ztmotoristas-status.

START-OF-SELECTION.
  PERFORM f_concatena_query.

*&---------------------------------------------------------------------*
*& Form F_CONCATENA_QUERY
*&---------------------------------------------------------------------*
FORM f_concatena_query .
  lt_where_clause = VALUE #(
    ( clause = | nome LIKE '{ v_nome }%' AND |
      exist = COND #( WHEN v_nome IS INITIAL THEN abap_false ELSE abap_true ) )

    ( clause = | cpf LIKE '{ v_cpf }%' AND |
      exist = COND #( WHEN v_cpf IS INITIAL THEN abap_false ELSE abap_true ) )

    ( clause = | cnh LIKE '{ v_cnh }%' AND |
      exist = COND #( WHEN v_cnh IS INITIAL THEN abap_false ELSE abap_true ) )

    ( clause = | status LIKE '{ v_status }%' AND |
    exist = COND #( WHEN v_status IS INITIAL THEN abap_false ELSE abap_true ) )
  ).

  " Quantidade de sentença que existe -  para uso na formatação da query no primeiro try catch
  LOOP AT lt_where_clause INTO wa_where_clause WHERE exist = abap_true.
    lv_count = lv_count + 1.
  ENDLOOP.

  DATA(query) =
  REDUCE string(
    INIT text = `` sep = ``
    FOR where IN lt_where_clause WHERE ( exist = abap_true )
    NEXT text = |{ text }{ sep }{ where-clause }| sep = ` `
  ).

  lv_len = strlen( query ).

  IF lv_len > 0.
    TRY.
        query = substring_before( val = query sub = ` AND` occ = lv_count ).

      CATCH cx_sy_range_out_of_bounds.
        MESSAGE: 'CX_SY_RANGE_OUT_OF_BOUNDS' TYPE 'E'.

      CATCH cx_sy_strg_par_val.
        MESSAGE: 'CX_SY_STRG_PAR_VAL' TYPE 'E'.

      CATCH cx_sy_regex_too_complex.
        MESSAGE: 'CX_SY_REGEX_TOO_COMPLEX' TYPE 'E'.
    ENDTRY.
  ENDIF.

  TRY .
      IF query IS NOT INITIAL.
        SELECT * FROM ztmotoristas
          INTO TABLE @t_ztmotoristas
          WHERE (query)
          ORDER BY nome.
      ELSE.
        SELECT * FROM ztmotoristas
          INTO TABLE @t_ztmotoristas
          ORDER BY nome.
      ENDIF.

    CATCH cx_sy_dynamic_osql_syntax.
      MESSAGE: 'CX_SY_DYNAMIC_OSQL_SYNTAX' TYPE 'E'.

  ENDTRY.

  FREE: lt_where_clause, v_nome, v_cpf, v_cnh, v_status, lv_count, lv_len.

  cl_demo_output=>write_data( query ).
  cl_demo_output=>write_data( t_ztmotoristas ).
  cl_demo_output=>display(  ).

ENDFORM.

" foi simplificado
*  DATA(query) =
*  REDUCE string(
*    INIT text = `` sep = ``
*    FOR where IN lt_where_clause
*    NEXT
*      text = COND #(
*        WHEN where-exist EQ abap_true
*          THEN |{ text }{ sep }{ where-clause }|
*        ELSE text )
*        sep = ` `
*  ).
