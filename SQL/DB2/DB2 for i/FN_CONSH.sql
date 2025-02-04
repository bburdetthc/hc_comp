CREATE FUNCTION RLARP.FN_CONSH(TCOM VARCHAR(2))

RETURNS TABLE (COMP VARCHAR(100), DESCR VARCHAR(100), CURR VARCHAR(2), CONS VARCHAR(100))

--should add a parameter that is the target company or consolidation level such that a list of child companies are returned

RETURN 
WITH RECURSIVE CH
(PRNT, CHLD, LVL, IDX)

AS
(
	SELECT 
		0, DW6COMN AS VARCHAR(100)), 0, CAST('00' AS VARCHAR(100))
	FROM 
		LGDAT.GLCA
	WHERE
		DW6COMN = TCOM

	UNION ALL
	
	SELECT	
		CHLD, CAST(DW6SCOM AS VARCHAR(100)), LVL+1, IDX||'.'||CAST(DW6SCOM AS VARCHAR(100))
	FROM	
		LGDAT.GLCA
		INNER JOIN CH ON
			DW6COMN = CHLD
	WHERE
		LVL < 10
)

SELECT
	REPEAT('. ',LVL)||CHLD, DESCR, CURR, CONS
FROM
	CH 
	LEFT OUTER JOIN RLARP.VW_FFCOPR ON
		COMP = CHLD
ORDER BY 
	IDX