-- =============================================================================
-- Exercise 08: Удаление всех VIEW и ОЧИСТКА ДАННЫХ
-- =============================================================================

-- Удаляем MATERIALIZED VIEW
DROP MATERIALIZED VIEW IF EXISTS mv_dmitriy_visits_and_eats CASCADE;

-- Удаляем VIEW
DROP VIEW IF EXISTS v_generated_dates CASCADE;
DROP VIEW IF EXISTS v_persons_female CASCADE;
DROP VIEW IF EXISTS v_persons_male CASCADE;
DROP VIEW IF EXISTS v_price_with_discount CASCADE;
DROP VIEW IF EXISTS v_symmetric_union CASCADE;

-- =============================================================================
-- НОВОЕ! Удаляем данные, добавленные в Exercise 07
-- =============================================================================

-- Удаляем посещение DoDo Pizza, добавленное в ex07
-- Это вернёт базу в исходное состояние (только данные из model.sql)
DELETE FROM person_visits 
WHERE person_id = (SELECT id FROM person WHERE name = 'Dmitriy')
  AND pizzeria_id = (SELECT id FROM pizzeria WHERE name = 'DoDo Pizza')
  AND visit_date = '2022-01-08';

-- Альтернативный вариант (если знаешь, что в model.sql макс id = 19):
-- DELETE FROM person_visits WHERE id > 19;

-- =============================================================================
-- Проверка удаления VIEW/MVIEW
-- =============================================================================

SELECT COUNT(*) = 0 AS check
FROM pg_class
WHERE relname IN (
    'v_generated_dates',
    'v_persons_female',
    'v_persons_male',
    'v_price_with_discount',
    'v_symmetric_union',
    'mv_dmitriy_visits_and_eats'
);