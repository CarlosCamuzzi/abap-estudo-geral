*&---------------------------------------------------------------------*
*& Report ZR_OPENSQL_MARA
*&---------------------------------------------------------------------*
*
* Table: MARA
*
* -------------------------------
*   Lista de estudo
* -------------------------------
*  ( X ) Seleção simples com ordenação
*  ( ) Seleção com intervalos
*  ( ) Seleção com múltiplas condições
*  ( ) Seleção com agregação
*  ( ) Inserção de registros
*  ( ) Atualização de registros
*  ( ) Deleção de registros
*  ( ) Seleção com FOR ALL ENTRIES
*  ( ) Joins com outras tabelas
*  ( ) Subqueries
*  ( ) ALV
* -------------------------------
*&---------------------------------------------------------------------*

REPORT zr_opensql_mara.

TYPES: BEGIN OF ty_mara,
         matnr TYPE mara-matnr,
         ersda TYPE mara-ersda,
         ernam TYPE mara-ernam,
         vpsta TYPE mara-vpsta,
         pstat TYPE mara-pstat,
         mtart TYPE mara-mtart,
         matkl TYPE mara-matkl,
         meins TYPE mara-meins,
         brgew TYPE mara-brgew,
         ntgew TYPE mara-ntgew,
         gewei TYPE mara-gewei,
       END OF ty_mara.

DATA: lt_mara TYPE TABLE OF ty_mara,
      wa_mara TYPE ty_mara.

START-OF-SELECTION.
  PERFORM f_select_data.


*&---------------------------------------------------------------------*
*& Form f_select_data:  Seleção simples com ordenação
*&---------------------------------------------------------------------*
FORM f_select_data .

  SELECT matnr, ersda, ernam,
         vpsta, pstat, mtart,
         matkl, meins, brgew,
         ntgew, gewei
    FROM mara
    INTO TABLE @lt_mara
    ORDER BY PRIMARY KEY.

  IF sy-subrc EQ 0.
    MESSAGE: 'Dados encontrados' TYPE 'S'.
    PERFORM f_display_data.

  ELSE.
    MESSAGE: 'Dados não encontrados' TYPE 'E'.
  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form f_display_data
*&---------------------------------------------------------------------*
FORM f_display_data .
  cl_demo_output=>write_data( lt_mara ).
  cl_demo_output=>display(  ).
ENDFORM.
