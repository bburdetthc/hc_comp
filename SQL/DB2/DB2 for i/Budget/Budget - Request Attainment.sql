SELECT
	VERSION,
	CHAN,
	GEO,
	ACCOUNT,
	GLEC,
	SUBSTR(CHAR(ORDERDATE),3,2)||SUBSTR(CHAR(ORDERDATE),6,2) ORDMONTH,
	SUBSTR(CHAR(MAX(REQUESTDATE,ORDERDATE)),3,2)||SUBSTR(CHAR(MAX(REQUESTDATE,ORDERDATE)),6,2) REQMONTH,
	CASE CALC_STATUS 
		WHEN  'CLOSED' THEN SALESMONTH
		ELSE  'O'||SUBSTR(CHAR(MAX(REQUESTDATE,ORDERDATE,CURRENT_DATE)),3,2)||SUBSTR(CHAR(MAX(REQUESTDATE,ORDERDATE,CURRENT_DATE)),6,2)
	END SALESMONTH,
	SUM(FB_VAL_USD) AMOUNT
FROM
	QGPL.FFOTEST
WHERE
	SUBSTR(GLEC,1,1) IN ('1','2')
GROUP BY
	VERSION,
	CHAN,
	GEO,
	ACCOUNT,
	GLEC,
	SUBSTR(CHAR(ORDERDATE),3,2)||SUBSTR(CHAR(ORDERDATE),6,2),
	SUBSTR(CHAR(MAX(REQUESTDATE,ORDERDATE)),3,2)||SUBSTR(CHAR(MAX(REQUESTDATE,ORDERDATE)),6,2),
	CASE CALC_STATUS 
		WHEN  'CLOSED' THEN SALESMONTH
		ELSE  'O'||SUBSTR(CHAR(MAX(REQUESTDATE,ORDERDATE,CURRENT_DATE)),3,2)||SUBSTR(CHAR(MAX(REQUESTDATE,ORDERDATE,CURRENT_DATE)),6,2)
	END
ORDER BY
	VERSION,
	CHAN,
	GEO,
	ACCOUNT,
	GLEC,
	SUBSTR(CHAR(ORDERDATE),3,2)||SUBSTR(CHAR(ORDERDATE),6,2),
	SUBSTR(CHAR(MAX(REQUESTDATE,ORDERDATE)),3,2)||SUBSTR(CHAR(MAX(REQUESTDATE,ORDERDATE)),6,2),
	CASE CALC_STATUS 
		WHEN  'CLOSED' THEN SALESMONTH
		ELSE  'O'||SUBSTR(CHAR(MAX(REQUESTDATE,ORDERDATE,CURRENT_DATE)),3,2)||SUBSTR(CHAR(MAX(REQUESTDATE,ORDERDATE,CURRENT_DATE)),6,2)
	END