*&---------------------------------------------------------------------*
*& Report zr_01_poo_classelocal
*&---------------------------------------------------------------------*
*  md_ atributo de instância da classe
*  id_ variável simples
*  rd_ returning variável
*&---------------------------------------------------------------------*
REPORT zr_01_poo_classelocal NO STANDARD PAGE HEADING.

CLASS lcl_cliente DEFINITION.
  PUBLIC SECTION.
    METHODS set_cpf
      IMPORTING id_cpf TYPE char11.

    METHODS get_cpf
      RETURNING VALUE(rd_cpf) TYPE char11.

    METHODS get_cpf_formatado
      RETURNING VALUE(rd_cpf) TYPE char14.

    METHODS set_nome
      IMPORTING id_nome TYPE string.

    METHODS get_nome
      RETURNING VALUE(rd_nome) TYPE string.

  PRIVATE SECTION.
    DATA: md_cpf  TYPE char11,
          md_nome TYPE string.
ENDCLASS.

CLASS lcl_cliente IMPLEMENTATION.

  METHOD set_cpf.
    IF strlen( id_cpf ) <> 11.
      RETURN.
    ENDIF.

    me->md_cpf = id_cpf.
  ENDMETHOD.

  METHOD get_cpf.
    rd_cpf = md_cpf.
  ENDMETHOD.

  METHOD get_cpf_formatado.
    rd_cpf = |{ md_cpf+0(3) }.{ md_cpf+3(3) }.{ md_cpf+6(3) }-{ md_cpf+9(2) } |.
  ENDMETHOD.

  METHOD set_nome.
    me->md_nome = id_nome.
  ENDMETHOD.

  METHOD get_nome.
    rd_nome = md_nome.
  ENDMETHOD.
ENDCLASS.

**********************************************************************
CLASS lcl_pedido DEFINITION.
  public SECTION.
    METHODS set_cliente
      IMPORTING io_cliente TYPE REF TO lcl_cliente.

    METHODS get_cliente
      RETURNING VALUE(ro_cliente) TYPE REF TO lcl_cliente.

  PRIVATE SECTION.
    DATA: mo_cliente TYPE REF TO lcl_cliente.
ENDCLASS.

CLASS lcl_pedido IMPLEMENTATION.
  METHOD set_cliente.
    me->mo_cliente = io_cliente.
  ENDMETHOD.

  METHOD get_cliente.
    ro_cliente = mo_cliente.
  ENDMETHOD.
ENDCLASS.

**********************************************************************

START-OF-SELECTION.
  DATA: lo_cliente1 TYPE REF TO lcl_cliente.
  DATA: lo_pedido TYPE REF TO lcl_pedido.

  lo_cliente1 = NEW lcl_cliente(  ).

  lo_cliente1->set_cpf( id_cpf = '12345678910' ).
  WRITE:/ lo_cliente1->get_cpf( ).
  WRITE:/ lo_cliente1->get_cpf_formatado( ).

  " Passando um objeto cliente
  lo_pedido->set_cliente( io_cliente = lo_cliente1 ).
