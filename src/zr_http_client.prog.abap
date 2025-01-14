*&---------------------------------------------------------------------*
*& Report ZR_HTTP_CLIENT
*&---------------------------------------------------------------------*
*
* Referência: demo_http_client.
*
**********************************************************************
* Descrição
*
* 1 - O método CREATE da classe CL_HTTP_CLIENT é utilizado para criar um objeto cliente  para o endereço wikipedia.org.
* 2 - A variável de referência client, do tipo IF_HTTP_CLIENT, aponta para este objeto.
* 3 - Uma solicitação específica, que também contém o valor de uma entrada do usuário, é adicionada ao URI
*   do objeto REQUEST do objeto cliente.
* 4 - A solicitação é enviada, e o resultado é transferido para o objeto  RESPONSE do objeto cliente.
* 5 - No caso em questão, a página HTML gerada pela solicitação é recuperada e exibida.

**********************************************************************
* Dica
* A configuração do proxy para o cliente HTTP deve ser corretamente ajustada na transação SICF para que este exemplo funcione.
*
*&---------------------------------------------------------------------*

" ESTUDO EM ANDAMENTO
" OBS.: ESTUDAR COMO CONFIGURA SICF

REPORT ZR_HTTP_CLIENT.

CLASS demo DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS main.
ENDCLASS.

CLASS demo IMPLEMENTATION.
  METHOD main.
    DATA query TYPE string VALUE 'SAP'.
    cl_demo_input=>request( CHANGING field = query ).

    cl_http_client=>create(         " Cria o objeto cliente passando o host desejado
      EXPORTING
        host =    'wikipedia.org'
        service = ''
      IMPORTING
        client = DATA(client)       " Aponta para o objeto
      EXCEPTIONS
        OTHERS = 4 ).
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    cl_http_utility=>set_request_uri(   " Entrada de usuário adicionada a URI
      request = client->request
      uri     = `/wiki/` && query ).

    client->send(                       " Enviando solicitação
      EXCEPTIONS
        OTHERS = 4 ).
    IF sy-subrc <> 0.
      client->get_last_error(
        IMPORTING message = DATA(smsg) ).
      cl_demo_output=>display( smsg ).
      RETURN.
    ENDIF.

    client->receive(                    " Recebendo resposta
      EXCEPTIONS
        OTHERS = 4 ).
    IF sy-subrc <> 0.
      client->get_last_error(
        IMPORTING message = DATA(rmsg) ).
      cl_demo_output=>display( rmsg ).
      RETURN.
    ENDIF.

    DATA(html) = client->response->get_cdata( ).
    cl_demo_output=>display_html( html ).

    client->close( ).
  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.
  demo=>main( ).
