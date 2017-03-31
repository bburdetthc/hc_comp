/*
Drop table
Create tables
Initial populate
*Copy* open orders to separate version "baseline_open"
*Move* orders booked before target period to a separate version "baseline_excluded"
*Copy* orders to plug the remainder of the current year by adding one year to dates "baseline_plug"
Update budget dates to be + 1 year
----------------
Start Adding revions
(budget dates will not be subject to revision history)
*/

/*--------------------------
	clear old if necessary
--------------------------*/

DROP TABLE QGPL.FFOTEST;

/*---------------------
	create table
---------------------*/

CREATE TABLE QGPL.FFOTEST
(
	------order info--------------
	PLNT VARCHAR(3),
	"ORDER" NUMERIC(6,0),
	ORDERITEM NUMERIC (3,0),
	BOL NUMERIC (6,0),
	BOLITEM NUMERIC(3,0),
	INVOICE NUMERIC(6,0),
	INVOICEITEM NUMERIC (3,0),
	PROMO VARCHAR(255),
	RETURNREAS VARCHAR(255),
	TERMS VARCHAR(10),
	CUSTPO VARCHAR(255),
	------dates-------------------
	ORDERDATE DATE,
	REQUESTDATE DATE,
	PROMISEDATE DATE,
	SHIPDATE DATE,
	SALESMONTH VARCHAR(4),
	------customer data-----------
	BILLREMITO INT,
	BILLCUSTCLASS VARCHAR(255),
	BILLCUST VARCHAR(255),
	BILLREP VARCHAR(255),
	BILLDSM VARCHAR(255),
	BILLDIRECTOR VARCHAR(255),
	SHIPCUSTCLASS VARCHAR(255),
	SHIPCUST VARCHAR(255),
	SHIPDSM VARCHAR(255),
	SHIPDIRECTOR VARCHAR(255),
	SPECIAL_SAUCE_REP VARCHAR(255),
	------scenario----------------
	ACCOUNT VARCHAR(255),
	GEO VARCHAR(255),
	CHAN VARCHAR(255),
	------locations---------------
	ORIG_CTRY VARCHAR(3),
	ORIG_PROV VARCHAR(3),
	ORIG_LANE VARCHAR(3),
	ORIG_POST VARCHAR(255),
	DEST_CTRY VARCHAR(3),
	DEST_PROV VARCHAR(3),
	DEST_LANE VARCHAR(3),
	DEST_POST VARCHAR(255),
	------item info---------------
	PART VARCHAR(255),
	GL_CODE VARCHAR(255),
	MAJG VARCHAR(255),
	MING VARCHAR(255),
	MAJS VARCHAR(255),
	MINS VARCHAR(255),
	GLDC VARCHAR(255),
	GLEC VARCHAR(255),
	HARM VARCHAR(255),
	CLSS VARCHAR(255),
	BRAND VARCHAR(255),
	ASSC VARCHAR(255),
	------values------------------
	STATEMENT_LINE VARCHAR(255),
	R_CURRENCY VARCHAR(10),
	R_RATE NUMERIC (10,5)
	C_CURRENCY VARCHAR(10),
	C_RATE NUMERIC (10,5),
	QTY NUMERIC (20,5),
	VALUE_LOCAL NUMERIC(20,5),
	PRICE NUMERIC (10,5),
	STATUS VARCHAR(255),
	------version control---------
	B_ORDERDATE DATE,
	B_REQUESTDATE DATE,
	B_SHIPDATE DATE,
	VERSION VARCHAR(255)
);

/*---------------------
	base data insert
---------------------*/
INSERT INTO
	QGPL.FFOTEST
SELECT
	--order data
	PLNT,
	DDORD# 
	DDITM#,
	FGBOL#,
	FGENT#,
	DIINV#,
	DILIN#,
	PROMO,
	RETURN_REAS,
	TERMS,
	DCPO CUSTPO,
<<<<<<< HEAD
	--date-------------------------------
	DCODAT,
	DDQDAT,
	DCMDAT,
	DHIDAT,
	FSPR_INV,
	
	--customer data (bill-to)------------
	BC.BVCOMP,
	BC.BVCUST||' - '||RTRIM(BC.BVNAME) , 
	BC.BVSALM,
	BR.REPP,
	BR.DIRECTOR,
	SC.BVCLAS , 
	SC.BVCUST||' - '||RTRIM(SC.BVNAME),
	SR.REPP,
	SR.DIRECTOR,

	--scenario (offline data)------------
	COALESCE(CG.CGRP,BC.BVNAME) ACCOUNT,
	COALESCE(T.GEO,'UNDEFINED') GEO, 
	COALESCE(C.CHAN,'UNDEFINED') CHAN,
	
	--location---------------------------
=======
	DCODAT ORDERDATE,
	DDQDAT REQUESTDATE,
	DCMDAT PROMISEDATE,
	DHIDAT INVOICEDATE,
	FSPR_INV SALESMONTH,
	--customer data (bill-to)
	BC.BVCOMP BILLREMITTO,
	BC.BVCLAS BILLCUSTCLASS, 
	BC.BVCUST||' - '||RTRIM(BC.BVNAME) BILLCUST, 
	BC.BVSALM BILLREP,
	BR.REPP BILL_DSM,
	BR.DIRECTOR BILL_DIRECTOR,
	SC.BVCLAS SHIP_CUSTCLASS, 
	SC.BVCUST||' - '||RTRIM(SC.BVNAME) SHIPCUST,
	SR.REPP SHIP_DSM,
	SR.DIRECTOR SHIP_DIRECTOR,
	'Special Sauce Director', 			--LGPGM.CUS..?
	--scenario (offline data)
	COALESCE(CG.CGRP,BC.BVNAME) ACCOUNT,
	COALESCE(T.GEO,'UNDEFINED') GEO, 
	COALESCE(C.CHAN,'UNDEFINED') CHAN,
	--location
>>>>>>> main_dev
	QZCRYC ORIG_CTRY,
	QZPROV ORIG_PROV,
	SUBSTRING(QZPOST,1,3) ORIG_LANE,
	QZPOST ORIG_POST,
	SC.BVCTRY DEST_CTRY,
	SC.BVPRCD DEST_PROV,
	SUBSTRING(SC.BVPOST,1,3) DEST_LANE,
<<<<<<< HEAD
	SC.BVPOST DEST_POST,
	
	--item data-------------------------
=======
	hSC.BVPOST DEST_POST,
	--item data
>>>>>>> main_dev
	PART,
	GL_CODE,
	COALESCE(AVMAJG,AWMAJG)||' - '||RTRIM(BQDES) MAJG,  
	COALESCE(AVMING,AWMING)||' - '||RTRIM(BRDES) MING,  
	COALESCE(AVMAJS,AWMAJS)||' - '||RTRIM(MS.BSDES1) MAJS,  
	COALESCE(AVMINS,AWMINS)||' - '||RTRIM(NS.BSDES1) MINS,  
	COALESCE(AVGLCD,AWGLDC)||' - '||RTRIM(GD.A30) GLDC,  
	COALESCE(AVGLED,AWGLED)||' - '||RTRIM(GE.A30) GLEC, 
	COALESCE(AVHARM, AWHARM) HARM,  
	COALESCE(AVCLSS,AWCLSS) CLSS,  
	SUBSTR(AVCPT#,1,1) BRAND, 
	COALESCE(AVASSC,AWASSC) ASSC,
<<<<<<< HEAD
	--values-----------------------------
	CURRENCY,
	FB_QTY, 							--flag basis quantity
	FB_VAL_LOC,							--flag basis value
	O.FB_VAL_LOC*RATE FB_VAL_USD,		--flag basis flag basis value USD
	FLAG,								--flag
=======
	---------values---------
	AZGROP||' - '||RTRIM(BQ1TITL),									--LGDAT.MAST  LGDAT.FGRP LGDAT.ARMASC
	CURRENCY,
	XR.RATE,								--RLARP.FFCRET
	SUBSTR(A249,242,2),							--Company currency
	XC.RATE,								--RLARP.FFCRET	
	FB_QTY, 								--flag basis quantity
	FB_VAL_LOC,								--flag basis value
	CASE WHEN FB_QTY = 0 THEN 0 ELSE FB_VAL_LOC/FB_QTY END,
	--------Version control-------------------
>>>>>>> main_dev
	CALC_STATUS,
	DCODAT ORDERDATE,
	DDQDAT REQUESTDATE,
	DHIDAT INVOICEDATE,
	'BASELINE' VERSION					
FROM
	(

		SELECT
			------------------------status-------------------------------------------------------------------------
			F.FLAG, 
			CASE DDITST 
				WHEN 'C' THEN 
					CASE DDQTSI 
						WHEN 0 THEN 'CANCELED' 
						ELSE 'CLOSED' 
					END 
				ELSE 
					CASE F.FLAG
						WHEN 'SHIPMENT' THEN 'CLOSED' 
						ELSE CASE WHEN DDQTSI >0 THEN 'BACKORDER' ELSE 'OPEN' END 
					END 
			END CALC_STATUS, 
			-----------------------id's and flags------------------------------------------------------------------
			DDORD#, 
			DDITM#, 
			FGBOL#, 
			FGENT#, 
			DIINV#, 
			DILIN#, 
			DCODAT, 
			DDQDAT,
			DCMDAT,
			FESDAT, 
			FESIND, 
			DHIDAT, 
			DHPOST, 
			------------------------periods------------------------------------------------------------------------
			DIGITS(DHARYR)||DIGITS(DHARPR) FSPR_INV,
			------------------------attributes---------------------------------------------------------------------
			COALESCE(DHPLNT,FGPLNT,SUBSTR(DDSTKL,1,3)) PLNT,
			COALESCE(DCBCUS,DHBCS#) CUST_BILL,
			COALESCE(DCSCUS,DHSCS#) CUST_SHIP,
			COALESCE(DIGLCD, DDGLC) GL_CODE, 
			COALESCE(DIPART,DDPART) PART,
			RTRIM(DCPROM) PROMO,
			DCPO,
			DDCRRS RETURN_REAS,
			COALESCE(DHTRCD,DCTRCD) TERMS,
			CASE F.FLAG
				WHEN 'REMAINDER' THEN 
					DDQTOI-DDQTSI
				WHEN 'SHIPMENT' THEN
					FGQSHP*CASE FESIND WHEN 'Y' THEN 1 ELSE 0 END
			END FB_QTY,
			COALESCE(DHCURR,DCCURR) CURRENCY,
			CASE F.FLAG
				WHEN 'REMAINDER' THEN 
					--------remaining qty*calculated price per---------
					CASE DDQTOI 
						WHEN 0 THEN 0 
						ELSE DDTOTI/DDQTOI 
					END*(DDQTOI - DDQTSI)
				WHEN 'SHIPMENT' THEN
					---------BOL quantity * calculated price per-------
					CASE DDQTOI 
						WHEN 0 THEN 0 
						ELSE DDTOTI/DDQTOI 
					END*COALESCE(FGQSHP*CASE FESIND WHEN 'Y' THEN 1 ELSE 0 END,DDQTSI)
			END FB_VAL_LOC
		FROM
			----------------------Order Data-----------------------------
			LGDAT.OCRI 
			INNER JOIN LGDAT.OCRH ON 
				DCORD# = DDORD# 
			-----------------------BOL-----------------------------------
			LEFT OUTER JOIN LGDAT.BOLD ON 
				FGORD# = DDORD# AND 
				FGITEM = DDITM# 
			LEFT OUTER JOIN LGDAT.BOLH ON 
				FEBOL# = FGBOL#
			----------------------Invoicing------------------------------
			LEFT OUTER JOIN LGDAT.OID ON 
				DIINV# = FGINV# AND 
				DILIN# = FGLIN# 
			LEFT OUTER JOIN LGDAT.OIH ON 
				DHINV# = DIINV# 
			CROSS JOIN TABLE( VALUES
				('REMAINDER'),
				('SHIPMENT')
			) AS F(FLAG)
		WHERE
			(
				DCODAT >= '2016-03-01' OR
				DDQDAT >= '2016-06-01' OR
				CASE DDITST 
					WHEN 'C' THEN 
						CASE DDQTSI 
							WHEN 0 THEN 'CANCELED' 
							ELSE 'CLOSED' 
						END 
					ELSE 
						CASE F.FLAG
							WHEN 'SHIPMENT' THEN 'CLOSED' 
							ELSE CASE WHEN DDQTSI >0 THEN 'BACKORDER' ELSE 'OPEN' END 
						END 
				END IN ('OPEN','BACKORDER')
			) AND
			DAYS(DDQDAT) - DAYS(DCODAT) < 450 AND
			(	
			DAYS(DDQDAT) - DAYS(DCODAT) < 450 AND
			(	
				(F.FLAG = 'REMAINDER' AND DDQTOI-DDQTSI <> 0) OR 
				(F.FLAG = 'SHIPMENT' AND FGQSHP*CASE FESIND WHEN 'Y' THEN 1 ELSE 0 END<>0)
			)
	) O
	LEFT OUTER JOIN LGDAT.STKMM ON
		AVPART = PART
	LEFT OUTER JOIN LGDAT.STKMP ON
		AWPART = PART
	LEFT OUTER JOIN LGDAT.MAJG ON  
		BQGRP = AVMAJG  
	LEFT OUTER JOIN LGDAT.MMSL MS ON  
		MS.BSMJCD = COALESCE(AVMAJS, AWMAJS) AND  
		MS.BSMNCD = ''  
	LEFT OUTER JOIN LGDAT.MMSL NS ON  
		NS.BSMJCD = COALESCE(AVMAJS, AWMAJS) AND  
		NS.BSMNCD = COALESCE(AVMINS, AWMINS)
	LEFT OUTER JOIN LGDAT.MMGP ON  
		BRGRP = COALESCE(AVMAJG, AWMAJG) AND  
		BRMGRP = COALESCE(AVMING, AWMING)
	LEFT OUTER JOIN LGDAT.CODE GE ON  
		RTRIM(LTRIM(GE.A9)) =COALESCE(AVGLED, AWGLED) AND  
		GE.A2 = 'GE'  
	LEFT OUTER JOIN LGDAT.CODE GD ON  
		RTRIM(LTRIM(GD.A9)) = COALESCE(AVGLCD, AWGLDC) AND  
		GD.A2 = 'EE'  
	LEFT OUTER JOIN LGDAT.PLNT ON	
		YAPLNT = PLNT
	LEFT OUTER JOIN LGDAT.ADRS ON
		QZADR = YAADR#
	LEFT OUTER JOIN 
		(
			SELECT 
				N1COMP COMP, N1CCYY FSYR, KPMAXP PERDS, DIGITS(N1FSPP) PERD, 
				DIGITS(N1FSYP) FSPR,  
				N1SD01 SDAT, N1ED01 EDAT, 
				SUBSTR(CHAR(N1ED01),3,2)||SUBSTR(CHAR(N1ED01),6,2) CAPR,  
				N1ED01 - N1SD01 +1 NDAYS 
			  
			FROM 
				LGDAT.GLDATREF 
				INNER JOIN LGDAT.GLDATE ON 
					KPCOMP = N1COMP AND 
					KPCCYY = N1CCYY
		) GP ON
		GP.COMP = YACOMP AND
		GP.FSPR = FSPR_INV
	LEFT OUTER JOIN 
		(
			SELECT 
				N1COMP COMP, N1CCYY FSYR, KPMAXP PERDS, DIGITS(N1FSPP) PERD, 
				DIGITS(N1FSYP) FSPR,  
				N1SD01 SDAT, N1ED01 EDAT, 
				SUBSTR(CHAR(N1ED01),3,2)||SUBSTR(CHAR(N1ED01),6,2) CAPR,  
				N1ED01 - N1SD01 +1 NDAYS 
			  
			FROM 
				LGDAT.GLDATREF 
				INNER JOIN LGDAT.GLDATE ON 
					KPCOMP = N1COMP AND 
					KPCCYY = N1CCYY
		) GF ON
		GF.COMP = YACOMP AND
		GF.SDAT <= DCODAT AND
		GF.EDAT >= DCODAT
	LEFT OUTER JOIN RLARP.FFCRET XR ON
		XR.PERD = COALESCE(FSPR_INV, GF.FSPR) AND
		XR.FCUR = CURRENCY AND	
		XR.TCUR = 'US' AND
		XR.RTYP = 'MA'
	LEFT OUTER JOIN RLARP.FFCRET XC ON
		XC.PERD = COALESCE(FSPR_INV, GF.FSPR) AND
		XC.FCUR = SUBSTR(A249,242,2),
		XC.TCUR = 'US' AND
		XC.RTYP = 'MA'
	LEFT OUTER JOIN LGDAT.CUST BC ON
		BC.BVCUST = CUST_BILL
	LEFT OUTER JOIN LGDAT.CUST SC ON
		SC.BVCUST = CUST_SHIP
	LEFT OUTER JOIN 
		(
			SELECT
				MN.GRP ||' - ' ||DESCR DIRECTOR,
				LTRIM(RTRIM(A9)) RCODE,
				LTRIM(RTRIM(A9)) ||' - ' ||A30 REPP
			FROM
				LGDAT.CODE
				INNER JOIN 
				(
					SELECT
						MI.GRP, 
						MI.CODE,
						A30 DESCR
					FROM
						(
							SELECT 
								SUBSTR(LTRIM(RTRIM(A9)),1,3) GRP,
								MIN(A9) CODE
							FROM
								LGDAT.CODE
							WHERE
								A2 = 'MM'
							GROUP BY
								SUBSTR(LTRIM(RTRIM(A9)),1,3)
						)MI
						INNER JOIN LGDAT.CODE ON
							A2 = 'MM' AND
							A9 = CODE
				) MN ON
					GRP = SUBSTR(LTRIM(RTRIM(A9)),1,3)
			WHERE
				A2 = 'MM'
		) SR ON
		SR.RCODE = SC.BVSALM
	LEFT OUTER JOIN 
		(
			SELECT
				MN.GRP ||' - ' ||DESCR DIRECTOR,
				LTRIM(RTRIM(A9)) RCODE,
				LTRIM(RTRIM(A9)) ||' - ' ||A30 REPP
			FROM
				LGDAT.CODE
				INNER JOIN 
				(
					SELECT
						MI.GRP, 
						MI.CODE,
						A30 DESCR
					FROM
						(
							SELECT 
								SUBSTR(LTRIM(RTRIM(A9)),1,3) GRP,
								MIN(A9) CODE
							FROM
								LGDAT.CODE
							WHERE
								A2 = 'MM'
							GROUP BY
								SUBSTR(LTRIM(RTRIM(A9)),1,3)
						)MI
						INNER JOIN LGDAT.CODE ON
							A2 = 'MM' AND
							A9 = CODE
				) MN ON
					GRP = SUBSTR(LTRIM(RTRIM(A9)),1,3)
			WHERE
				A2 = 'MM'
		) BR ON
		BR.RCODE = BC.BVSALM
	LEFT OUTER JOIN RLARP.FFCHNL C ON
		BILL = BC.BVCLAS AND
		SHIP = SC.BVCLAS
	LEFT OUTER JOIN RLARP.FFTERR T ON
		PROV = SC.BVPRCD AND
		CTRY = SC.BVCTRY
	LEFT OUTER JOIN RLARP.FFCUST CG ON
		CUSTN = BC.BVCUST
	LETT OUTER JOIN LGDAT.NAME ON
		A7 = 'C0000'||YACOMP
	LEFT OUTER JOIN LGDAT.ARMASC ON
		ZWCOMP = YACOMP AND
		ZWKEY1 = BC.BVARCD AND
		ZWKEY2 = GLDC AND
		ZWPLNT = PLNT
	LEFT OUTER JOIN LGDAT.MAST ON
		AZCOMP||DIGITS(AZGL#1)||DIGITS(AZGL#2) = ZWSAL#
	LEFT OUTER JOIN LGDAT.FGRP ON
		BQ1GRP = AZGROP
WHERE	
	CALC_STATUS <> 'CANCELED';
	
/*---------------------------------------------------------------------------
	move all open orders to a version called 'open'
---------------------------------------------------------------------------*/

INSERT INTO 
	QGPL.FFOTEST
SELECT
	PLNT,
	ORDER,
	ORDERITEM,
	BOL,
	BOLITEM,
	INVOICE,
	INVOICEITEM,
	CUSTPO,
	RETURNREAS,
	TERMS,
	CURRENCY,
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
	FB_QTY,
	FB_VAL_LOC,
	FB_VAL_USD,
	FLAG,
	CALC_STATUS,
	B_ORDERDATE,
	B_REQUESTDATE,
	B_SHIPDATE,
	'BASELINE_OPEN' VERSION
FROM
	QGPL.FFOTEST
WHERE	
	CALC_STATUS IN ('OPEN','BACKORDER');
	
/*---------------------------------------------------------------------------
	flag anything prior to the target order date as simply a reporting plug
---------------------------------------------------------------------------*/

UPDATE QGPL.FFOTEST SET VERSION = 'BASELINE_EXCLUDED' WHERE ORDERDATE < '2016-04-01';

/*---------------------------------------------------------------------------
	Add forecast for remainder of current year to get to budget year
---------------------------------------------------------------------------*/
INSERT INTO	
	QGPL.FFOTEST
SELECT 
	PLNT,
	ORDER,
	ORDERITEM,
	BOL,
	BOLITEM,
	INVOICE,
	INVOICEITEM,
	CUSTPO,
	RETURNREAS,
	TERMS,
	CURRENCY,
	CUSTPO,
	ORDERDATE + 1 YEAR,
	REQUESTDATE + 1 YEAR,
	PROMISEDATE + 1 YEAR,
	SHIPDATE + 1 YEAR,
	CAST(SALESMONTH + 100 AS VARCHAR(4)),
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
	FB_QTY,
	FB_VAL_LOC,
	FB_VAL_USD,
	FLAG,
	CALC_STATUS,
	B_ORDERDATE +1 YEAR,
	B_REQUESTDATE + 1 YEAR,
	B_SHIPDATE + 1 YEAR,
	'BASELINE_PLUG' VERSION
FROM 
	QGPL.FFOTEST 
WHERE 
	VERSION = 'BASELINE' AND
	ORDERDATE >= '2016-04-01' AND 
	ORDERDATE < '2016-06-01';
	
	
/*---------------------------------------------------------------------------
	check versions by order month
---------------------------------------------------------------------------*/

SELECT
	VERSION,
	SUBSTR(CHAR(ORDERDATE),3,2)||SUBSTR(CHAR(ORDERDATE),6,2)
FROM
	QGPL.FFOTEST
GROUP BY
	VERSION,
	SUBSTR(CHAR(ORDERDATE),3,2)||SUBSTR(CHAR(ORDERDATE),6,2)
ORDER BY
	SUBSTR(CHAR(ORDERDATE),3,2)||SUBSTR(CHAR(ORDERDATE),6,2) ASC;
	
	
/*---------------------------------------------------------------------------
	increment all dates by one year
---------------------------------------------------------------------------*/

UPDATE	
	QGPL.FFOTEST
SET
	/*
	ORDERDATE = ORDERDATE + 1 YEAR,
	REQUESTDATE = REQUESTDATE + 1 YEAR,
	PROMISEDATE = PROMISEDATE + 1 YEAR,
	SHIPDATE = SHIPDATE + 1 YEAR,
	SALESMONTH = CAST(SALESMONTH + 100 AS VARCHAR(4)),
	*/
	B_ORDERDATE = B_ORDERDATE + 1 YEAR,
	B_REQUESTDATE = B_REQUESTDATE + 1 YEAR,
	B_SHIPDATE = B_SHIPDATE + 1 YEAR
WHERE
	VERSION IN ('BASELINE','BASELINE_PLUG');
	
/*---------------------------------------------------------------------------
	set B_SHIPDATE to request date or current date for open orders
---------------------------------------------------------------------------*/

UPDATE
	QGPL.FFOTEST
SET
	B_SHIPDATE = MAX(B_REQUESTDATE,CURRENT_DATE)
<<<<<<< HEAD
=======
WHERE
	VERSION = 'BASELINE_OPEN'
>>>>>>> main_dev
