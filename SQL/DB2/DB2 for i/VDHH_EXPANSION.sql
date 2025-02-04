CREATE FUNCTION FVDHE()
RETURNS TABLE(
	ROOT_VW VARCHAR(255),
	LVL VARCHAR(255),
	CKEY VARCHAR(255),
	TABLE_TEXT VARCHAR(255),
	LAST_ALTERED_TIMESTAMP VARCHAR(255),
	CVW VARCHAR(255), 
	CLIB VARCHAR(255)	
) 
BEGIN 
RETURN
WITH RECURSIVE DH
( MVW, MLIB, PLIB , PVW , CLIB, CVW, CKEY, LVL) 
  
AS 
( 
	SELECT
		PLIB, PVW, '', '', PLIB, PVW, RTRIM(PLIB)||'.'||RTRIM(PVW), 0	
	FROM	
		(SELECT DISTINCT PLIB, PVW FROM RLARP.VVDH) X
  	
	UNION ALL 
	 
	SELECT	 
		DH.MVW, DH.MLIB, DH.CLIB, DH.CVW, VH.CLIB, VH.CVW, RTRIM(VH.CLIB)||'.'||RTRIM(VH.CVW) CKEY, DH.LVL + 1 LVL
	FROM	 
		RLARP.VVDH VH
		INNER JOIN DH ON 
			VH.PLIB = DH.CLIB AND
			VH.PVW = DH.CVW
	WHERE 
		LVL < 10 
) 
SEARCH DEPTH FIRST BY CKEY SET ORDCOL
  
SELECT 
	RTRIM(MLIB)||'.'||RTRIM(MVW) ROOT_VW, 
	REPEAT ( '. ' , LVL )||LVL LVL, REPEAT ( '. ' , LVL )||CKEY, TABLE_TEXT, LAST_ALTERED_TIMESTAMP, CVW, CLIB
FROM 
	DH
	LEFT OUTER JOIN RLARP.SYSTABLES T ON
		T.TABLE_NAME = CVW AND
		T.TABLE_SCHEMA = CLIB
ORDER BY ORDCOL
END;