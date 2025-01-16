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
*  ( X ) Seleção com intervalos
*  ( X ) Seleção com múltiplas condições
*  ( X ) Seleção com agregação
*  ( ) Inserção de registros
*  ( ) Atualização de registros
*  ( ) Deleção de registros
*  ( ) Seleção com FOR ALL ENTRIES
*  ( ) Joins com outras tabelas
*  ( ) Subqueries
*  ( ) ALV
* -------------------------------

**********************************************************************
* RANGE:
* RSPARAMS - ABAP: General Structure for PARA METERS and SELECT-OPTIONS
**********************************************************************
*
*  Alguns valores comuns para OPTION são:
*   'EQ' (Equal)
*   'NE' (Not Equal)
*   'GT' (Greater Than)
*   'LT' (Less Than)
*   'GE' (Greater or Equal)
*   'LE' (Less or Equal)
*   'BT' (Between)
*   'NB' (Not Between)
*
*   LOW: Valor inicial do intervalo.
*   HIGH: Valor final do intervalo (usado apenas para operações como BT ou NB).
*
* Para SIGN:
*   I: Include (Incluir)
*   E: Exclude (Excluir)

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

" RANGE ------------------------------------------------------------------------------
* A linha de range (ls_matnr_range) é uma estrutura temporária usada
*   para preencher os campos de um intervalo ou condição.
* Depois de configurada, você a adiciona à tabela de ranges (lt_matnr_range)
*   para compor o filtro completo.
DATA: lt_matnr_range TYPE RANGE OF mara-matnr,    " Range table para filtro de materiais
      ls_matnr_range LIKE LINE OF lt_matnr_range. " Estrutura para uma linha do range

**********************************************************************

START-OF-SELECTION.
  PERFORM f_select.
  PERFORM f_select_range.
  PERFORM f_select_multiple_condition.
  PERFORM f_select_aggregation.
  PERFORM f_insert_data.

**********************************************************************

*&---------------------------------------------------------------------*
*& Form f_select:  Seleção simples com ordenação
*&---------------------------------------------------------------------*
FORM f_select .

  SELECT matnr, ersda, ernam,
         vpsta, pstat, mtart,
         matkl, meins, brgew,
         ntgew, gewei
    FROM mara
    INTO TABLE @lt_mara
    ORDER BY PRIMARY KEY.

  IF sy-subrc EQ 0.
    MESSAGE: TEXT-001 TYPE 'S'.
    "    PERFORM f_display_data USING lt_mara.

  ELSE.
    MESSAGE: TEXT-002 TYPE 'E'.
  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form f_select_range: Seleção com intervalos
*&---------------------------------------------------------------------*
FORM f_select_range .
  " Campos sign, option, low, high estão na estrutura:
  " RSPARAMS - ABAP: General Structure for PARA METERS and SELECT-OPTIONS
  CLEAR: lt_matnr_range[], ls_matnr_range,
         lt_mara[], wa_mara.

  ls_matnr_range-sign = 'I'.          "I = Include (incluir)
  ls_matnr_range-option = 'BT'.       "BT = Between (entre valores)
  ls_matnr_range-low = 'EWMS4-01'.    "Valor inicial do intervalo
  ls_matnr_range-high = 'EWMS4-601'.  "Valor final do intervalo
  APPEND ls_matnr_range TO lt_matnr_range.

  SELECT matnr, ersda, ernam,
         vpsta, pstat, mtart,
         matkl, meins, brgew,
         ntgew, gewei
   FROM mara
   INTO TABLE  @lt_mara
   WHERE matnr IN @lt_matnr_range.

  IF sy-subrc EQ 0.
    MESSAGE: TEXT-001 TYPE 'S'.
    "PERFORM f_display_data USING lt_mara.

  ELSE.
    MESSAGE: TEXT-001 TYPE 'E'.
  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form f_select_multiple_condition: Seleção com múltiplas condições
*&---------------------------------------------------------------------*
FORM f_select_multiple_condition .

  CLEAR: lt_matnr_range[], ls_matnr_range,
       lt_mara[], wa_mara.

  ls_matnr_range-sign = 'I'.          "I = Include (incluir)
  ls_matnr_range-option = 'BT'.       "BT = Between (entre valores)
  ls_matnr_range-low = 'EWMS4-01'.    "Valor inicial do intervalo
  ls_matnr_range-high = 'EWMS4-601'.  "Valor final do intervalo
  APPEND ls_matnr_range TO lt_matnr_range.

  SELECT matnr, ersda, ernam,
         vpsta, pstat, mtart,
         matkl, meins, brgew,
         ntgew, gewei
   FROM mara
   INTO TABLE  @lt_mara
   WHERE matnr IN @lt_matnr_range
    AND vpsta = 'KLVEDGB'
    "OR MTART = 'ROH'.
    AND mtart = 'ROH'.

  IF sy-subrc EQ 0.
    MESSAGE: TEXT-001 TYPE 'S'.
    "PERFORM f_display_data USING lt_mara.

  ELSE.
    MESSAGE: TEXT-001 TYPE 'E'.
  ENDIF.


ENDFORM.

*&---------------------------------------------------------------------*
*& Form f_select_aggregation: Seleção com Agregação
*&---------------------------------------------------------------------*
FORM f_select_aggregation .

  SELECT mtart, COUNT( * ) AS mat_count
   FROM mara
   INTO TABLE @data(lt_mtart)
    GROUP BY mtart
    ORDER BY mtart.

 IF sy-subrc EQ 0.
  MESSAGE: TEXT-001 TYPE 'S'.
  PERFORM f_display_data USING lt_mtart.

ELSE.
  MESSAGE: TEXT-002 TYPE 'E'.
ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form f_insert_data
*&---------------------------------------------------------------------*
FORM f_insert_data .

ENDFORM.

*&---------------------------------------------------------------------*
*& Form f_display_data
*&---------------------------------------------------------------------*
FORM f_display_data USING t_table.
  cl_demo_output=>write_data( t_table ).
  cl_demo_output=>display(  ).
ENDFORM.
