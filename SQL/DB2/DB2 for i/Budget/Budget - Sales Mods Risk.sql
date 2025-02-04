


-------------------LOBLAWS RISK-----------------------------------------------------
DELETE FROM QGPL.FFBS0516 WHERE VERSION = 'Loblaw''s Risk';
INSERT INTO 
	QGPL.FFBS0516
SELECT 
    PLNT,
    ORDER,
    ORDERITEM,
    BOL,
    BOLITEM,
    INVOICE,
    INVOICEITEM,
    PROMO,
    RETURNREAS,
    TERMS,
    CUSTPO,
    ORDERDATE,
    REQUESTDATE,
    PROMISEDATE,
    SHIPDATE,
    SALESMONTH,
    BILLREMITO,
    BILLCUSTCLASS,
    BILLCUST,
    BILLREP,
    BILLDSM,
    BILLDIRECTOR,
    SHIPCUSTCLASS,
    SHIPCUST,
    SHIPDSM,
    SHIPDIRECTOR,
    SPECIAL_SAUCE_REP,
    ACCOUNT,
    GEO,
    CHAN,
    ORIG_CTRY,
    ORIG_PROV,
    ORIG_LANE,
    ORIG_POST,
    DEST_CTRY,
    DEST_PROV,
    DEST_LANE,
    DEST_POST,
    PART,
    GL_CODE,
    MAJG,
    MING,
    MAJS,
    MINS,
    GLDC,
    GLEC,
    HARM,
    CLSS,
    BRAND,
    ASSC,
    STATEMENT_LINE,
    R_CURRENCY,
    R_RATE,
    C_CURRENCY,
    C_RATE,
    -QTY QTY,
    -VALUE_LOCAL VALUE_LOCAL,
    0 PRICE,
    STATUS,
    FLAG,
    B_ORDERDATE,
    B_REQUESTDATE,
    B_SHIPDATE,
    I_ORDERDATE,
    I_REQUESTDATE,
    I_SHIPDATE,
    'Loblaw''s Risk'
FROM 
	QGPL.FFBS0516 
    INNER JOIN QGPL.FFVERS ON
        VERS = VERSION
WHERE 
    SEQ = 1 AND
	PROMO LIKE 'LOBLAWS 2017%' AND 
    GLEC = '1GR - GREENHOUSE PRODUCT' AND
    B_ORDERDATE + I_ORDERDATE DAYS >= '2017-05-01';

-------------------DISTRIBUTION VOLUME-----------------------------------------------------
DELETE FROM QGPL.FFBS0516 WHERE VERSION = 'Distribution Volume Risk';
INSERT INTO 
	QGPL.FFBS0516
SELECT 
    PLNT,
    ORDER,
    ORDERITEM,
    BOL,
    BOLITEM,
    INVOICE,
    INVOICEITEM,
    PROMO,
    RETURNREAS,
    TERMS,
    CUSTPO,
    ORDERDATE,
    REQUESTDATE,
    PROMISEDATE,
    SHIPDATE,
    SALESMONTH,
    BILLREMITO,
    BILLCUSTCLASS,
    BILLCUST,
    BILLREP,
    BILLDSM,
    BILLDIRECTOR,
    SHIPCUSTCLASS,
    SHIPCUST,
    SHIPDSM,
    SHIPDIRECTOR,
    SPECIAL_SAUCE_REP,
    ACCOUNT,
    GEO,
    CHAN,
    ORIG_CTRY,
    ORIG_PROV,
    ORIG_LANE,
    ORIG_POST,
    DEST_CTRY,
    DEST_PROV,
    DEST_LANE,
    DEST_POST,
    PART,
    GL_CODE,
    MAJG,
    MING,
    MAJS,
    MINS,
    GLDC,
    GLEC,
    HARM,
    CLSS,
    BRAND,
    ASSC,
    STATEMENT_LINE,
    R_CURRENCY,
    R_RATE,
    C_CURRENCY,
    C_RATE,
    -QTY*.05 QTY,
    -VALUE_LOCAL*.05 VALUE_LOCAL,
    PRICE,
    STATUS,
    FLAG,
    B_ORDERDATE,
    B_REQUESTDATE,
    B_SHIPDATE,
    I_ORDERDATE,
    I_REQUESTDATE,
    I_SHIPDATE,
    'Distribution Volume Risk'
FROM 
	QGPL.FFBS0516 
    INNER JOIN QGPL.FFVERS ON
        VERS = VERSION
WHERE 
    SEQ <= 4 AND
	BILLCUSTCLASS IN ('GDIS','NDIS') AND
    GLEC = '1GR - GREENHOUSE PRODUCT' AND
	B_ORDERDATE + I_ORDERDATE DAYS >= '2017-05-01';

-------------------DIRECT VOLUME-----------------------------------------------------
DELETE FROM QGPL.FFBS0516 WHERE VERSION = 'Direct Volume Risk';
INSERT INTO 
	QGPL.FFBS0516
SELECT 
    PLNT,
    ORDER,
    ORDERITEM,
    BOL,
    BOLITEM,
    INVOICE,
    INVOICEITEM,
    PROMO,
    RETURNREAS,
    TERMS,
    CUSTPO,
    ORDERDATE,
    REQUESTDATE,
    PROMISEDATE,
    SHIPDATE,
    SALESMONTH,
    BILLREMITO,
    BILLCUSTCLASS,
    BILLCUST,
    BILLREP,
    BILLDSM,
    BILLDIRECTOR,
    SHIPCUSTCLASS,
    SHIPCUST,
    SHIPDSM,
    SHIPDIRECTOR,
    SPECIAL_SAUCE_REP,
    ACCOUNT,
    GEO,
    CHAN,
    ORIG_CTRY,
    ORIG_PROV,
    ORIG_LANE,
    ORIG_POST,
    DEST_CTRY,
    DEST_PROV,
    DEST_LANE,
    DEST_POST,
    PART,
    GL_CODE,
    MAJG,
    MING,
    MAJS,
    MINS,
    GLDC,
    GLEC,
    HARM,
    CLSS,
    BRAND,
    ASSC,
    STATEMENT_LINE,
    R_CURRENCY,
    R_RATE,
    C_CURRENCY,
    C_RATE,
    -QTY*.1 QTY,
    -VALUE_LOCAL*.1 VALUE_LOCAL,
    PRICE,
    STATUS,
    FLAG,
    B_ORDERDATE,
    B_REQUESTDATE,
    B_SHIPDATE,
    I_ORDERDATE,
    I_REQUESTDATE,
    I_SHIPDATE,
    'Direct Volume Risk'
FROM 
	QGPL.FFBS0516 
    INNER JOIN QGPL.FFVERS ON
        VERS = VERSION
WHERE 
    SEQ <= 4 AND
	BILLCUSTCLASS IN ('GDIR','GDRP','NDIR') AND
    GLEC = '1GR - GREENHOUSE PRODUCT' AND
	B_ORDERDATE + I_ORDERDATE DAYS >= '2017-05-01';

