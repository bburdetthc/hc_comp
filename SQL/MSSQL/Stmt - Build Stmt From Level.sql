--SET STATISTICS PROFILE OFF
SELECT
	LINE_D [STATEMENT],
	--dbo.STRING_PADLEFT(COALESCE(FORMAT(X1/1000000,'#,##0.0'),''),15,' ') AS [2015],
	X1/1000000 AS [15Q1],
	--dbo.STRING_PADLEFT(COALESCE(FORMAT(X2/1000000,'#,##0.0'),''),15,' ') AS [2016],
	X2/1000000 AS [15Q2],
	--dbo.STRING_PADLEFT(COALESCE(FORMAT(X3/1000000,'#,##0.0'),''),15,' ') AS [2017]
	X3/1000000 AS [15Q3],
	--dbo.STRING_PADLEFT(COALESCE(FORMAT(X3/1000000,'#,##0.0'),''),15,' ') AS [2017]
	X4/1000000 AS [15Q4]
FROM
	(
		SELECT 'X1' X, STMT, LINE, STAT, LINE_D, PVALUE FROM STMT.STMT_PERDRANGE_P('1503','1504','CGSOESS','19')
		UNION ALL
		SELECT 'X2' X, STMT, LINE, STAT, LINE_D, PVALUE FROM STMT.STMT_PERDRANGE_P('1505','1507','CGSOESS','19')
		UNION ALL
		SELECT 'X3' X, STMT, LINE, STAT, LINE_D, PVALUE FROM STMT.STMT_PERDRANGE_P('1508','1510','CGSOESS','19')
		UNION ALL
		SELECT 'X4' X, STMT, LINE, STAT, LINE_D, PVALUE FROM STMT.STMT_PERDRANGE_P('1511','1513','CGSOESS','19')
	) S
PIVOT
	(
		SUM(PVALUE)
		FOR X IN
			([X1],[X2],[X3],[X4])
	) AS PVT
ORDER BY
	LINE
OPTION (MAXDOP 8)