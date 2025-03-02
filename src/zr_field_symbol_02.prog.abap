*&---------------------------------------------------------------------*
*& Report ZR_FIELD_SYMBOL_02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zr_field_symbol_02.

*DATA: lv_text TYPE char100.
*FIELD-SYMBOLS: <lv_text> TYPE char100.
*
*lv_text = 'O mundo anda tão complicado'.
*
*ASSIGN lv_text TO <lv_text>.
*WRITE:/ <lv_text>.

**********************************************************************

DATA: lt_produto TYPE TABLE OF ztestudo_produto.

START-OF-SELECTION.
  PERFORM f_select_data.
  PERFORM f_search_data.
  PERFORM f_update_it.
  PERFORM f_search_data.
END-OF-SELECTION.

FORM f_select_data.
  SELECT * INTO TABLE lt_produto
  FROM ztestudo_produto.
ENDFORM.

FORM f_search_data.
  IF sy-subrc = 0.
    LOOP AT lt_produto INTO DATA(ls_produto) WHERE idproduto = 1003.
      WRITE:/ ls_produto-idproduto, ls_produto-descricao.
    ENDLOOP.
  ELSE.
    MESSAGE: 'Nenhum dado encontrado' TYPE 'I'.
  ENDIF.
ENDFORM.

" FS Atualiza a tabela interna diretamente, sem necessidade de append.
FORM f_update_it.
  LOOP AT lt_produto ASSIGNING FIELD-SYMBOL(<fs_produto>).
    <fs_produto>-descricao = 'FARINHA TRIGO 1KG TP3'.
  ENDLOOP.
ENDFORM.
