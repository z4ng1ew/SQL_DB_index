
INSERT INTO person_visits (id, person_id, pizzeria_id, visit_date)
VALUES (
    (SELECT COALESCE(MAX(id), 0) + 1 FROM person_visits),
    (SELECT id FROM person WHERE name = 'Dmitriy'),
    (SELECT pizzeria.id 
     FROM pizzeria  
     INNER JOIN menu m ON pizzeria.id = m.pizzeria_id
     WHERE price < 800 
       AND pizzeria.name != 'Papa Johns'
     ORDER BY pizzeria.id
     LIMIT 1),
    '2022-01-08'
)
ON CONFLICT ON CONSTRAINT uk_person_visits DO NOTHING;

REFRESH MATERIALIZED VIEW mv_dmitriy_visits_and_eats;

SELECT * FROM mv_dmitriy_visits_and_eats;