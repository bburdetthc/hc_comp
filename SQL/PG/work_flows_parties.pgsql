\timing
--DELETE FROM r.ffsbglr1;
--COPY r.ffsbglr1 FROM 'C:\users\ptrowbridge\downloads\ffsbglr1.csv' WITH (FORMAT CSV, HEADER TRUE, QUOTE '"');

WITH 
------GROUP BY ACCOUNT NUMBER-----------
AL AS (
SELECT
	BATCH,
	MODULE,
	SUBSTR(ACCT,7,4) PRIME,
	ACCT,
	REC->>'CUSVEND' party,
    ROUND(SUM(AMT),2) AMTA,
	ROUND(SUM(AMT) FILTER (WHERE AMT > 0),2) AMT
FROM
	r.ffsbglr1
WHERE
	MODULE = 'APVN'
GROUP BY
	BATCH,
	MODULE,
	SUBSTR(ACCT,7,4),
	ACCT,
	REC->>'CUSVEND'
),
--AGGREGATE ACCOUNTS INSIDE PRIMES--
AA AS (
SELECT
	BATCH,
	MODULE,
	tps.jsonb_concat_obj(JSONB_BUILD_OBJECT(ACCT,AMTA)) JDEF,
	PRIME,
	PARTY,
    ROUND(SUM(AMTA),2) AMTA,
	ROUND(SUM(AMT),2) AMT
FROM
	AL
GROUP BY
	BATCH,
	MODULE,
	PRIME,
	PARTY
)
--SELECT * FROM AA where batch =  '000430731' LIMIT 100
,
--create the prime group by batch, party, module--
PA AS (
SELECT
	BATCH,
	MODULE,
    ARRAY_AGG(PRIME ORDER BY PRIME ASC) PRIME_A
FROM
	AL
GROUP BY
	BATCH,
	MODULE,
	PARTY
)
,
--AGGREGATE TO PARTIES IN BATCHES--
AP AS (
SELECT
	BATCH,
	MODULE,
	tps.jsonb_concat_obj(JDEF) JDEF,
	PARTY,
	SUM(AMT) AMT
FROM
	AA
GROUP BY
	BATCH,
	MODULE,
	PARTY,
    PRIME_A
)
--SELECT * FROM AP WHERE BATCH = '000430731' LIMIT 100
,
--AGGREGATE TO PRIME GROUPS
PG AS (
SELECT
	PRIME_A,
    tps.jsonb_concat_obj(JSONB_BUILD_OBJECT(PARTY,AMT)) PARTIES,
	JSONB_AGG(JSONB_BUILD_OBJECT(PARTY,JDEF)) JDEF,
	SUM(AMT) AMT
FROM
	AP
GROUP BY
	PRIME
)
SELECT PRIME_A, JSONB_PRETTY(PARTIES) PARTIES, JSONB_PRETTY(JDEF) JSONB_DEF, AMT FROM PG ORDER BY PRIME ASC LIMIT 100