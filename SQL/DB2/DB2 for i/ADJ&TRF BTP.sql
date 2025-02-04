SELECT 
	'GL' SRCE,
	ACCT, 
	PERD,
	MODULE, 
	CUSMOD,
	BATCH,
	CUSKEY4 PART,
	SUM(AMT) AMTGL,
	0.0 AMTQOH
FROM 
	QGPL.FFSBGLR1
WHERE
	MODULE = 'ICIT' AND
	PERD = '1603' AND
	SUBSTR(ACCT,7,4) IN ('1200','1220')
GROUP BY	
	ACCT, 
	PERD,
	MODULE, 
	CUSMOD,
	BATCH,
	CUSKEY4

UNION ALL

SELECT 
	'GL' SRCE,
	ACCT, 
	PERD,
	MODULE, 
	CUSMOD,
	BATCH,
	CUSKEY1 PART,
	SUM(AMT) AMTGL,
	0.0 AMTQOH
FROM 
	QGPL.FFSBGLR1
WHERE
	MODULE = 'IC' AND
	PERD = '1603' AND
	SUBSTR(ACCT,7,4) IN ('1200','1220')
GROUP BY	
	ACCT, 
	PERD,
	MODULE, 
	CUSMOD,
	BATCH,
	CUSKEY1

UNION ALL

SELECT 
	'QOH' SRCE,
	YACOMP||Y1INVA AS ACCT,
	SUBSTR(DIGITS(BYFSYY),3,2)||DIGITS(BYFSPR) PERD,
	BYSRC MODULE,
	RTRIM(BYSRC)||UPPER(SUBSTRING(BYDREF,1,3)) CUSMOD,
	BYJREF BATCH,
	BYPART PART,
	0.0 AMTGL,
	sum(BYQTY*CASE BYACTN WHEN 'I' THEN -1 ELSE 1 END*COALESCE(FCOST, CGSTCS, CHSTCS, Y0STCS)) AS AMTQOH
FROM 
	LGDAT.STKT STKT
	LEFT OUTER JOIN LGDAT.ICSTP P ON
		CHPART = STKT.BYPART AND
		CHPLNT = STKT.BYPLNT
	LEFT OUTER JOIN LGDAT.ICSTM M ON
		CGPART = STKT.BYPART AND
		CGPLNT = STKT.BYPLNT
	LEFT OUTER JOIN LGDAT.ICSTR R ON
		Y0PART = STKT.BYPART AND
		Y0PLNT = STKT.BYPLNT
	LEFT OUTER JOIN LGDAT.STKMP MP ON
		MP.AWPART = BYPART
	LEFT OUTER JOIN LGDAT.STKMM MM ON
		MM.AVPART = BYPART
	LEFT OUTER JOIN LGDAT.GLIE A ON
		Y1GLEC = COALESCE(AVGLED, AWGLED) AND
		Y1PLNT = BYPLNT
	LEFT OUTER JOIN LGDAT.PLNT L ON
		YAPLNT = BYPLNT
	LEFT OUTER JOIN QGPL.FFCOSTEFFD ON
		PART = BYPART AND
		PLNT = BYPLNT AND
		CHAR(FDT)||CHAR(FTM) < CHAR(BYSDAT)||CHAR(BYSTIM) AND
		CHAR(TDT)||CHAR(TTM) > CHAR(BYSDAT)||CHAR(BYSTIM)
WHERE
	BYFSYY = 2016 AND 
	BYFSPR = 3 AND 
	BYACTN IN ('I','R') AND
	BYSRC = 'OE ' AND
	UPPER(SUBSTRING(BYDREF,1,3)) = 'TRF'
GROUP BY
	YACOMP||Y1INVA,
	SUBSTR(DIGITS(BYFSYY),3,2)||DIGITS(BYFSPR),
	BYSRC,
	RTRIM(BYSRC)||UPPER(SUBSTRING(BYDREF,1,3)),
	BYJREF,
	BYPART

UNION ALL

SELECT 
	'QOH' SRCE,
	YACOMP||Y1INVA AS ACCT,
	SUBSTR(DIGITS(BYFSYY),3,2)||DIGITS(BYFSPR) PERD,
	BYSRC MODULE,
	RTRIM(BYSRC)||BYREAS CUSMOD,
	BYJREF BATCH,
	BYPART PART,
	0.0 AMTGL,
	SUM(BYQTY*CASE BYACTN WHEN 'I' THEN -1 ELSE 1 END*COALESCE(FCOST, CGSTCS, CHSTCS, Y0STCS)) AS AMTQOH
FROM 
	LGDAT.STKT STKT
	LEFT OUTER JOIN LGDAT.ICSTP P ON
		CHPART = STKT.BYPART AND
		CHPLNT = STKT.BYPLNT
	LEFT OUTER JOIN LGDAT.ICSTM M ON
		CGPART = STKT.BYPART AND
		CGPLNT = STKT.BYPLNT
	LEFT OUTER JOIN LGDAT.ICSTR R ON
		Y0PART = STKT.BYPART AND
		Y0PLNT = STKT.BYPLNT
	LEFT OUTER JOIN LGDAT.STKMP MP ON
		MP.AWPART = BYPART
	LEFT OUTER JOIN LGDAT.STKMM MM ON
		MM.AVPART = BYPART
	LEFT OUTER JOIN LGDAT.GLIE A ON
		Y1GLEC = COALESCE(AVGLED, AWGLED) AND
		Y1PLNT = BYPLNT
	LEFT OUTER JOIN LGDAT.PLNT L ON
		YAPLNT = BYPLNT	
	LEFT OUTER JOIN QGPL.FFCOSTEFFD ON
		PART = BYPART AND
		PLNT = BYPLNT AND
		CHAR(FDT)||CHAR(FTM) < CHAR(BYSDAT)||CHAR(BYSTIM) AND
		CHAR(TDT)||CHAR(TTM) > CHAR(BYSDAT)||CHAR(BYSTIM)

WHERE
	BYFSYY = 2016 AND 
	BYFSPR = 3 AND 
	BYACTN IN ('I','R') AND
	BYSRC = 'INV'
GROUP BY
	YACOMP||Y1INVA,
	SUBSTR(DIGITS(BYFSYY),3,2)||DIGITS(BYFSPR),
	BYSRC,
	RTRIM(BYSRC)||BYREAS,
	BYJREF,
	BYPART

UNION ALL

SELECT 
	'QOH' SRCE,
	YACOMP||Y1INVA AS ACCT,
	SUBSTR(DIGITS(BYFSYY),3,2)||DIGITS(BYFSPR) PERD,
	BYSRC MODULE,
	RTRIM(BYSRC)||BYREAS CUSMOD,
	BYJREF BATCH,
	BYPART PART,
	0.0 AMTGL,
	SUM(BYQTY*CASE BYACTN WHEN 'I' THEN -1 ELSE 1 END*COALESCE(FCOST, CGSTCS, CHSTCS, Y0STCS)) AS AMTQOH
FROM 
	LGDAT.STKT STKT
	LEFT OUTER JOIN LGDAT.ICSTP P ON
		CHPART = STKT.BYPART AND
		CHPLNT = STKT.BYPLNT
	LEFT OUTER JOIN LGDAT.ICSTM M ON
		CGPART = STKT.BYPART AND
		CGPLNT = STKT.BYPLNT
	LEFT OUTER JOIN LGDAT.ICSTR R ON
		Y0PART = STKT.BYPART AND
		Y0PLNT = STKT.BYPLNT
	LEFT OUTER JOIN LGDAT.STKMP MP ON
		MP.AWPART = BYPART
	LEFT OUTER JOIN LGDAT.STKMM MM ON
		MM.AVPART = BYPART
	LEFT OUTER JOIN LGDAT.GLIE A ON
		Y1GLEC = COALESCE(AVGLED, AWGLED) AND
		Y1PLNT = BYPLNT
	LEFT OUTER JOIN LGDAT.PLNT L ON
		YAPLNT = BYPLNT
	LEFT OUTER JOIN QGPL.FFCOSTEFFD ON
		PART = BYPART AND
		PLNT = BYPLNT AND
		CHAR(FDT)||CHAR(FTM) < CHAR(BYSDAT)||CHAR(BYSTIM) AND
		CHAR(TDT)||CHAR(TTM) > CHAR(BYSDAT)||CHAR(BYSTIM)
WHERE
	BYFSYY = 2016 AND 
	BYFSPR = 3 AND 
	BYACTN IN ('I','R') AND
	BYSRC = 'PHY'
GROUP BY	
	YACOMP||Y1INVA,
	SUBSTR(DIGITS(BYFSYY),3,2)||DIGITS(BYFSPR),
	BYSRC,
	RTRIM(BYSRC)||BYREAS,
	BYJREF,
	BYPART