*&---------------------------------------------------------------------*
*& Report ZR_OPENSQL_MARA
*&---------------------------------------------------------------------*
*
* Tables: MARA: General Material Data
*         MAKT: Material Descriptions
*         MBEW: Material Valuation
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
*  ( ) ALV
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

" Definindo TYPES para usar somente os campos desejados
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

" Internal Table
DATA: lt_mara TYPE TABLE OF ty_mara,   " General Material Data
      lt_makt TYPE TABLE OF makt.      " Material Descriptions

" Work Area
DATA: wa_mara TYPE ty_mara.


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
    PERFORM f_alv_mara.
  ELSE.
    MESSAGE: TEXT-002 TYPE 'E'.       "  Nenhum dado encontrado
  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form f_alv_mara: Relatório ALV
*&---------------------------------------------------------------------*
FORM f_alv_mara.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = sy-repid
    TABLES
      t_outtab           = lt_mara
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.

  IF sy-subrc EQ 0.
    MESSAGE: TEXT-001 TYPE 'S'.       " Dados encontrados
  ELSE.
    MESSAGE: TEXT-002 TYPE 'E'.       "  Nenhum dado encontrado
  ENDIF.

ENDFORM.
