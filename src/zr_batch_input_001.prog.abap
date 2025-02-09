*&---------------------------------------------------------------------*
*& Report zr_batch_input_001
*&---------------------------------------------------------------------*
*
* 1 - Criar manutenção de tabela (SM35)
* 2 - Mapeamento da BDC (Transaction SHDB)
*
* - Tabela: zrestudo_produto
*      idproduto
*      idfornec
*      descricao
*      tipo_embalagem
*      embalagem
*      preco
*      quantidade

* - Transaction Manut Tabela: ztrproduto
* - BDC: zmap_produto
*
*&---------------------------------------------------------------------*

REPORT zr_batch_input_001 NO STANDARD PAGE HEADING.

* File
TYPES: BEGIN OF ty_file,
         idproduto      TYPE int4,
         idfornec       TYPE int4,
         descricao      TYPE char_35,
         tipo_embalagem TYPE char2,
         embalagem      TYPE int4,
         preco          TYPE p DECIMALS 2,
         quantidade     TYPE      int4,
       END OF ty_file.

* Format to .csv
TYPES: BEGIN OF ty_csv,
         line TYPE c LENGTH 100,
       END OF ty_csv.

" Internal Tables
DATA: lt_format_file TYPE TABLE OF ty_file,
      lt_csv         TYPE TABLE OF ty_csv,
      lt_bdcdata     TYPE TABLE OF bdcdata.

* Work Area
DATA: ls_format_file TYPE ty_file,
      ls_csv         TYPE TABLE OF ty_csv,
      ls_bdcdata     TYPE bdcdata.

**********************************************************************

SELECTION-SCREEN BEGIN OF BLOCK bc01 WITH FRAME TITLE TEXT-001.
  PARAMETERS: p_file TYPE localfile.
SELECTION-SCREEN END OF BLOCK bc01.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.
  PERFORM f_select_file.


**********************************************************************
FORM f_select_file.

  TRY .
      CALL FUNCTION 'KD_GET_FILENAME_ON_F4'
        EXPORTING
          field_name    = p_file
        CHANGING
          file_name     = p_file
        EXCEPTIONS
          mask_too_long = 1
          OTHERS        = 2.

      IF sy-subrc IS NOT INITIAL.
        MESSAGE: 'Erro no seleção do arquivo' TYPE 'E'.
      ENDIF.

    CATCH cx_root INTO DATA(lx_exception).
      MESSAGE: lx_exception->get_text( ) TYPE 'E'.
  ENDTRY.

ENDFORM.
