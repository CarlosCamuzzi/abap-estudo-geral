**********************************************************************
*& Report zr_alv_estudo_04
**********************************************************************
* Tables:
*
*  VBAK: Cabeçalho de Vendas
*    - VBELN (Número do documento de vendas)
*    - ERDAT (Data de criação do documento)
*    - ERZET (Hora de criação do documento)N
*    - WAERK (Moeda do documento)
*    - KUNNR (Número do cliente)
*
*  VBAP: Itens de Vendas
*    - VBELN (Número do documento de vendas)
*    - POSNR (Número do item)
*    - MATNR (Número do material)
*    - NETWR (Valor líquido do item)
*    - WERKS (Centro/Região)

*  KNA1: Dados Gerais do Cliente
*    - KUNNR (Número do cliente)
*    - NAME1 (Nome do cliente)
*    - REGIO (Região do cliente)

**********************************************************************
*
* Structure: ZRS_ALV_ESTUDO_04
*
***********************************************************************
*
* Tela de Seleção (SELECT-OPTIONS)
*    - Região (REGIO)
*    - Período (ERDAT)
*    - Cliente (KUNNR)
*
**********************************************************************

REPORT zr_alv_estudo_04 NO STANDARD PAGE HEADING.

**********************************************************************

TABLES: vbak, kna1, vbap.

DATA: lt_output   TYPE TABLE OF zrs_alv_estudo_04,
      lt_fieldcat TYPE TABLE OF slis_fieldcat_alv,
      lt_sort     TYPE slis_t_sortinfo_alv,
      lt_header   TYPE slis_t_listheader.

DATA: ls_output   TYPE zrs_alv_estudo_04,
      ls_fieldcat TYPE slis_fieldcat_alv,
      ls_sort     TYPE slis_sortinfo_alv,
      ls_header   TYPE slis_listheader,
      ls_layout   TYPE slis_layout_alv.

**********************************************************************

SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-001.
  SELECT-OPTIONS: s_kunnr FOR kna1-kunnr,
                  s_erdat FOR vbak-erdat,
                  s_regio FOR kna1-regio.
SELECTION-SCREEN END OF BLOCK b01.

**********************************************************************

START-OF-SELECTION.
  PERFORM f_select_data.
  PERFORM f_build_fieldcat.
  PERFORM f_build_alv.

**********************************************************************

FORM f_select_data.

  SELECT vbak~vbeln, vbak~erdat, vbak~erzet,
         vbak~ernam, vbak~waerk,
         vbap~posnr, vbap~matnr, vbap~netwr, vbap~werks,
         vbak~kunnr, kna1~name1, kna1~regio
    FROM vbak
      INNER JOIN kna1 ON kna1~kunnr = vbak~kunnr
      INNER JOIN vbap ON vbap~vbeln = vbak~vbeln
      INTO TABLE @lt_output
      WHERE vbak~kunnr IN @s_kunnr
        AND kna1~regio IN @s_regio
        AND vbak~erdat IN @s_erdat.

  IF sy-subrc <> 0.
    MESSAGE 'Nenhum dado encontrado' TYPE 'E'.
*    cl_demo_output=>write_data( lt_output ).
*    cl_demo_output=>display(  ).
  ENDIF.

ENDFORM.

FORM f_build_fieldcat.

  FIELD-SYMBOLS: <fs_fieldcat> TYPE slis_fieldcat_alv.

  TRY.
      CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
        EXPORTING
          i_program_name         = sy-repid
          i_internal_tabname     = 'LT_OUTPUT'
          i_structure_name       = 'ZRS_ALV_ESTUDO_04'
          i_client_never_display = 'X'
          i_buffer_active        = 'X'
        CHANGING
          ct_fieldcat            = lt_fieldcat
        EXCEPTIONS
          inconsistent_interface = 1
          program_error          = 2
          OTHERS                 = 3.

      IF sy-subrc <> 0.
        MESSAGE: 'Erro na definição da Fieldcat' TYPE 'E'.
        STOP.
      ENDIF.

      LOOP AT lt_fieldcat ASSIGNING <fs_fieldcat>.
        CASE <fs_fieldcat>-fieldname.
          WHEN 'VBELN'.
            <fs_fieldcat>-seltext_s = 'Dc.Vda'.
            <fs_fieldcat>-seltext_m = 'Doc.Venda'.
            <fs_fieldcat>-seltext_l = 'Documento Venda'.
            <fs_fieldcat>-reptext_ddic = 'Documento Venda'.

          WHEN 'ERDAT'.
            <fs_fieldcat>-seltext_s = 'Dt'.
            <fs_fieldcat>-seltext_m = 'Dat'.
            <fs_fieldcat>-seltext_l = 'Data'.
            <fs_fieldcat>-reptext_ddic = 'Data Criação'.

          WHEN 'ERZET'.
            <fs_fieldcat>-seltext_s = 'Hr'.
            <fs_fieldcat>-seltext_m = 'Hor'.
            <fs_fieldcat>-seltext_l = 'Hora'.
            <fs_fieldcat>-reptext_ddic = 'Hora Criação'.

          WHEN 'ERNAM'.
            <fs_fieldcat>-seltext_s = 'Usr'.
            <fs_fieldcat>-seltext_m = 'Usr'.
            <fs_fieldcat>-seltext_l = 'Usuário'.
            <fs_fieldcat>-reptext_ddic = 'Usuário'.

          WHEN 'WAERK'.
            <fs_fieldcat>-seltext_s = 'Md'.
            <fs_fieldcat>-seltext_m = 'Moed'.
            <fs_fieldcat>-seltext_l = 'Moeda'.
            <fs_fieldcat>-reptext_ddic = 'Moeda'.

          WHEN 'POSNR'.
            <fs_fieldcat>-seltext_s = 'N.It'.
            <fs_fieldcat>-seltext_m = 'Num.It'.
            <fs_fieldcat>-seltext_l = 'Número Item'.
            <fs_fieldcat>-reptext_ddic = 'Número Item'.

          WHEN 'MATNR'.
            <fs_fieldcat>-seltext_s = 'N.Mt'.
            <fs_fieldcat>-seltext_m = 'Num.Mt'.
            <fs_fieldcat>-seltext_l = 'Número Material'.
            <fs_fieldcat>-reptext_ddic = 'Número Material'.

          WHEN 'NETWR'.
            <fs_fieldcat>-seltext_s = 'Vl'.
            <fs_fieldcat>-seltext_m = 'Vlr'.
            <fs_fieldcat>-seltext_l = 'Valor'.
            <fs_fieldcat>-reptext_ddic = 'Valor Item'.

          WHEN 'WERKS'.
            <fs_fieldcat>-seltext_s = 'Ct.Tr'.
            <fs_fieldcat>-seltext_m = 'Cntr.Trab'.
            <fs_fieldcat>-seltext_l = 'Centro Trabalho'.
            <fs_fieldcat>-reptext_ddic = 'Centro Trabalho'.

          WHEN 'KUNNR'.
            <fs_fieldcat>-seltext_s = 'Cli'.
            <fs_fieldcat>-seltext_m = 'Client'.
            <fs_fieldcat>-seltext_l = 'Cliente'.
            <fs_fieldcat>-reptext_ddic = 'Cliente'.

          WHEN 'NAME1'.
            <fs_fieldcat>-seltext_s = 'N.Cl'.
            <fs_fieldcat>-seltext_m = 'Nom.Cli'.
            <fs_fieldcat>-seltext_l = 'Nome Cliente'.
            <fs_fieldcat>-reptext_ddic = 'Nome Cliente'.

          WHEN 'REGIO'.
            <fs_fieldcat>-seltext_s = 'Est'.
            <fs_fieldcat>-seltext_m = 'Estad'.
            <fs_fieldcat>-seltext_l = 'Estado'.
            <fs_fieldcat>-reptext_ddic = 'Estado'.

          WHEN OTHERS.
        ENDCASE.

      ENDLOOP.

    CATCH cx_root INTO DATA(lo_excp).
      MESSAGE: |ERROR: { lo_excp->get_text( ) }| TYPE 'I'.
  ENDTRY.


ENDFORM.

FORM f_build_alv.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
*     i_interface_check        = space
*     i_bypassing_buffer       = space
*     i_buffer_active          = space
      i_callback_program       = sy-repid
      i_callback_pf_status_set = 'F_PF_STATUS'
*     i_callback_user_command  = space
      i_callback_top_of_page   = 'F_HEADER'
*     i_callback_html_top_of_page = space
*     i_callback_html_end_of_list = space
*     i_structure_name         =
*     i_background_id          =
*     i_grid_title             =
*     i_grid_settings          =
      is_layout                = ls_layout
      it_fieldcat              = lt_fieldcat
*     it_excluding             =
*     it_special_groups        =
      it_sort                  = lt_sort
*     it_filter                =
*     is_sel_hide              =
*     i_default                = 'X'
"     i_save                   = 'X'
      "is_variant                  =
*     it_events                =
*     it_event_exit            =
*     is_print                 =
*     is_reprep_id             =
*     i_screen_start_column    = 0
*     i_screen_start_line      = 0
*     i_screen_end_column      = 0
*     i_screen_end_line        = 0
*     i_html_height_top        = 0
*     i_html_height_end        = 0
*     it_alv_graphics          =
*     it_hyperlink             =
*     it_add_fieldcat          =
*     it_except_qinfo          =
*     ir_salv_fullscreen_adapter  =
*     o_previous_sral_handler  =
*      IMPORTING
*     e_exit_caused_by_caller  =
*     es_exit_caused_by_user   =
    TABLES
      t_outtab                 = lt_output
    EXCEPTIONS
      program_error            = 1
      OTHERS                   = 2.

  IF sy-subrc <> 0.
    MESSAGE: 'Erro na geração do ALV' TYPE 'E'.
    STOP.
  ENDIF.

ENDFORM.
