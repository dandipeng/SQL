-- IF()
IF <test> THEN <return something>
ELSEIF <return something else>
ELSE <return something> END

-- IFF()

IIF(test, then, else)
-- 'unknown' refers to the NULL case, for example IFF(A, B, C, D), then return D if value is 'NULL'
IIF(test, then, else, unknown)

-- CASE()

CASE [Profit]
WHEN > 0 then 'Profitable'
WHEN = 0 then 'EVEN'
ELSE 'Unprofitable'
END

-- WINDOW_MAX()


-- DATENAME()
TODAY()
