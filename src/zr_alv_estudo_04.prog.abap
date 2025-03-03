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
*
*  KNA1: Dados Gerais do Cliente
*    - KUNNR (Número do cliente)
*    - NAME1 (Nome do cliente)
*    - REGIO (Região do cliente)
*
*  MAKT: Material Descriptions
*   - MATNR - Utilizado no USER_COMMAND
*
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
      lt_header   TYPE TABLE OF slis_listheader,
      lt_sort     TYPE slis_t_sortinfo_alv.

DATA: ls_output   TYPE zrs_alv_estudo_04,
      ls_fieldcat TYPE slis_fieldcat_alv,
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
  PERFORM f_sort.
  PERFORM f_layout.
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
            "<fs_fieldcat>-hotspot = 'X'.

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

FORM f_sort.

  REFRESH: lt_sort.
  lt_sort = VALUE #( ( spos = 1 fieldname = 'VBELN' tabname = 'LT_OUTPUT' up = 'X' ) ).

ENDFORM.

FORM f_layout.

  FREE ls_layout.
  ls_layout-zebra = 'X'.
  ls_layout-colwidth_optimize = 'X'.

ENDFORM.

FORM f_build_alv.

  TRY.
      CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
        EXPORTING
          i_callback_program       = sy-repid
          i_callback_pf_status_set = 'PF_STATUS'
          "i_callback_user_command  = 'USER_COMMAND'
          i_callback_top_of_page   = 'F_HEADER'
          is_layout                = ls_layout
          it_fieldcat              = lt_fieldcat
          it_sort                  = lt_sort
        TABLES
          t_outtab                 = lt_output
        EXCEPTIONS
          program_error            = 1
          OTHERS                   = 2.

      IF sy-subrc <> 0.
        MESSAGE: 'Erro na geração do ALV' TYPE 'E'.
        STOP.
      ENDIF.

    CATCH cx_root INTO DATA(lo_excp).
      MESSAGE: |ERROR: { lo_excp->get_text( ) }| TYPE 'I'.

  ENDTRY.

ENDFORM.

FORM f_header.      " H = Header, S = Selection, A = Action

  DATA: lv_time           TYPE string,
        lv_formatted_time TYPE string,
        lv_formatted_date TYPE string.

  " Handle Time and Date
  " Outra forma de concatenar
*  lv_time = sy-uzeit.
*  CONCATENATE lv_time+0(2) ':' lv_time+2(2) ':' lv_time+4(2)
*    INTO lv_formatted_time.

  TRY.
      CALL FUNCTION 'CONVERT_DATE_TO_EXTERNAL'
        EXPORTING
          date_internal            = sy-datum
        IMPORTING
          date_external            = lv_formatted_date
        EXCEPTIONS
          date_internal_is_invalid = 1
          OTHERS                   = 2.

      lv_time = sy-uzeit.
      lv_formatted_time = |{ lv_time+0(2) }:{ lv_time+2(2) }:{ lv_time+4(2) }|.

    CATCH cx_root INTO DATA(lo_ex).
      MESSAGE: |ERROR: { lo_ex->get_text( ) }| TYPE 'I'.
  ENDTRY.

  REFRESH: lt_header.

  lt_header = VALUE #(
    ( typ = 'H' info = |Relatório de vendas| )
    ( typ = 'S' key = |Data Criação:| info = lv_formatted_date )
    ( typ = 'S' key = |Hora Criação:| info = lv_formatted_time )
    ( typ = 'S' key = |Usuário:|      info = sy-uname )
  ).

  TRY.
      CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
        EXPORTING
          it_list_commentary = lt_header.

    CATCH cx_root INTO DATA(lo_excp).
      MESSAGE: |ERROR: { lo_excp->get_text( ) }| TYPE 'I'.

  ENDTRY.

ENDFORM.

FORM pf_status USING rt_extab TYPE slis_t_extab.
  SET PF-STATUS 'ZSTANDARD'.
ENDFORM.
*
*FORM user_command USING r_ucomm     LIKE sy-ucomm
*                        rs_selfield TYPE slis_selfield.
*
*  " Campos que serão exibidos
*  DATA: lt_vimsellist TYPE STANDARD TABLE OF vimsellist.
*
*  lt_vimsellist = VALUE #( ( viewfield = 'MATNR' operator = 'EQ' value = rs_selfield-value ) ).
*
*  " Tratamento para pegar somente os dados do campo que foi clicado
*  IF rs_selfield-sel_tab_field = 'LT_OUTPUT-MATNR'.
*    CALL FUNCTION 'VIEW_MAINTENANCE_CALL'
*      EXPORTING
*        action                       = 'S'                " Exibir
*        view_name                    = 'MAKT'             " Tabela transparente
*      TABLES
*        dba_sellist                  = lt_vimsellist
*      EXCEPTIONS
*        client_reference             = 1
*        foreign_lock                 = 2
*        invalid_action               = 3
*        no_clientindependent_auth    = 4
*        no_database_function         = 5
*        no_editor_function           = 6
*        no_show_auth                 = 7
*        no_tvdir_entry               = 8
*        no_upd_auth                  = 9
*        only_show_allowed            = 10
*        system_failure               = 11
*        unknown_field_in_dba_sellist = 12
*        view_not_found               = 13
*        maintenance_prohibited       = 14
*        OTHERS                       = 15.
*  ENDIF.
*
*ENDFORM.
