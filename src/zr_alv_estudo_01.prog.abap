*&---------------------------------------------------------------------*
*& Report ZR_ALV_ESTUDO_01
*&---------------------------------------------------------------------*
* TABLES: ztestudo_produto
*         ztestudo_fornec
* STRUCTURE: zsestudo_prod_forn
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
DATA: ls_sort     TYPE slis_sortinfo_alv,          " Sort ALV
      ls_header   TYPE slis_listheader,            " Header ALV
      ls_layout   TYPE slis_layout_alv,            " Layout ALV
      ls_fieldcat TYPE slis_fieldcat_alv,
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


" Implementar variant e user command

**********************************************************************

START-OF-SELECTION.
  PERFORM f_select_data.      " Select in ztestudo_produto/ztestudo_fornec
  PERFORM f_output_table.     " lt_output/lt_produto/lt_fornec
  PERFORM f_create_alv.       " lt_fieldcat/ls_fieldcat/lt_output

**********************************************************************

FORM f_select_data.     " Search database

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

  PERFORM f_define_fieldcat.  " lt_fieldcat/ls_fieldcat/lt_output
  PERFORM f_sort_alv.         " lt_sort/ls_sort
  PERFORM f_layout_alv.       " ls_layout
  PERFORM f_display_alv.

ENDFORM.

FORM f_define_fieldcat.     " Defines column characteristics

  CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
    EXPORTING
      i_program_name         = sy-repid
      i_internal_tabname     = 'LT_OUTPUT'
      i_structure_name       = 'ZSESTUDO_PROD_FORN'
    CHANGING
      ct_fieldcat            = lt_fieldcat
    EXCEPTIONS
      inconsistent_interface = 1
      program_error          = 2
      OTHERS                 = 3.

  IF sy-subrc <> 0.
    MESSAGE: 'Erro na definição da Fieldcat' TYPE 'E'.

  ELSE.
    LOOP AT lt_fieldcat INTO ls_fieldcat.
      CASE ls_fieldcat-fieldname.
        WHEN 'IDPRODUTO'.
          ls_fieldcat-seltext_s = ls_fieldcat-seltext_m = ls_fieldcat-seltext_l = ls_fieldcat-reptext_ddic = 'IDPROD'.

        WHEN 'DESCRICAO'.
          ls_fieldcat-seltext_s = ls_fieldcat-seltext_m = ls_fieldcat-seltext_l = ls_fieldcat-reptext_ddic = 'DESCRICAO'.

        WHEN 'TIPO_EMBALAGEM'.
          ls_fieldcat-seltext_s = ls_fieldcat-seltext_m = ls_fieldcat-seltext_l = ls_fieldcat-reptext_ddic = 'TP_EMBAG'.

        WHEN 'EMBALAGEM'.
          ls_fieldcat-seltext_s = ls_fieldcat-seltext_m = ls_fieldcat-seltext_l = ls_fieldcat-reptext_ddic = 'QT_EMB'.

        WHEN 'PRECO'.
          ls_fieldcat-seltext_s = ls_fieldcat-seltext_m = ls_fieldcat-seltext_l = ls_fieldcat-reptext_ddic = 'PRECO'.

        WHEN 'QUANTIDADE'.
          ls_fieldcat-seltext_s = ls_fieldcat-seltext_m = ls_fieldcat-seltext_l = ls_fieldcat-reptext_ddic = 'QUANT'.

        WHEN 'IDFORNEC'.
          ls_fieldcat-seltext_s = ls_fieldcat-seltext_m = ls_fieldcat-seltext_l = ls_fieldcat-reptext_ddic = 'IDFORN'.

        WHEN 'RAZAO_SOCIAL'.
          ls_fieldcat-seltext_s = ls_fieldcat-seltext_m = ls_fieldcat-seltext_l = ls_fieldcat-reptext_ddic = 'RAZAO_SOC'.

        WHEN 'ESTADO'.
          ls_fieldcat-seltext_s = ls_fieldcat-seltext_m = ls_fieldcat-seltext_l = ls_fieldcat-reptext_ddic = 'UF'.

      ENDCASE.

      MODIFY lt_fieldcat FROM ls_fieldcat
        INDEX sy-tabix TRANSPORTING seltext_s seltext_m seltext_l reptext_ddic.

    ENDLOOP.

  ENDIF.

ENDFORM.

FORM f_sort_alv.

  FREE ls_sort.

  ls_sort-spos = 1.
  ls_sort-fieldname = 'DESCRICAO'.
  ls_sort-tabname = 'LT_OUTPUT'.
  ls_sort-up = 'X'.
  APPEND ls_sort TO lt_sort.

ENDFORM.

FORM f_layout_alv.

  ls_layout-zebra = 'X'.
  ls_layout-colwidth_optimize = 'X'.

ENDFORM.

FORM f_display_alv.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = sy-repid
*     i_callback_user_command     = 'USER_COMMAND'
     i_callback_top_of_page      = 'F_HEADER'
      is_layout          = ls_layout
      it_fieldcat        = lt_fieldcat
      it_sort            = lt_sort
      i_save             = 'X'
      is_variant         = ls_variant
    TABLES
      t_outtab           = lt_output
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.

  IF sy-subrc <> 0.
    MESSAGE: 'Erro no relatório ALV' TYPE 'E'.
  ENDIF.

ENDFORM.

form f_header.

    free ls_header.
    refresh lt_header.

    ls_header-typ = 'H'.     " H = Header, S = Selection, A = Action
    ls_header-info = 'Relatório de Produtos e Fornecedores'.
    append ls_header to lt_header.

    ls_header-typ = 'S'.
    ls_header-key = 'Data.:'.
    write sy-datum to ls_header-info.
    append ls_header to lt_header.

    ls_header-typ = 'S'.
    ls_header-key = 'Hora.:'.
    write sy-uzeit to ls_header-info.
    append ls_header to lt_header.

    call FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
      EXPORTING
        it_list_commentary = lt_header
        i_logo             = 'ENJOYSAP_LOGO'.

ENDFORM.
