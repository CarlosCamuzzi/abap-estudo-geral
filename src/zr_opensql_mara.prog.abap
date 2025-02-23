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

*&---------------------------------------------------------------------*

REPORT zr_opensql_mara.

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

START-OF-SELECTION.
  PERFORM f_select.
  PERFORM f_select_range.
  PERFORM f_select_multiple_condition.
  PERFORM f_select_aggregation.
  PERFORM f_select_for_all_entries.
  PERFORM f_select_join.
  PERFORM f_select_subqueries.

  " Chamado em PERFORM f_select_subqueries
  "PERFORM f_alv_mara.

  " Comentado pq vai dar erro, pois os dados já foram inseridos/atualizados/excluídos
  " PERFORM f_insert_data.
  " PERFORM f_update_data.
  " PERFORM f_delete_data.

**********************************************************************

*&---------------------------------------------------------------------*
*& Form f_display_data: Exibir Tabela
*&---------------------------------------------------------------------*
FORM f_display_data USING t_table.
  cl_demo_output=>write_data( t_table ).
  cl_demo_output=>display(  ).
ENDFORM.

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
    MESSAGE: TEXT-001 TYPE 'S'.     " Dados encontrados
    "    PERFORM f_display_data USING lt_mara.

  ELSE.
    MESSAGE: TEXT-002 TYPE 'E'.     " Nenhum dado encontrado
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
    MESSAGE: TEXT-001 TYPE 'S'.         " Dados encontrados
    "PERFORM f_display_data USING lt_mara.

  ELSE.
    MESSAGE: TEXT-001 TYPE 'E'.         " Nenhum dado encontrado
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
    MESSAGE: TEXT-001 TYPE 'S'.       " Dados encontrados
    "PERFORM f_display_data USING lt_mara.

  ELSE.
    MESSAGE: TEXT-001 TYPE 'E'.      " Nenhum dado encontrado
  ENDIF.


ENDFORM.

*&---------------------------------------------------------------------*
*& Form f_select_aggregation: Seleção com Agregação
*&---------------------------------------------------------------------*
FORM f_select_aggregation .

  SELECT mtart, COUNT( * ) AS mat_count
   FROM mara
   INTO TABLE @DATA(lt_mtart)
    GROUP BY mtart
    ORDER BY mtart.

  IF sy-subrc EQ 0.
    MESSAGE: TEXT-001 TYPE 'S'.       " Dados encontrados
    "PERFORM f_display_data USING lt_mtart.

  ELSE.
    MESSAGE: TEXT-002 TYPE 'E'.       "  Nenhum dado encontrado
  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form f_insert_data: Inserindo dados
*&---------------------------------------------------------------------*
FORM f_insert_data .

  DATA: ls_mara TYPE mara.

  " Criado: NEW_MAT01, NEW_MAT02, NEW_MAT_03, NEW_MAT_04, NEW_MAT_05 para teste
  ls_mara-matnr = 'NEW_MAT05'.
  ls_mara-ersda = sy-datum.
  ls_mara-ernam = sy-uname.
  ls_mara-mtart = 'FERT'.
  ls_mara-matkl = '006'.
  ls_mara-meins = 'UN'.
  ls_mara-brgew = 47.
  ls_mara-gewei = 'KG'.

  INSERT mara FROM ls_mara.

  IF sy-subrc EQ 0.
    MESSAGE: TEXT-003 TYPE 'S'.   " Dados inseridos com sucesso
    PERFORM f_select_with_range.  " Buscar itens add com range

  ELSE.
    MESSAGE: TEXT-004 TYPE 'E'.   " Erro ao inserir dados
  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form f_select_with_range:  Buscar itens add com range
* Chamado no PERFORM f_insert_data, f_delete_data, f_update_data
*&---------------------------------------------------------------------*
FORM f_select_with_range .

  CLEAR: lt_matnr_range[], ls_matnr_range,
   lt_mara[], wa_mara.

  ls_matnr_range-sign = 'I'.
  ls_matnr_range-option = 'BT'.
  ls_matnr_range-low = 'NEW_MAT01'.
  ls_matnr_range-high = 'NEW_MAT05'.
  APPEND ls_matnr_range TO lt_matnr_range.

  SELECT matnr, ersda, ernam,
        vpsta, pstat, mtart,
        matkl, meins, brgew,
        ntgew, gewei
   FROM mara
   INTO TABLE @DATA(lt_new_mat)
    WHERE matnr IN @lt_matnr_range
    ORDER BY matnr DESCENDING.

  "  PERFORM f_display_data USING lt_new_mat.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form f_update_data: Atualizando dados
*&---------------------------------------------------------------------*
FORM f_update_data .

  UPDATE mara
    SET mtart = 'ROH'
    WHERE matnr EQ 'NEW_MAT01'.

  IF sy-subrc EQ 0.
    MESSAGE: TEXT-005 TYPE 'S'.   " Dados atualizados com sucesso
    PERFORM f_select_with_range.  " Buscar itens com range

  ELSE.
    MESSAGE: TEXT-006 TYPE 'E'.   " Erro ao atualizar dados
  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form f_delete_data
*&---------------------------------------------------------------------*
FORM f_delete_data .

  " Excluído NEW_MAT03 e NEW_MAT02
  DELETE FROM mara WHERE matnr EQ 'NEW_MAT03'.

  IF sy-subrc EQ 0.
    MESSAGE: TEXT-007 TYPE 'S'.   " Registro excluído com sucesso
    PERFORM f_select_with_range.  " Buscar itens com range

  ELSE.
    MESSAGE: TEXT-008 TYPE 'E'.   " Erro ao excluir registro
  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form f_select_for_all_entries: Busca com For All Entries
*&---------------------------------------------------------------------*
FORM f_select_for_all_entries .
  SELECT matnr, ersda, ernam,
         vpsta, pstat, mtart,
         matkl, meins, brgew,
         ntgew, gewei
    FROM mara
    INTO TABLE @lt_mara
    WHERE  mtart = 'FERT'
    ORDER BY matnr.

  IF sy-subrc EQ 0.

    SELECT *  FROM makt
      INTO TABLE @lt_makt
      FOR ALL ENTRIES IN @lt_mara
      WHERE matnr = @lt_mara-matnr
        AND spras = 'J'.

    MESSAGE: TEXT-001 TYPE 'S'.       " Dados inseridos com sucesso

    "    PERFORM  f_display_data USING lt_makt.

  ELSE.
    MESSAGE: TEXT-002 TYPE 'E'.       " Erro ao inserir dados
  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form f_select_join: Join com outras tabelas
*&---------------------------------------------------------------------*
FORM f_select_join .

  SELECT ma~matnr, ma~ersda, ma~ernam,
         ma~vpsta, ma~pstat, ma~mtart,
         mk~spras, mk~maktx, mk~maktg
    FROM mara AS ma
      INNER JOIN makt AS mk
        ON ma~matnr = mk~matnr
      INTO TABLE @DATA(lt_material)
        WHERE ma~mtart = 'ROH'
        AND mk~spras = 'M'
        ORDER BY ma~matnr.

  IF sy-subrc EQ 0.
    MESSAGE: TEXT-001 TYPE 'S'.       " Dados encontrados
    " PERFORM f_display_data USING lt_material.
  ELSE.
    MESSAGE: TEXT-002 TYPE 'E'.       "  Nenhum dado encontrado
  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form f_select_subqueries: Select com subquerie
*&---------------------------------------------------------------------*
FORM f_select_subqueries .

  SELECT matnr, ersda, ernam,
         vpsta, pstat, mtart,
         matkl, meins, brgew,
         ntgew, gewei
    FROM mara
    INTO TABLE @lt_mara
    WHERE matnr IN ( SELECT matnr     " Select em apenas o campo a ser comparado
                      FROM mbew       " Material Valuation
                      WHERE bwkey = 1010 )
    ORDER BY PRIMARY KEY.

  IF sy-subrc EQ 0.
    MESSAGE: TEXT-001 TYPE 'S'.       " Dados encontrados
    "PERFORM f_display_data USING lt_mara.
    PERFORM f_define_fieldcat.
    PERFORM f_alv_mara.
  ELSE.
    MESSAGE: TEXT-002 TYPE 'E'.       "  Nenhum dado encontrado
  ENDIF.

ENDFORM.

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
