*&---------------------------------------------------------------------*
*& Include          ZR_OPENSQL_MARA_INCL_SOS
*&---------------------------------------------------------------------*

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
