CREATE OR REPLACE VIEW v_persons_female AS
SELECT *
FROM person
WHERE gender = 'female';


CREATE OR REPLACE VIEW v_persons_male AS
SELECT *
FROM person
WHERE gender = 'male';


SELECT * FROM v_persons_female ORDER BY id;


SELECT * FROM v_persons_male ORDER BY id;