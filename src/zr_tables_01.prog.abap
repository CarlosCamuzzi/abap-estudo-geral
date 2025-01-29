*&---------------------------------------------------------------------*
*& Report ZR_TABLES_01
*&---------------------------------------------------------------------*
*&  Revisando funcionamento das tabelas
**********************************************************************
**********************************************************************

* TYPES
*   - Usando types para declarar tabela e work area
*TYPES: tt_casa_std TYPE STANDARD TABLE OF ty_casa. " Tipo
*DATA: lt_casa_std_ty TYPE tt_casa_std,             " Tabela (não usa table of, pois tt_casa_std já é uma tabela)
*      ls_casa_std_ty TYPE ty_casa.                 " Estrutura é referenciada ao tipo base
*
*    Para exemplificar: Com TYPES funciona da mesma forma
*  ls_casa_std_ty-id = 1.
*  ls_casa_std_ty-cor = 'Vermelha'.
*  ls_casa_std_ty-comodos = 4.
*  APPEND ls_casa_std_ty TO lt_casa_std_ty.
*  PERFORM f_display_data USING lt_casa_std_ty.

**********************************************************************
* LINE OF
*   - A cláusula TYPE LINE OF só pode ser usada com tabelas internas, não com estruturas.
*   - O código abaixo dará erro, pois MARA não é um tipo ou tabela interna, e sim uma estrutura.
*        data: lt_mara type LINE OF mara.
*
**********************************************************************
*&---------------------------------------------------------------------*
REPORT zr_tables_01.

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

* Com types passou para o PERFORM a tabela com USING
TYPES: tt_casa_std TYPE STANDARD TABLE OF ty_casa. " Tipo
DATA: lt_casa_std TYPE tt_casa_std,             " Tabela (não usa table of, pois tt_casa_std já é uma tabela)
      ls_casa_std TYPE ty_casa.                 " Estrutura é referenciada ao tipo base


**********************************************************************

START-OF-SELECTION.
  PERFORM f_casa CHANGING lt_casa_std ls_casa_std.
  PERFORM f_busca_casa USING lt_casa_std.

**********************************************************************

  "IELD-SYMBOLS: <fs_casa> TYPE ty_casa.
  LOOP AT LT_CASA_std  ASSIGNING FIELD-SYMBOL(<fs_casa>) WHERE id = 2.

  ENDLOOP.

  " Exibe Tela
FORM f_display_data USING VALUE(lt_casa).
  cl_demo_output=>write_data( lt_casa ).
  cl_demo_output=>display(  ).
ENDFORM.

" Gera Dados
FORM f_casa CHANGING lt_casa TYPE table
                     ls_casa TYPE ty_casa.
  DO 20 TIMES.
    lv_index = sy-index.                      " sy-index retorna o número da iteração atual

    ls_casa-id = lv_index.
    ls_casa-cor = 'Cor ' && lv_index.     " Concatenação para gerar cores dinâmicas
    ls_casa-comodos = lv_index MOD 5 + 2. " Gera um número de cômodos entre 2 e 6

    APPEND ls_casa TO lt_casa.
  ENDDO.

  PERFORM f_display_data USING lt_casa.

ENDFORM.

" Usando FIELD-SYMBOLS
FORM f_busca_casa USING VALUE(lt_casa) TYPE tt_casa_std.
  LOOP AT lt_casa  ASSIGNING FIELD-SYMBOL(<fs_casa>) WHERE id > 2 AND id < 7.
    WRITE: | [ID] ........ { <fs_casa>-id } |,
           | [CÔMODOS].... { <fs_casa>-comodos } |,
           | [COR]........ { <fs_casa>-cor } |.
    SKIP.
  ENDLOOP.
ENDFORM.
