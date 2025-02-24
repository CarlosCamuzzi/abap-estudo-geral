*&---------------------------------------------------------------------*
*& Report ZR_OPENSQL_MARA
*&---------------------------------------------------------------------*
*
* Tables: MARA: General Material Data
*         MAKT: Material Descriptions
*         MBEW: Material Valuation
*
*  Structure:
*      matnr  TYPE matnr,
*      ersda  TYPE ersda,
*      ernam  TYPE ernam,
*      vpsta  TYPE vpsta,
*      pstat  TYPE pstat_d,
*      mtart  TYPE mtart,
*      matkl  TYPE matkl,
*      meins  TYPE meins,
*      brgew  TYPE brgew,
*      ntgew  TYPE ntgew,
*      gewei  TYPE gewei.
*
* -------------------------------
*   Lista de estudo
* -------------------------------
*  ( X ) Seleção simples com ordenação
*  ( X ) Seleção com intervalos
*  ( X ) Seleção com múltiplas condições
*  ( X ) Seleção com agregação
*  ( X ) Inserção de registros
*  ( X ) Atualização de registros
*  ( X ) Deleção de registros
*  ( X ) Seleção com FOR ALL ENTRIES
*  ( X ) Joins com outras tabelas
*  ( X ) Subqueries
*  ( X ) ALV
* -------------------------------
*
**********************************************************************
*  PERFORM f_display_data USING comentado em algumas partes para fim
*    de testes de outras partes de código.
**********************************************************************
*
**********************************************************************
* RANGE:
* RSPARAMS - ABAP: General Structure for PARAMETERS and SELECT-OPTIONS
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
**********************************************************************

REPORT zr_opensql_mara_incl.

" Separando por includes
INCLUDE zr_opensql_mara_incl_top.
INCLUDE zr_opensql_mara_incl_sos.
INCLUDE zr_opensql_mara_incl_form.
INCLUDE zr_opensql_mara_incl_alv.
