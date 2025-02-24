*&---------------------------------------------------------------------*
*& Include          ZR_OPENSQL_MARA_INCL_TOP
*&---------------------------------------------------------------------*

" Tables
DATA: lt_mara     TYPE TABLE OF zsmara,     " Structure
      lt_makt     TYPE TABLE OF makt,       " Material Descriptions
      lt_fieldcat TYPE slis_t_fieldcat_alv, " Características colunas relatório
      lt_sort     TYPE slis_t_sortinfo_alv.     " Ordenação

" Work Area
DATA: wa_mara     TYPE zsmara,
      ls_fieldcat TYPE slis_fieldcat_alv,
      ls_sort     TYPE slis_sortinfo_alv,
      ls_layout   TYPE slis_layout_alv.       " Layout para zebra alv

" RANGE ------------------------------------------------------------------------------
* A linha de range (ls_matnr_range) é uma estrutura temporária usada
*   para preencher os campos de um intervalo ou condição.
* Depois de configurada, você a adiciona à tabela de ranges (lt_matnr_range)
*   para compor o filtro completo.
DATA: lt_matnr_range TYPE RANGE OF mara-matnr,    " Range table para filtro de materiais
      ls_matnr_range LIKE LINE OF lt_matnr_range. " Estrutura para uma linha do range

**********************************************************************
