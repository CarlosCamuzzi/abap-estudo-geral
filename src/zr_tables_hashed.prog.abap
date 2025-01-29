*&---------------------------------------------------------------------*
*& Report ZR_TABLES_HASHED
*&---------------------------------------------------------------------*
*   Tabela Hashed
*      - Estrutura: Uma tabela hashed usa uma função de hash para armazenar os dados,
*        o que permite acesso extremamente rápido por chave.
*
*      - Acesso: O acesso é feito exclusivamente por chave, com complexidade O(1) em média.
*
*      - Desempenho: Inserções, exclusões e buscas por chave são muito rápidas, mas o
*       acesso por índice não é suportado.
*
*      - Uso recomendado: Quando é necessário acesso rápido por chave e a ordem dos dados não
*        é importante.
*
*   Exemplo de declaração:
*       DATA: lt_hashed TYPE HASHED TABLE OF zstructure WITH UNIQUE KEY campo1.
*
**********************************************************************
*  OBS.:
*      - O loop LOOP AT só funciona com tabelas internas do tipo STANDARD TABLE ou SORTED TABLE.
*      - O objetivo principal é aproveitar o acesso rápido aos dados com base
*        em uma chave única, sem a necessidade de percorrer a tabela com um LOOP.
*      - Para buscar um dado em uma HASHED TABLE, você deve usar a instrução READ TABLE com a chave única.

**********************************************************************
*
*   Dicas de uso
*   - Use Standard quando a ordem de inserção é importante e o acesso por índice é frequente.
*   - Use Sorted quando os dados precisam estar sempre ordenados e o acesso por chave é prioritário.
*   - Use Hashed quando o acesso rápido por chave é crítico e a ordem dos dados não importa.

*&---------------------------------------------------------------------*

REPORT zr_tables_hashed NO STANDARD PAGE HEADING.

DATA: lt_mara TYPE HASHED TABLE OF mara WITH UNIQUE KEY matnr,
      ls_mara TYPE mara.


START-OF-SELECTION.
  PERFORM f_select_data.

FORM f_select_data.
  SELECT *
      INTO TABLE @lt_mara
      FROM mara.

  IF sy-subrc IS INITIAL.
    READ TABLE lt_mara INTO ls_mara WITH TABLE KEY matnr = 'EWMS4-601'.
    WRITE:/ 'Material encontrado'.
    ULINE.
    WRITE:/ ls_mara-matnr, ls_mara-mtart, ls_mara-matkl.
  ELSE.
    WRITE:/ 'Material não encontrado'.
  ENDIF.
ENDFORM.
