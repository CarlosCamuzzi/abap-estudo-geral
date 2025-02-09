*&---------------------------------------------------------------------*
*& Report ZR_ALV_ESTUDO_01
*&---------------------------------------------------------------------*
* TABLES: ztestudo_produto
*         ztestudo_fornec
* STRUCTURE: zsestudo_produto
*&---------------------------------------------------------------------*

REPORT zr_alv_estudo_01 NO STANDARD PAGE HEADING.

TABLES: ztestudo_produto, ztestudo_fornec.

" Internal Tables
DATA: lt_produto  TYPE TABLE OF ztestudo_produto,
      lt_fornec   TYPE TABLE OF ztestudo_fornec,
      lt_output   TYPE TABLE OF zsestudo_prod_forn,  " Strutcure
      lt_fieldcat TYPE slis_t_fieldcat_alv,          " alv
      lt_sort     TYPE slis_t_sortinfo_alv,          " alv
      lt_header   TYPE slis_t_listheader.            " alv

" Work Area
DATA:" ls_produto  TYPE ztestudo_produto,
  "  ls_fornec   TYPE ztestudo_fornec,
  " ls_output   TYPE zsestudo_prod_forn,
  ls_fieldcat TYPE slis_fieldcat_alv,
  ls_sort     TYPE slis_sortinfo_alv,
  ls_header   TYPE slis_listheader,            " Header ALV
  ls_layout   TYPE slis_layout_alv,            " Layout ALV
  ls_variant  TYPE disvariant.                 " Save Layout

**********************************************************************
" Selection Screen
SELECTION-SCREEN BEGIN OF BLOCK bc01 WITH FRAME TITLE TEXT-001.
  SELECT-OPTIONS: s_idprod FOR ztestudo_produto-idproduto.
  "                  s_idforn FOR ztestudo_fornec-idfornec.

SELECTION-SCREEN END OF BLOCK bc01.

SELECTION-SCREEN BEGIN OF BLOCK bc02 WITH FRAME TITLE TEXT-002.
  PARAMETERS: p_varian TYPE slis_vari.    " Save layout
SELECTION-SCREEN END OF BLOCK bc02.


" Implementar variant

**********************************************************************

START-OF-SELECTION.
  PERFORM f_select_data.      " Select in ztestudo_produto/ztestudo_fornec
  PERFORM f_output_table.     " lt_output/ls_fieldcat
  PERFORM f_create_alv.       " lt_fieldcat/ls_fieldcat
  PERFORM f_sort_alv.         " lt_sort/ls_sort
  PERFORM f_layout_alv.       " ls_layout
  PERFORM f_display_alv.

**********************************************************************

FORM f_select_data.
  SELECT * FROM ztestudo_produto
      INTO TABLE @lt_produto
      WHERE idproduto IN @s_idprod.

  IF sy-subrc = 0.
    SELECT * FROM ztestudo_fornec
    INTO TABLE @lt_fornec
    FOR ALL ENTRIES IN @lt_produto
      WHERE idfornec = @lt_produto-idfornec.
  ELSE.
    MESSAGE: 'Not found' TYPE 'E'.
  ENDIF.

ENDFORM.

FORM f_output_table.    " Merge data lt_produto and lt_fornec

  lt_output = VALUE #(
      FOR ls_produto IN lt_produto
      LET ls_fornec  = VALUE #(
          lt_fornec[ idfornec = ls_produto-idfornec ] OPTIONAL )
      IN ( idproduto      = ls_produto-idproduto
           descricao      = ls_produto-descricao
           tipo_embalagem = ls_produto-tipo_embalagem
           embalagem      = ls_produto-embalagem
           preco          = ls_produto-preco
           quantidade     = ls_produto-quantidade
           idfornec       = ls_fornec-idfornec
           razao_social   = ls_fornec-razao_social
           estado         = ls_fornec-estado
          )
  ).

ENDFORM.

FORM f_create_alv.

ENDFORM.

FORM f_sort_alv.

ENDFORM.

FORM f_layout_alv.

ENDFORM.

FORM f_display_alv.

ENDFORM.
