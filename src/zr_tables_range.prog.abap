*&---------------------------------------------------------------------*
*& Report zr_tables_range
*&---------------------------------------------------------------------*
*
*     RANGE TABLE
*
* - Uma "range table" (ou tabela de intervalos) é uma tabela interna especial usada
*   para definir um intervalo de valores para um campo.
* - Ela é comumente utilizada em instruções SELECT ou em outras operações onde você
*   precisa filtrar dados com base em intervalos de valores.
*
*   Estrutura de uma Range Table
*    - Uma range table é geralmente criada com base em uma estrutura que contém os seguintes campos:*
*      - SIGN (Sinal): Indica se o valor deve ser incluído (I) ou excluído (E).*
*      - OPTION (Opção): Define a condição do intervalo, como EQ (igual), BT (entre), GT (maior que), etc.*
*      - LOW (Valor inicial): O valor inicial do intervalo.
*      - HIGH (Valor final): O valor final do intervalo (usado apenas para opções como BT).
*
*    RSPARAMS
*     - O tipo RSPARAMS (Selection Parameters) é tipicamente usado quando você está trabalhando com:
*     - Telas de seleção complexas (Selection Screens)
*     - Parâmetros de relatório que precisam ser salvos
*     - Variantes de programa que envolvem múltiplos campos de seleção

*    - Para casos mais simples onde você só precisa fazer um SELECT com ranges,
*        é melhor usar o RANGES específico do campo (como RANGE OF matnr, RANGE OF vbeln, etc).
*
*    - A principal diferença é:
*        - RSPARAMS: mais complexo, usado para persistir critérios de seleção
*        - RANGES: mais simples, usado para ranges dinâmicos em código

*    EXEMPLO:
*        DATA: lt_params TYPE TABLE OF rsparams,
*              ls_params LIKE LINE OF lt_params.
*
**       *  Para salvar uma variante de selection-screen
*        ls_params-selname = 'S_MATNR'.    "Nome do campo na tela de seleção
*        ls_params-kind    = 'S'.          "S=Selection Option, P=Parameter
*        ls_params-sign    = 'I'.          "I=Include, E=Exclude
*        ls_params-option  = 'BT'.         "EQ, BT, CP, etc
*        ls_params-low     = 'VALOR1'.
*        ls_params-high    = 'VALOR2'.
*        APPEND ls_params TO lt_params.
*
*&---------------------------------------------------------------------*

REPORT zr_tables_range.

DATA: lt_range TYPE RANGE OF matnr,   " Range específico do campo
      ls_range LIKE LINE OF lt_range.

ls_range-sign = 'I'.
ls_range-option = 'BT'.
ls_range-low = 'EWMS4-01'.
ls_range-high = 'EWMS4-50'.
APPEND ls_range TO lt_range.

START-OF-SELECTION.

  SELECT matnr, mtart
      INTO TABLE @DATA(lt_materials)
      FROM mara
      WHERE matnr IN @lt_range.

  LOOP AT lt_materials INTO DATA(ls_materials).
    WRITE:/ ls_materials-matnr, ls_materials-mtart.
  ENDLOOP.

END-OF-SELECTION.

**********************************************************************
* Saída

*EWMS4-01                                 HAWA
*EWMS4-02                                 HAWA
*EWMS4-10                                 HAWA
*EWMS4-11                                 HAWA
*EWMS4-40                                 HAWA
*EWMS4-41                                 HAWA
*EWMS4-42                                 HAWA
*EWMS4-20                                 HAWA
*EWMS4-03                                 HAWA
*EWMS4-50                                 FERT

**********************************************************************
