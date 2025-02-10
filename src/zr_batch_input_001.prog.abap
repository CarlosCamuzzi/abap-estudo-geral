*&---------------------------------------------------------------------*
*& Report zr_batch_input_001
*&---------------------------------------------------------------------*
*   CARGA DE DADOS
*     1 - Criar manutenção de tabela (SM35)
*     2 - Mapeamento da BDC (Transaction SHDB)
*
**********************************************************************
*
* - Tabela: zrestudo_produto
*      idproduto
*      idfornec
*      descricao
*      tipo_embalagem
*      embalagem
*      preco
*      quantidade
*
* - Transaction Manut Tabela: ztrproduto
* - BDC: zmap_produto
*
**********************************************************************
*
* - Tabela: zrestudo_fornec
*      idfornec
*      razao_social
*      estado
*
* - Transaction Manut Tabela: ztrfornecedor
* - BDC: zmap_fornec
*
*&---------------------------------------------------------------------*

REPORT zr_batch_input_001 NO STANDARD PAGE HEADING.

* Files
TYPES: BEGIN OF ty_file_produto,
         idproduto      TYPE string,
         idfornec       TYPE string,
         descricao(35)  TYPE c,
         tipo_embalagem TYPE string,
         embalagem(2)   TYPE c,
         preco          TYPE string,
         quantidade     TYPE string,
       END OF ty_file_produto.

TYPES: BEGIN OF ty_file_fornec,
         idfornec         TYPE string,
         razao_social(35) TYPE c,
         estado(2)        TYPE c,
       END OF ty_file_fornec.

* Format to .csv
TYPES: BEGIN OF ty_csv,
         line TYPE c LENGTH 100,
       END OF ty_csv.

" Internal Tables
DATA: lt_file_produto TYPE TABLE OF ty_file_produto,
      lt_file_fornec  TYPE TABLE OF ty_file_fornec,
      lt_csv          TYPE TABLE OF ty_csv,
      lt_bdcdata      TYPE TABLE OF bdcdata.

* Work Area
DATA: ls_file_produto TYPE ty_file_produto,
      ls_file_fornec  TYPE ty_file_fornec,
      ls_csv          TYPE ty_csv,
      ls_bdcdata      TYPE bdcdata.

**********************************************************************

* Select File
SELECTION-SCREEN BEGIN OF BLOCK bc01 WITH FRAME TITLE TEXT-001. " Selecionar Arquivo
  PARAMETERS: p_file   TYPE localfile.
SELECTION-SCREEN END OF BLOCK bc01.

* File Type
SELECTION-SCREEN BEGIN OF BLOCK bc02 WITH FRAME TITLE TEXT-002. " Tipo de Arquivo
    PARAMETERS: p_fornec RADIOBUTTON GROUP gr01,
                p_prod   RADIOBUTTON GROUP gr01.
SELECTION-SCREEN END OF BLOCK bc02.

**********************************************************************

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.
  PERFORM f_select_file.

START-OF-SELECTION.
  PERFORM f_upload_file.
  PERFORM f_create_bdc.

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

      IF sy-subrc <> 0.
        MESSAGE: 'Erro no seleção do arquivo' TYPE 'E'.
        STOP.
      ENDIF.

    CATCH cx_root INTO DATA(lx_exception).
      MESSAGE: lx_exception->get_text( ) TYPE 'E'.
  ENDTRY.

ENDFORM.

FORM f_upload_file.

  " FILENAME in Funcion is type STRING
  " P_FILE is type LOCALFILE
  DATA: lv_filename TYPE string.
  lv_filename = p_file.           " cast

  TRY.
      CALL FUNCTION 'GUI_UPLOAD'
        EXPORTING
          filename                = lv_filename
          filetype                = 'ASC'
        TABLES
          data_tab                = lt_csv
        EXCEPTIONS
          file_open_error         = 1
          file_read_error         = 2
          no_batch                = 3
          gui_refuse_filetransfer = 4
          invalid_type            = 5
          no_authority            = 6
          unknown_error           = 7
          bad_data_format         = 8
          header_not_allowed      = 9
          separator_not_allowed   = 10
          header_too_long         = 11
          unknown_dp_error        = 12
          access_denied           = 13
          dp_out_of_memory        = 14
          disk_full               = 15
          dp_timeout              = 16
          OTHERS                  = 17.

      IF sy-subrc = 0.
        IF p_prod = 'X'.
          LOOP AT lt_csv INTO ls_csv.
            SPLIT ls_csv AT ';'
                INTO ls_file_produto-idproduto
                     ls_file_produto-idfornec
                     ls_file_produto-descricao
                     ls_file_produto-tipo_embalagem
                     ls_file_produto-embalagem
                     ls_file_produto-preco
                     ls_file_produto-quantidade.

            APPEND ls_file_produto TO lt_file_produto.
          ENDLOOP.

        ELSEIF p_fornec = 'X'.
          LOOP AT lt_csv INTO ls_csv.
            SPLIT ls_csv AT ';'
                INTO ls_file_fornec-idfornec
                     ls_file_fornec-razao_social
                     ls_file_fornec-estado.

            APPEND ls_file_fornec TO lt_file_fornec.
          ENDLOOP.

        ELSE.
          MESSAGE: 'Erro no upload do arquivo' TYPE 'E'.
          STOP.

        ENDIF.
      ENDIF.

    CATCH cx_root INTO DATA(lx_exception).
      MESSAGE: lx_exception->get_text( ) TYPE 'E'.
  ENDTRY.

ENDFORM.

FORM f_create_bdc.

  DATA: lv_group TYPE apqi-groupid. " Name (f_open_folder): TYPE in function BDC_OPEN_GROUP
  DATA: lv_tcode TYPE tstc-tcode.   " Transaction code (f_insert_data): TYPE in function BDC_INSERT

  IF p_fornec = 'X'.
    lv_tcode = 'ZTRFORNECEDOR'.
    lv_group = 'CARGA_FORNEC'.

    PERFORM f_open_folder USING lv_group.

    LOOP AT lt_file_fornec INTO ls_file_fornec.
      PERFORM f_bdc_screen USING 'SAPLZGRABAP_ESTUDO' '0003'.
      PERFORM f_bdc_data   USING 'BDC_CURSOR'         'VIM_POSITION_INFO'.
      PERFORM f_bdc_data   USING 'BDC_OKCODE'         '=NEWL'.

      PERFORM f_bdc_screen USING 'SAPLZGRABAP_ESTUDO' '0004'.
      PERFORM f_bdc_data   USING 'BDC_CURSOR'         'ZTESTUDO_FORNEC-ESTADO'.
      PERFORM f_bdc_data   USING 'BDC_OKCODE'         '=SAVE'.
      PERFORM f_bdc_data   USING 'ZTESTUDO_FORNEC-IDFORNEC'     ls_file_fornec-idfornec.
      PERFORM f_bdc_data   USING 'ZTESTUDO_FORNEC-RAZAO_SOCIAL' ls_file_fornec-razao_social.
      PERFORM f_bdc_data   USING 'ZTESTUDO_FORNEC-ESTADO'       ls_file_fornec-estado.

      PERFORM f_bdc_screen USING 'SAPLZGRABAP_ESTUDO' '0004'.
      PERFORM f_bdc_data   USING 'BDC_CURSOR'         'ZTESTUDO_FORNEC-RAZAO_SOCIAL'.
      PERFORM f_bdc_data   USING 'BDC_OKCODE'         '=ENDE'.

      PERFORM f_insert_data USING lv_tcode.

    ENDLOOP.

    PERFORM f_close_path.

  ELSE.
    lv_tcode = 'ZTRPRODUTO'.
    lv_group = 'CARGA_PRODUTO'.

    PERFORM f_open_folder USING lv_group.

    LOOP AT lt_file_produto INTO ls_file_produto.
      PERFORM f_bdc_screen USING 'SAPLZGRABAP_ESTUDO' '0001'.
      PERFORM f_bdc_data   USING 'BDC_CURSOR'         'VIM_POSITION_INFO'.
      PERFORM f_bdc_data   USING 'BDC_OKCODE'         '=NEWL'.

      PERFORM f_bdc_screen USING 'SAPLZGRABAP_ESTUDO' '0002'.
      PERFORM f_bdc_data   USING 'BDC_CURSOR'         'ZTESTUDO_PRODUTO-QUANTIDADE'.
      PERFORM f_bdc_data   USING 'BDC_OKCODE'         '=SAVE'.
      PERFORM f_bdc_data   USING 'ZTESTUDO_PRODUTO-IDPRODUTO'      ls_file_produto-idproduto.
      PERFORM f_bdc_data   USING 'ZTESTUDO_PRODUTO-IDFORNEC'       ls_file_produto-idfornec.
      PERFORM f_bdc_data   USING 'ZTESTUDO_PRODUTO-DESCRICAO'      ls_file_produto-descricao.
      PERFORM f_bdc_data   USING 'ZTESTUDO_PRODUTO-TIPO_EMBALAGEM' ls_file_produto-tipo_embalagem.
      PERFORM f_bdc_data   USING 'ZTESTUDO_PRODUTO-EMBALAGEM'      ls_file_produto-embalagem.
      PERFORM f_bdc_data   USING 'ZTESTUDO_PRODUTO-PRECO'          ls_file_produto-preco.
      PERFORM f_bdc_data   USING 'ZTESTUDO_PRODUTO-QUANTIDADE'     ls_file_produto-quantidade.

      PERFORM f_bdc_screen USING 'SAPLZGRABAP_ESTUDO' '0002'.
      PERFORM f_bdc_data   USING 'BDC_CURSOR'         'ZTESTUDO_PRODUTO-DESCRICAO'.
      PERFORM f_bdc_data   USING 'BDC_OKCODE'         '=ENDE'.

      PERFORM f_insert_data USING lv_tcode.

    ENDLOOP.

    PERFORM f_close_path.

  ENDIF.

ENDFORM.

FORM f_open_folder USING VALUE(p_group).

  TRY.
      CALL FUNCTION 'BDC_OPEN_GROUP'
        EXPORTING
          client              = sy-mandt
          group               = p_group             " Folder name
          keep                = 'X'                  " Save
          user                = sy-uname
        EXCEPTIONS
          client_invalid      = 1
          destination_invalid = 2
          group_invalid       = 3
          group_is_locked     = 4
          holddate_invalid    = 5
          internal_error      = 6
          queue_error         = 7
          running             = 8
          system_lock_error   = 9
          user_invalid        = 10
          OTHERS              = 11.

      IF sy-subrc <> 0.
        MESSAGE: 'Erro ao abrir pasta batch' TYPE 'E'.
        STOP.
      ENDIF.

    CATCH cx_root INTO DATA(lx_exception).
      MESSAGE: lx_exception->get_text( ) TYPE 'E'.

  ENDTRY.

ENDFORM.

FORM f_bdc_screen USING VALUE(p_program)
                        VALUE(p_screen).
  FREE ls_bdcdata.

  ls_bdcdata-program = p_program.
  ls_bdcdata-dynpro = p_screen.
  ls_bdcdata-dynbegin = 'X'.

  APPEND ls_bdcdata TO lt_bdcdata.

ENDFORM.

FORM f_bdc_data USING VALUE(p_name)
                      VALUE(p_value).
  FREE ls_bdcdata.

  ls_bdcdata-fnam = p_name.
  ls_bdcdata-fval = p_value.

  APPEND ls_bdcdata TO lt_bdcdata.

ENDFORM.

FORM f_insert_data USING VALUE(p_tcode).

  TRY.
      CALL FUNCTION 'BDC_INSERT'
        EXPORTING
          tcode            = p_tcode  " Transaction
        TABLES
          dynprotab        = lt_bdcdata    " BDC table
        EXCEPTIONS
          internal_error   = 1
          not_open         = 2
          queue_error      = 3
          tcode_invalid    = 4
          printing_invalid = 5
          posting_invalid  = 6
          OTHERS           = 7.

      IF sy-subrc <> 0.
        MESSAGE: 'Erro ao inserir BDC' TYPE 'E'.
        STOP.
      ELSE.
        MESSAGE: 'Dados inseridos com sucesso' TYPE 'S'.
        FREE lt_bdcdata.
      ENDIF.

    CATCH cx_root INTO DATA(lx_exception).
      MESSAGE: lx_exception->get_text( ) TYPE 'E'.

  ENDTRY.

ENDFORM.

FORM f_close_path.

  TRY.
      CALL FUNCTION 'BDC_CLOSE_GROUP'
        EXCEPTIONS
          not_open    = 1
          queue_error = 2
          OTHERS      = 3.

      IF sy-subrc <> 0.
        MESSAGE: 'Erro ao fechar pasta batch' TYPE 'E'.
        STOP.
      ENDIF.

    CATCH cx_root INTO DATA(lx_exception).
      MESSAGE: lx_exception->get_text( ) TYPE 'E'.

  ENDTRY.

ENDFORM.
