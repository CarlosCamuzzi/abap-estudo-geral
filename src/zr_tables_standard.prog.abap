*&---------------------------------------------------------------------*
*& Report ZR_TABLES_STANDARD
*&---------------------------------------------------------------------*
*     Tabela Standard
*    - Estrutura: Uma tabela standard é uma lista linear de linhas,
*      onde os dados são armazenados na ordem em que são inseridos.
*
*    - Acesso: O acesso aos dados pode ser feito por índice ou por meio de
*      uma busca sequencial (LOOP ou READ TABLE).
*
*    - Desempenho: O acesso por índice é rápido (O(1)), mas a busca sequencial pode
*      ser lenta (O(n)) para grandes volumes de dados.
*
*    - Uso recomendado: Quando a ordem de inserção dos dados é importante
*      e o acesso por índice é frequente.
*
*    Exemplo de declaração:
*    - DATA: lt_standard TYPE TABLE OF zstructure WITH DEFAULT KEY.

**********************************************************************

*   Dicas de uso
*   - Use Standard quando a ordem de inserção é importante e o acesso
*     por índice é frequente.

*   - Use Sorted quando os dados precisam estar sempre ordenados e o
*     acesso por chave é prioritário.

*   - Use Hashed quando o acesso rápido por chave é crítico e a ordem dos
*     dados não importa.

**********************************************************************

*    Sobre Field-Symbols
*    - Ao usar FIELD-SYMBOL, acessamos diretamente a linha da tabela interna
*     por referência, sem criar uma cópia dos dados.
*
*    - Características
*      - Acesso direto → FIELD-SYMBOL aponta diretamente para a linha da tabela, sem cópia.
*      - Modificações refletem na tabela → Se você alterar <fs_casa>, a tabela original será modificada.
*      - Eficiência → Evita cópias de dados, tornando a execução mais rápida, especialmente para tabelas grandes.
*
*    - O uso de FIELD-SYMBOL é mais eficiente porque evita a cópia de dados.
*      Isso é crucial em:
*
*    Tabelas grandes → Para milhares ou milhões de registros, evitar cópias economiza tempo e memória.
*
*    Estruturas complexas → Se a tabela contém tipos profundos, a cópia pode ser custosa.
*    ⚠ No entanto, para tabelas pequenas ou operações simples, a diferença de desempenho pode ser insignificante.
*
*    Use FIELD-SYMBOL quando:
*    ✔ Deseja modificar diretamente a tabela original.
*    ✔ O desempenho é crítico (ex.: tabelas grandes ou operações intensivas).
*    ✔ Está lidando com estruturas complexas e quer evitar cópias desnecessárias.

*&---------------------------------------------------------------------*
REPORT ZR_TABLES_STANDARD no STANDARD PAGE HEADING.

TYPES: BEGIN OF ty_casa,
         id      TYPE i,
         cor     TYPE string,
         comodos TYPE i,
       END OF ty_casa.

DATA: lv_index TYPE i.

**********************************************************************
" Tabela interna STANDARD e work area
*DATA: lt_casa_std TYPE STANDARD TABLE OF ty_casa,
*      ls_casa_std TYPE ty_casa.

* Com types para o PERFORM a tabela com USING
TYPES: tt_casa_std TYPE STANDARD TABLE OF ty_casa. " Tipo
DATA: lt_casa_std TYPE tt_casa_std,                " Tabela (não usa table of, pois tt_casa_std já é uma tabela)
      ls_casa_std TYPE ty_casa.                    " Estrutura é referenciada ao tipo base

**********************************************************************

START-OF-SELECTION.
  PERFORM f_casa CHANGING lt_casa_std ls_casa_std.
  PERFORM f_busca_casa USING lt_casa_std.

**********************************************************************

" Exibe Tela ---------------------------------------
FORM f_display_data USING VALUE(lt_casa).
  cl_demo_output=>write_data( lt_casa ).
  cl_demo_output=>display(  ).
ENDFORM.

" Gera Dados ---------------------------------------
FORM f_casa CHANGING lt_casa TYPE table
                     ls_casa TYPE ty_casa.
  DO 20 TIMES.
    lv_index = sy-index.                      " sy-index retorna o número da iteração atual

    ls_casa-id = lv_index.
    ls_casa-cor = 'Cor ' && lv_index.         " Concatenação para gerar cores dinâmicas
    ls_casa-comodos = lv_index MOD 5 + 2.     " Gera um número de cômodos entre 2 e 6

    APPEND ls_casa TO lt_casa.
  ENDDO.

  PERFORM f_display_data USING lt_casa.

ENDFORM.

" Usando FIELD-SYMBOLS ------------------------------
FORM f_busca_casa USING VALUE(lt_casa) TYPE tt_casa_std.
  LOOP AT lt_casa ASSIGNING FIELD-SYMBOL(<fs_casa>) WHERE id > 2 AND id < 7.
    WRITE: | [ID] ........ { <fs_casa>-id } |,
           | [CÔMODOS].... { <fs_casa>-comodos } |,
           | [COR]........ { <fs_casa>-cor } |.
    SKIP.
  ENDLOOP.
ENDFORM.
