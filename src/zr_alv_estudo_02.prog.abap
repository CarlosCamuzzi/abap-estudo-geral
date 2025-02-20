*&---------------------------------------------------------------------*
*& Report ZR_ALV_ESTUDO_02
*&---------------------------------------------------------------------*
*
*     Transparent Tables:
*        - AFKO: Order Header Data PP Orders
*        - AUFK: Order master data
*
*      Views:
*        - ITOB: PM technical objects (EQUI, funcational location)
*        - IFLO:    Functional Location (View)
*
*     Structure: zrs_alv_estudo_02.
*        - GSTRP type PM_ORDGSTRP
*        - GLTRP type CO_GLTRP
*        - BUKRS type BUKRS
*        - AUFNR type AUFNR
*        - AUART type AUFART
*        - VAPLZ type GEWRK
*        - KTEXT type AUFTEXT
*        - ERDAT type AUFERFDAT
*
*   Obs.: ITOB e IFLO não utilizada (não encontrei o compo chave com as tabelas AFKO ou AUFK)
*
*&---------------------------------------------------------------------*

REPORT zr_alv_estudo_02 NO STANDARD PAGE HEADING.

TABLES: aufk.     " Order master data

" Internal Tables
DATA: lt_fieldcat TYPE slis_t_fieldcat_alv,       " ALV
      lt_sort     TYPE slis_t_sortinfo_alv,
      lt_header   TYPE slis_t_listheader.

DATA: lt_output TYPE TABLE OF zrs_alv_estudo_02. " Data

" Work Area
DATA: ls_fieldcat TYPE slis_fieldcat_alv,        " ALV
      ls_sort     TYPE slis_sortinfo_alv,
      ls_header   TYPE slis_listheader,
      ls_layout   TYPE slis_layout_alv.

DATA: ls_output TYPE zrs_alv_estudo_02.          " Data

**********************************************************************

SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-001.    " Informe a Empresa
  PARAMETERS: p_bukrs LIKE aufk-bukrs OBLIGATORY.
SELECTION-SCREEN END OF BLOCK b01.

**********************************************************************

START-OF-SELECTION.

  PERFORM f_select_data.
  PERFORM f_alv.

END-OF-SELECTION.

**********************************************************************

FORM f_select_data .

  SELECT afko~gstrp, afko~gltrp, aufk~bukrs, aufk~aufnr,
         aufk~auart,
         aufk~vaplz, aufk~ktext,
         aufk~erdat
    FROM aufk INNER JOIN afko ON afko~aufnr = aufk~aufnr
      INTO TABLE @lt_output
      WHERE aufk~bukrs = @p_bukrs.

  IF sy-subrc NE 0.
    MESSAGE: TEXT-002 TYPE 'I'.     " Nenhum registro encontrado
    STOP.
  ENDIF.

ENDFORM.

FORM f_alv .

  PERFORM f_fieldcat_alv.
  PERFORM f_sort_alv.
  PERFORM f_layout.
  PERFORM f_display_alv.

ENDFORM.

FORM f_fieldcat_alv .

  TRY .
      CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
        EXPORTING
          i_program_name         = sy-repid
          i_internal_tabname     = 'LT_OUTPUT'
          i_structure_name       = 'ZRS_ALV_ESTUDO_02'
        CHANGING
          ct_fieldcat            = lt_fieldcat
        EXCEPTIONS
          inconsistent_interface = 1
          program_error          = 2
          OTHERS                 = 3.

      IF sy-subrc <> 0.
        MESSAGE: TEXT-003 TYPE 'E'.    " Erro ao gerar relatório (fieldcat)
        STOP.
      ENDIF.

      LOOP AT lt_fieldcat INTO ls_fieldcat.
        CASE ls_fieldcat-fieldname.
          WHEN 'GSTRP'.
            ls_fieldcat-no_out = 'X'.

          WHEN 'GLTRP'.
            ls_fieldcat-no_out = 'X'.

          WHEN 'BUKRS'.
            ls_fieldcat-seltext_s = 'Emp'.
            ls_fieldcat-seltext_m = 'Empr'.
            ls_fieldcat-seltext_l = ls_fieldcat-reptext_ddic = 'Empresa'.
            ls_fieldcat-col_pos = 3.

          WHEN 'AUFNR'.
            ls_fieldcat-seltext_s = ls_fieldcat-seltext_m =
            ls_fieldcat-seltext_l = ls_fieldcat-reptext_ddic = 'Ordem'.
            ls_fieldcat-col_pos = 1.

          WHEN 'AUART'.
            ls_fieldcat-seltext_s = 'Tp.Ord'.
            ls_fieldcat-seltext_m = 'Tipo Ord'.
            ls_fieldcat-seltext_l = ls_fieldcat-reptext_ddic = 'Tipo Ordem'.
            ls_fieldcat-col_pos = 2.

          WHEN 'VAPLZ'.
            ls_fieldcat-seltext_s = 'Cn.Trab'.
            ls_fieldcat-seltext_m = 'CenTrabalho'.
            ls_fieldcat-seltext_l = ls_fieldcat-reptext_ddic =  'Centro Trabalho'.

          WHEN 'KTEXT'.
            ls_fieldcat-seltext_s = 'Desc'.
            ls_fieldcat-seltext_m = 'Descri'.
            ls_fieldcat-seltext_l = ls_fieldcat-reptext_ddic = 'Descrição'.

            "WHEN 'EQUNR'.

          WHEN 'ERDAT'.
            ls_fieldcat-seltext_s = 'Dt.Cri'.
            ls_fieldcat-seltext_m = 'Dt Criação'.
            ls_fieldcat-seltext_l = ls_fieldcat-reptext_ddic = 'Data Criação'.

            "WHEN 'TPLNR'.

          WHEN OTHERS.
        ENDCASE.

        MODIFY lt_fieldcat FROM ls_fieldcat INDEX sy-tabix TRANSPORTING seltext_s seltext_m seltext_l reptext_ddic no_out col_pos.

      ENDLOOP .

    CATCH cx_root INTO DATA(lo_excp).
      WRITE: / 'Erro capturado:', lo_excp->get_text( ).

  ENDTRY.


ENDFORM.

FORM f_sort_alv.

  FREE ls_sort.

  ls_sort-spos = 1.
  ls_sort-fieldname = 'AUFNR'.
  ls_sort-tabname = 'LT_OUTPUT'.
  ls_sort-up = 'X'.
  APPEND ls_sort TO lt_sort.

ENDFORM.

FORM f_layout .

  ls_layout-zebra = 'X'.
  ls_layout-colwidth_optimize = 'X'.

ENDFORM.

FORM f_display_alv .

  TRY .
      CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
        EXPORTING
          i_callback_program     = sy-repid
          i_callback_top_of_page = 'F_HEADER'
          is_layout              = ls_layout
          it_fieldcat            = lt_fieldcat
          it_sort                = lt_sort
          i_save                 = 'X'
        TABLES
          t_outtab               = lt_output
        EXCEPTIONS
          program_error          = 1
          OTHERS                 = 2.

      IF sy-subrc <> 0.
        MESSAGE TEXT-004 TYPE 'E'.      " Erro ao gerar relatório (display grid)
      ENDIF.

    CATCH cx_root INTO DATA(lo_excp).
      WRITE: / 'Erro capturado:', lo_excp->get_text( ).

  ENDTRY.


ENDFORM.

FORM f_header.

  DATA: lv_max_date TYPE sy-datum,
        lv_min_date TYPE sy-datum.

  " Handle Date
  SORT lt_output ASCENDING BY gstrp.

  READ TABLE lt_output INTO ls_output INDEX 1.           " Max Date
  lv_max_date =  ls_output-gltrp.

  READ TABLE lt_output INTO ls_output INDEX sy-tabix.    " Min Date
  lv_min_date =  ls_output-gstrp.

  FREE ls_header.
  REFRESH lt_header.

  ls_header-typ = 'H'.
  ls_header-info = TEXT-005.         " Lista de Ordens por Empresa
  APPEND ls_header TO lt_header.

  ls_header-typ = 'S'.
  ls_header-key = TEXT-008.          " Empresa:
  WRITE p_bukrs TO ls_header-info.
  APPEND ls_header TO lt_header.

  ls_header-typ = 'S'.
  ls_header-key = TEXT-006.          " Data de criação início:
  WRITE lv_min_date TO ls_header-info.
  APPEND ls_header TO lt_header.

  ls_header-typ = 'S'.
  ls_header-key = TEXT-007.           " Data de criação fim:
  WRITE lv_max_date TO ls_header-info.
  APPEND ls_header TO lt_header.

  TRY .
      CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
        EXPORTING
          it_list_commentary = lt_header.
    CATCH cx_root INTO DATA(lo_excp).
      WRITE: / 'Erro capturado:', lo_excp->get_text( ).
  ENDTRY.

ENDFORM.
