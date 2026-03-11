DROP MATERIALIZED VIEW IF EXISTS mv_dmitriy_visits_and_eats;

CREATE MATERIALIZED VIEW mv_dmitriy_visits_and_eats AS
SELECT p.name AS pizzeria_name
FROM menu 
INNER JOIN pizzeria p ON p.id = menu.pizzeria_id
INNER JOIN person_visits pv ON menu.pizzeria_id = pv.pizzeria_id
INNER JOIN person p2 ON p2.id = pv.person_id
WHERE price < 800 
  AND p2.name = 'Dmitriy' 
  AND visit_date = '2022-01-08'; 

SELECT * FROM mv_dmitriy_visits_and_eats;