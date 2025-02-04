CREATE PROCEDURE RLARP.CH_UD()
BEGIN
	DECLARE V_ERROR INTEGER ; 
	DECLARE MSG_VAR VARCHAR ( 255 ) ; 
	DECLARE RETRN_STATUS INTEGER ; 
	 
	DECLARE EXIT HANDLER FOR SQLEXCEPTION  --,SQLWARNING 
	BEGIN 
		SET V_ERROR = SQLCODE ; 
		GET DIAGNOSTICS RETRN_STATUS = RETURN_STATUS ; 
	 
		IF ( V_ERROR IS NULL ) OR ( V_ERROR <> 0 AND V_ERROR <> 466 ) OR ( RETRN_STATUS > 3 ) 
		THEN 
			SET MSG_VAR = 'PROC: ' || 'RLARP.CH_UD' || ', ' || COALESCE ( MSG_VAR , '' ) || ', SQLCODE: ' || CHAR ( V_ERROR ) || ', PARAMS: ' ; 
			 --ROLLBACK; 
			 --COMMIT; 
			SET RETRN_STATUS = - 1 ; 
			SIGNAL SQLSTATE '75001' SET MESSAGE_TEXT = MSG_VAR ; 
		ELSE 
			SET V_ERROR = 0 ; 
		END IF ; 
	END ; 
	
	--setup temp table as work file
	
	DECLARE GLOBAL TEMPORARY TABLE ISS(PART CHAR(20), PLNT CHAR(3), DT CHAR(10), TM CHAR(8), RCID CHAR(20), NEWC FLOAT, QTY FLOAT, SEQ INT);

	--grab initial records from icstt that have posted after the max stamp on the target file
	
	INSERT INTO
		QTEMP.ISS
	SELECT
		JHPART, JHPLNT, CHAR(JHDATE), CHAR(JHTIME), JHRCID, JHTOTN, JHOHQT, 
		ROW_NUMBER() OVER (PARTITION BY JHPART, JHPLNT ORDER BY JHPART, JHPLNT, JHDATE, JHTIME, JHRCID) SEQ 
	FROM
		LGDAT.ICSTT
	WHERE
		 JHCTYP = 'S' AND
		 JHDATE >= (SELECT MAX(TDT) FROM RLARP.FFCOSTEFFD);
		 
	--for each new record, go and get the associated preceding record so as to ensure the "from" cost is being pulled
	--correctly as some icstt records are noted as having the wrong "from" cost, so it must be manually built

	INSERT INTO
		QTEMP.ISS
	SELECT
		JHPART, JHPLNT, CHAR(JHDATE), CHAR(JHTIME), JHRCID, JHTOTN, JHOHQT, 0 SEQ
	FROM
		 (
			 SELECT
				JHPART PART, JHPLNT PLNT, MAX(JHRCID) RCID
			 FROM
				(
					--this listing needs to pull the last record id in ICSTT before the first one in ISS per part/plant
					SELECT
						PART, PLNT, MIN(RCID) NID
					FROM
						QTEMP.ISS
					GROUP BY
						PART, PLNT
				) X
				INNER JOIN LGDAT.ICSTT ON
					JHPART = PART AND
					JHPLNT = PLNT AND
					JHCTYP = 'S' AND
					JHRCID < NID
				GROUP BY
					JHPART, JHPLNT
		 ) LAST
	INNER JOIN LGDAT.ICSTT ON
		JHPART = PART AND
		JHPLNT = PLNT AND
		JHRCID = RCID;
		
	--insert

	MERGE INTO 
		RLARP.FFCOSTEFFD F
	USING
		( 
			SELECT
				T.PART, T.PLNT, 
				IFNULL(F.DT,'0001-01-01') FDT, 
				IFNULL(F.TM,'00:00:00') FTM, 
				IFNULL(F.RCID,'00000000000') FRI , 
				T.DT TDT, T.TM TTM, T.RCID TRI, IFNULL(F.NEWC,0) FCOST, T.NEWC TCOST, T.QTY TQTY, F.SEQ, T.SEQ
			FROM
				QTEMP.ISS T
				LEFT OUTER JOIN QTEMP.ISS F ON
					F.PART = T.PART AND
					F.PLNT = T.PLNT AND
					F.SEQ = T.SEQ-1
			WHERE 
				T.SEQ >= 1
		) A ON
			A.PART = F.PART AND
			A.PLNT = F.PLNT AND
			A.FRI = F.FRI AND
			A.TRI = F.TRI
	WHEN NOT MATCHED THEN
		INSERT (F.PART, F.PLNT, F.FDT, F.FTM, F.FRI, F.TDT, F.TTM, F.TRI, F.FCOST, F.TCOST, F.TQTY)
		VALUES (A.PART, A.PLNT, A.FDT, A.FTM, A.FRI, A.TDT, A.TTM, A.TRI, A.FCOST, A.TCOST, A.TQTY);
		
	--drop the work file

	DROP TABLE QTEMP.ISS;
END;
