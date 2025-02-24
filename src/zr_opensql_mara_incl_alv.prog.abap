*&---------------------------------------------------------------------*
*& Include          ZR_OPENSQL_MARA_INCL_ALV
*&---------------------------------------------------------------------*


*&---------------------------------------------------------------------*
*& Form f_define_fieldcat: Definir as características da tabela
*  matnr, ersda, ernam, vpsta, pstat, mtart,
*  matkl, meins, brgew, ntgew, gewei
*&---------------------------------------------------------------------*
FORM f_define_fieldcat .
  TRY.
      CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
        EXPORTING
          i_program_name         = sy-repid
          i_internal_tabname     = 'LT_MARA'
          i_structure_name       = 'ZSMARA'
        CHANGING
          ct_fieldcat            = lt_fieldcat
        EXCEPTIONS
          inconsistent_interface = 1
          program_error          = 2
          OTHERS                 = 3.

      IF sy-subrc <> 0.
        MESSAGE: 'Erro fieldcat' TYPE 'E'.
      ENDIF.

    CATCH cx_root INTO DATA(lo_excp).
      WRITE: / 'Erro capturado:', lo_excp->get_text( ).
  ENDTRY.

  LOOP AT lt_fieldcat INTO ls_fieldcat.
    CASE ls_fieldcat-fieldname.
      WHEN 'MATNR'.
        ls_fieldcat-seltext_s = 'Mt.Num'.
        ls_fieldcat-seltext_m = 'Mat.Number'.
        ls_fieldcat-seltext_l = ls_fieldcat-reptext_ddic = 'Material Number'.
      WHEN 'ERSDA'.
        ls_fieldcat-seltext_s = 'Cr.On'.
        ls_fieldcat-seltext_m = 'CreateOn'.
        ls_fieldcat-seltext_l = ls_fieldcat-reptext_ddic = 'Created On'.
      WHEN 'ERNAM'.
        ls_fieldcat-seltext_s = 'Nam.Per'.
        ls_fieldcat-seltext_m = 'NamePers'.
        ls_fieldcat-seltext_l = ls_fieldcat-reptext_ddic = 'Name Person'.
      WHEN 'VPSTA'.
        ls_fieldcat-seltext_s = 'M.Comp.Mt'.
        ls_fieldcat-seltext_m = 'Main.Comp.Mat'.
        ls_fieldcat-seltext_l = ls_fieldcat-reptext_ddic = 'Mainten Comp Mat'.
      WHEN 'PSTAT'.
        ls_fieldcat-seltext_s = 'Main.St'.
        ls_fieldcat-seltext_m = 'Maint.Status'.
        ls_fieldcat-seltext_l = ls_fieldcat-reptext_ddic = 'Maintenance status'.
      WHEN 'MTART'.
        ls_fieldcat-seltext_s = 'Mt.Typ'.
        ls_fieldcat-seltext_m = 'Mat.Type'.
        ls_fieldcat-seltext_l = ls_fieldcat-reptext_ddic = 'Material Type'.
      WHEN 'MATKL'.
        ls_fieldcat-seltext_s = 'Mt.Group'.
        ls_fieldcat-seltext_m = 'Mat Group'.
        ls_fieldcat-seltext_l = ls_fieldcat-reptext_ddic = 'Material Group'.
      WHEN 'MEINS'.
        ls_fieldcat-seltext_s = 'Bs.Un'.
        ls_fieldcat-seltext_m = 'Bas.Unit'.
        ls_fieldcat-seltext_l = ls_fieldcat-reptext_ddic = 'Base Unit'.
      WHEN 'BRGEW'.
        ls_fieldcat-seltext_s = 'Gr.Wght'.
        ls_fieldcat-seltext_m = 'Gross.Wgth'.
        ls_fieldcat-seltext_l = ls_fieldcat-reptext_ddic = 'Gross Weight'.
      WHEN 'NTGEW'.
        ls_fieldcat-seltext_s = 'Nt.Wght'.
        ls_fieldcat-seltext_m = 'Net.Wgth'.
        ls_fieldcat-seltext_l = ls_fieldcat-reptext_ddic = 'Net Weight'.
      WHEN 'GEWEI'.
        ls_fieldcat-seltext_s = 'Wght.Un'.
        ls_fieldcat-seltext_m = 'Wght.Un'.
        ls_fieldcat-seltext_l = ls_fieldcat-reptext_ddic = 'Weight Unit'.
    ENDCASE.

    MODIFY lt_fieldcat FROM ls_fieldcat INDEX sy-tabix
        TRANSPORTING seltext_s seltext_m seltext_l reptext_ddic.
  ENDLOOP.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form f_alv_mara: Relatório ALV
*&---------------------------------------------------------------------*
FORM f_alv_mara.
  TRY .
      CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
        EXPORTING
          i_callback_program       = sy-repid
          it_fieldcat              = lt_fieldcat
          it_sort                  = lt_sort
          is_layout                = ls_layout
          i_callback_pf_status_set = 'F_PF_STATUS'
        TABLES
          t_outtab                 = lt_mara
        EXCEPTIONS
          program_error            = 1
          OTHERS                   = 2.

    CATCH cx_root INTO DATA(lx_exception).
      WRITE: / 'Erro ocorrido:', lx_exception->get_text( ).

  ENDTRY.
ENDFORM.

FORM f_sort_alv.
  FREE ls_sort.

  ls_sort-spos = 1.
  ls_sort-fieldname = 'MATNR'.
  ls_sort-tabname = 'LT_MARA'.
  ls_sort-up = 'X'.
  APPEND ls_sort TO lt_sort.
ENDFORM.

FORM f_layout .
  ls_layout-zebra = 'X'.
  ls_layout-colwidth_optimize = 'X'.
ENDFORM.

**********************************************************************
" Configuração da ToolBar
" Em function group KKBL, copiar ZSTANDARD em Status GUI > Standard
**********************************************************************

FORM f_pf_status USING rt_extab TYPE slis_t_extab.
  SET PF-STATUS 'ZSTANDARD'.
ENDFORM.
