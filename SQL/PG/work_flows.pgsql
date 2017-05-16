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
	ROUND(SUM(AMT) FILTER (WHERE SUBSTR(ACCT,7,1) > '4'),2) AMT
FROM
	r.ffsbglr1
WHERE
	PERD = '1703' AND
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
	JSONB_BUILD_OBJECT('prime',PRIME,'accts',JSONB_AGG(ACCT)) JDEF,
	PRIME,
	PARTY,
	ROUND(SUM(AMT),2) AMT
FROM
	AL
GROUP BY
	BATCH,
	MODULE,
	PRIME,
	PARTY
)
--SELECT batch, module, jsonb_pretty(jdef), prime, party, amt  FROM AA LIMIT 100
,
--AGGREGATE TO PARTIES IN BATCHES--
AP AS (
SELECT
	BATCH,
	MODULE,
	JSONB_AGG(PRIME) PRIME,
	JSONB_BUILD_OBJECT('party',party,'jdef',JSONB_AGG(JDEF),'amt',SUM(AMT)) JDEF,
	PARTY,
	SUM(AMT) AMT
FROM
	AA
GROUP BY
	BATCH,
	MODULE,
	PARTY
)
--SELECT BATCH, MODULE, JSONB_PRETTY(PRIME), JSONB_PRETTY(JDEF), PARTY, AMT FROM AP LIMIT 100
,
--AGGREGATE TO PRIME GROUPS
PG AS (
SELECT
	PRIME,
	JSONB_AGG(JDEF) JDEF,
	SUM(AMT) AMT
FROM
	AP
GROUP BY
	PRIME
)
SELECT JSONB_PRETTY(PRIME) PRIMEGROUP, JSONB_PRETTY(JDEF) JSONB_DEF, AMT FROM PG LIMIT 100;