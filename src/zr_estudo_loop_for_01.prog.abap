*&---------------------------------------------------------------------*
*& Report ZR_ESTUDO_LOOP_FOR_01
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZR_ESTUDO_LOOP_FOR_01.

TYPES : BEGIN OF ty_flight,
          seq_num type i,
          carrier TYPE s_carrname,
          connect TYPE s_conn_id,
          fldate  TYPE s_date,
        END OF ty_flight.

DATA lt_new_flights TYPE STANDARD TABLE OF ty_flight.

SELECT * FROM sflight INTO TABLE @DATA(lt_flights).
IF sy-subrc EQ 0.
  SELECT * FROM scarr INTO TABLE @DATA(lt_scarr).

ENDIF.

"FOR Iteration
lt_new_flights =
  VALUE #(
    FOR ls_flight IN lt_flights INDEX INTO lv_index
                                WHERE ( carrid = 'AA' AND
                                        connid = '0017' )
    LET lv_carrname = lt_scarr[ carrid = ls_flight-carrid ]-carrname
    IN  carrier = lv_carrname
    ( seq_num = lv_index
      connect = ls_flight-connid
      fldate  = ls_flight-fldate
    )
  ).

cl_demo_output=>display( lt_new_flights ).

*"LOOP AT Method
*DATA: ls_new_flight TYPE ty_flight.
*LOOP AT lt_flights INTO DATA(ls_flight).
*  ls_new_flight-seq_num = sy-tabix.
*  ls_new_flight-carrier = lt_scarr[ carrid = ls_flight-carrid ]-carrname.
*  ls_new_flight-connect = ls_flight-connid.
*  ls_new_flight-fldate  = ls_flight-fldate.
*  APPEND ls_new_flight TO lt_new_flights.
*ENDLOOP.
*
*cl_demo_output=>display( lt_new_flights ).
*"Nested FOR Iterations
*lt_new_flights =
*  VALUE #(
*    FOR ls_scarr in lt_scarr
*    FOR ls_flight IN lt_flights WHERE ( carrid = ls_scarr-carrid )
*    (
*      carrier = ls_scarr-carrname
*      connect = ls_flight-connid
*      fldate  = ls_flight-fldate
*    )
*  ).
