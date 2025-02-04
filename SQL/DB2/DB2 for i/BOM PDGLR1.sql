SELECT
	BOM.P_PART,
	BOM.C_PART_D,
	BOM.SB,
	BOM.AB,
	TQTY.CP
FROM

	(
		SELECT 
			RTRIM(X.PART) P_PART, 
			RTRIM(G.PART)||' - '||COALESCE(AVDES1, AWDES1) C_PARTD,
			COALESCE(AVMAJG,AWMAJG) MAJG,
			SUM(CASE ACTN
				WHEN 'SBG' THEN -G.PQTY
				WHEN 'SBS' THEN -G.PQTY
				ELSE 0
			END) SB,
			SUM(CASE ACTN
				WHEN 'BMT' THEN -G.PQTY
				ELSE 0
			END) AB
		FROM 
			(
			SELECT 
				PART, BTID, WRKO,
				ROW_NUMBER() OVER (PARTITION BY PART ORDER BY PART ASC, BTID DESC) RN
			FROM
				RLARP.FFPDGLR1
			WHERE
				SUBSTR(PART,1,8) IN ('PBP11000','PBH12000') AND
				ACTN = 'CPG'
			ORDER BY PART ASC, BTID desc
			) X 
			INNER JOIN RLARP.FFPDGLR1 G ON
				G.BTID = X.BTID AND
				G.WRKO = X.WRKO
			LEFT OUTER JOIN LGDAT.STKMM ON
				AVPART = G.PART
			LEFT OUTER JOIN LGDAT.STKMP ON
				AWPART = G.PART
		WHERE
			X.RN <= 20 AND
			ACTN IN ('CPG','CPS','SBG','SBS','BMT') AND
			X.PART <> G.PART
		GROUP BY
			X.PART,
			G.PART,
			RTRIM(G.PART) ||' - '||COALESCE(AVDES1, AWDES1),
			COALESCE(AVMAJG,AWMAJG)
		ORDER BY
			X.PART
	) BOM
	INNER JOIN
	(
		SELECT 
			RTRIM(X.PART) P_PART, 
			RTRIM(G.PART)||' - '||COALESCE(AVDES1, AWDES1) C_PARTD,
			COALESCE(AVMAJG,AWMAJG) MAJG,
			SUM(CASE ACTN
				WHEN 'CPG' THEN G.PQTY
				WHEN 'CPS' THEN G.PQTY
				ELSE 0
			END) CP
		FROM 
			(
				SELECT 
					PART, BTID, WRKO,
					ROW_NUMBER() OVER (PARTITION BY PART ORDER BY PART ASC, BTID DESC) RN
				FROM
					RLARP.FFPDGLR1
				WHERE
					SUBSTR(PART,1,8) IN ('PBP11000','PBH12000') AND
					ACTN = 'CPG'
				ORDER BY PART ASC, BTID desc
			) X 
			INNER JOIN RLARP.FFPDGLR1 G ON
				G.BTID = X.BTID AND
				G.WRKO = X.WRKO
			LEFT OUTER JOIN LGDAT.STKMM ON
				AVPART = G.PART
			LEFT OUTER JOIN LGDAT.STKMP ON
				AWPART = G.PART
		WHERE
			X.RN <= 20 AND
			ACTN IN ('CPG','CPS','SBG','SBS','BMT') AND
			X.PART = G.PART
		GROUP BY
			X.PART,
			G.PART,
			RTRIM(G.PART) ||' - '||COALESCE(AVDES1, AWDES1),
			COALESCE(AVMAJG,AWMAJG)
		ORDER BY
			X.PART
	) TQTY ON
		BOM.P_PART = TQTY.P_PART
	