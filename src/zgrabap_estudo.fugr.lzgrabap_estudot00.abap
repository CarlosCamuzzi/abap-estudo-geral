*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZTESTUDO_FORNEC.................................*
DATA:  BEGIN OF STATUS_ZTESTUDO_FORNEC               .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZTESTUDO_FORNEC               .
CONTROLS: TCTRL_ZTESTUDO_FORNEC
            TYPE TABLEVIEW USING SCREEN '0003'.
*...processing: ZTESTUDO_PRODUTO................................*
DATA:  BEGIN OF STATUS_ZTESTUDO_PRODUTO              .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZTESTUDO_PRODUTO              .
CONTROLS: TCTRL_ZTESTUDO_PRODUTO
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZTESTUDO_FORNEC               .
TABLES: *ZTESTUDO_PRODUTO              .
TABLES: ZTESTUDO_FORNEC                .
TABLES: ZTESTUDO_PRODUTO               .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
