SELECT
	--AUFK.AUFNR AS "Order"
    AUFK.AUART AS "Order Type"
    --,AFKO.GETRI AS "AF"
    ,SUBSTR(AFKO.GETRI,5,2) AS "Month"
    ,COUNT(AUFK.AUFNR) AS "Total Count"
    --,TO_CHAR(TO_DATE(07, 'MM'), 'Month') AS "Month"
    --,AFIH.PRIOK AS "Priority"
    --,AFIH.ILART AS "Activity Type"
    --,ILOA.EQFNR AS "Tag"
    --,ILOA.ABCKZ AS "ABC"
    --,AUFK.KTEXT AS "Order Description"
    /*
    ,(
        SELECT
			LISTAGG(TJ30T.TXT04, ' ') WITHIN GROUP (ORDER BY TJ30T.TXT04)
		FROM JEST
		JOIN JSTO ON JSTO.OBJNR = JEST.OBJNR
		JOIN TJ30T ON JSTO.STSMA = TJ30T.STSMA AND JEST.STAT = TJ30T.ESTAT
		WHERE JEST.OBJNR = AUFK.OBJNR AND JEST.INACT != 'X' AND TJ30T.SPRAS = 'E'
    ) AS "User Status"
    ,(
        SELECT
			LISTAGG(TJ02T.TXT04, ' ') WITHIN GROUP (ORDER BY TJ02T.TXT04)
		FROM JEST
		JOIN TJ02T ON JEST.STAT = TJ02T.ISTAT
		WHERE JEST.OBJNR = AUFK.OBJNR AND JEST.INACT != 'X' AND TJ02T.SPRAS = 'E'
    ) AS "System Status"
    */
    --,AUFK.OBJNR AS "Object"
    --,AUFK.AUART AS "Order Type"
    --,CASE AFKO.GLTRP WHEN '00000000' THEN NULL ELSE TO_CHAR(TO_DATE(AFKO.GLTRP, 'YYYYMMDD'), 'YYYY-MM-DD') END AS "Basic Finish Date"
    --,CRHD.ARBPL AS "Work Center"
    --,CASE AFKO.GETRI WHEN '00000000' THEN NULL ELSE TO_CHAR(TO_DATE(AFKO.GETRI, 'YYYYMMDD'), 'YYYY-MM-DD') END AS "Confirmed Finish Date"
    --,CASE AUFK.ZZ_COMPLSTART_DATE WHEN '00000000' THEN NULL ELSE TO_DATE(AUFK.ZZ_COMPLSTART_DATE , 'YYYYMMDD') END AS "Compliance Start"
    --,CASE AUFK.ZZ_COMPLEND_DATE WHEN '00000000' THEN NULL ELSE TO_DATE(AUFK.ZZ_COMPLEND_DATE, 'YYYYMMDD') END AS "Compliance End"
    --,FLOOR(SYSDATE - TO_DATE(AUFK.ERDAT, 'YYYYMMDD')) AS "Days Open"
    /*,(
        SELECT ROUND(AVG(AFVC.ANZZL),2) 
        FROM AFVC 
        JOIN AFVV ON AFVV.AUFPL = AFVC.AUFPL AND AFVV.APLZL = AFVC.APLZL 
        WHERE AFVC.AUFPL = AFKO.AUFPL
        ) AS "Avg Capacity"
    ,(
        SELECT SUM(AFVV.DAUNO) 
        FROM AFVC 
        JOIN AFVV ON AFVV.AUFPL = AFVC.AUFPL AND AFVV.APLZL = AFVC.APLZL 
        WHERE AFVC.AUFPL = AFKO.AUFPL
        ) AS "Total Est"
    ,(
        SELECT COUNT(DISTINCT AFRU.PERNR)
        FROM AFRU
        JOIN AFVC ON AFVC.RUECK = AFRU.RUECK
        WHERE AFRU.STOKZ != 'X'
        AND AFVC.AUFPL = AFKO.AUFPL
        
    ) AS "Actual Capacity"
    ,(
        SELECT SUM(AFRU.ISMNW)
        FROM AFRU
        JOIN AFVC ON AFVC.RUECK = AFRU.RUECK
        WHERE AFRU.STOKZ != 'X'
        AND AFVC.AUFPL = AFKO.AUFPL
        
    ) AS "Actual Work"
    */
FROM AUFK
JOIN AFIH ON AFIH.AUFNR = AUFK.AUFNR
JOIN AFKO ON AFKO.AUFNR = AFIH.AUFNR
JOIN CRHD ON CRHD.OBJID = AFIH.GEWRK
JOIN ILOA ON ILOA.ILOAN = AFIH.ILOAN

WHERE 
--AUFK.AUART NOT IN ('8O01')
AUFK.AUART IN ('8F01', '8F02')
AND (AFKO.GLTRP != '00000000' OR AFKO.GLTRP IS NOT NULL)
--AND TO_DATE(AFKO.GLTRP, 'YYYYMMDD') BETWEEN TO_DATE('20170907', 'YYYYMMDD') AND TO_DATE('20170907', 'YYYYMMDD')
AND AFKO.GETRI >= '20170101'
AND AUFK.LOEKZ != 'X'

AND ('DLFL') NOT IN
(
	SELECT TJ02T.TXT04
	FROM JEST
	JOIN TJ02T ON JEST.STAT = TJ02T.ISTAT
	WHERE JEST.OBJNR = AUFK.OBJNR
)

AND ('CNF') IN
(
	SELECT TJ02T.TXT04
	FROM JEST
	JOIN TJ02T ON JEST.STAT = TJ02T.ISTAT
	WHERE JEST.OBJNR = AUFK.OBJNR
)

GROUP BY AUFK.AUART, SUBSTR(AFKO.GETRI,5,2)
;