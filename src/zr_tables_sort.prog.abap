*&---------------------------------------------------------------------*
*& Report zr_tables_sort
*&---------------------------------------------------------------------*
*
*  SORTED TABLE
*
*   - Uma SORTED TABLE é um tipo especial de tabela interna em ABAP que mantém seus
*       registros automaticamente ordenados com base em uma ou mais colunas definidas como chaves.
*
*   Características principais:
*     - Ordenação Automática
*       - Os registros são inseridos automaticamente na posição correta
*       - A ordenação é baseada nas colunas definidas como chaves
*       - Não é necessário usar SORT explicitamente
*
*     - Tipos de Chave
*       - UNIQUE KEY: Não permite registros duplicados com a mesma chave
*       - NON-UNIQUE KEY: Permite registros duplicados
*
*     - Performance
*       - Busca binária mais rápida que tabelas STANDARD
*       - Ideal para tabelas que precisam estar sempre ordenadas
*       - Ótima para operações de leitura frequentes
*
*     - Restrições
*       - Inserções são mais lentas que em tabelas STANDARD
*       - Não é possível usar o comando SORT
*       - A ordem dos registros não pode ser alterada manualmente
*
*&---------------------------------------------------------------------*

REPORT zr_tables_sort.

TYPES: BEGIN OF ty_pessoa,
         id    TYPE i,
         nome  TYPE string,
         idade TYPE i,
       END OF ty_pessoa.

DATA: lt_pessoa TYPE SORTED TABLE OF ty_pessoa WITH UNIQUE KEY id.

lt_pessoa = VALUE #(
        ( id = 4 nome = 'Márcia'  idade = 33 )
        ( id = 1 nome = 'Arnaldo' idade = 45 )
        ( id = 3 nome = 'Zelma'   idade = 18 )
        ( id = 2 nome = 'Pedro'   idade = 22 )
     ).

START-OF-SELECTION.

  cl_demo_output=>write( lt_pessoa ).
  cl_demo_output=>display( ).
