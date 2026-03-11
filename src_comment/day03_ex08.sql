DROP MATERIALIZED VIEW IF EXISTS mv_dmitriy_visits_and_eats CASCADE;


DROP VIEW IF EXISTS v_generated_dates CASCADE;
DROP VIEW IF EXISTS v_persons_female CASCADE;
DROP VIEW IF EXISTS v_persons_male CASCADE;
DROP VIEW IF EXISTS v_price_with_discount CASCADE;
DROP VIEW IF EXISTS v_symmetric_union CASCADE;



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






# 📝 Код с комментариями для защиты


-- =============================================================================
-- SQL Bootcamp Day 04 - Exercise 08
-- Удаление всех созданных VIEW и MATERIALIZED VIEW
-- =============================================================================

-- -----------------------------------------------------------------------------
-- ЗАДАЧА: Удалить все представления, созданные в предыдущих упражнениях
-- (ex00-ex07), и убедиться, что они действительно удалены
-- -----------------------------------------------------------------------------

-- =============================================================================
-- Удаление MATERIALIZED VIEW
-- =============================================================================

-- DROP MATERIALIZED VIEW - команда удаления материализованного представления
-- DROP - ключевое слово "удалить", "уничтожить"
-- MATERIALIZED VIEW - материализованное представление
-- (представление, которое физически хранит данные на диске)
-- 
-- Расшифровка термина MATERIALIZED:
-- MATERIALIZED = "материализованный", "физический", "осязаемый"
-- От слова "material" (материал, вещество)
-- В БД означает: данные сохранены на диске, а не вычисляются на лету
DROP MATERIALIZED VIEW 

-- IF EXISTS - условная конструкция "если существует"
-- IF - "если"
-- EXISTS - "существует"
-- 
-- Зачем нужно:
-- Если объект НЕ существует, команда DROP вызовет ошибку:
-- ERROR: materialized view "mv_dmitriy_visits_and_eats" does not exist
-- 
-- С IF EXISTS:
-- Существует → удалить ✅
-- Не существует → пропустить без ошибки ✅
-- 
-- Это делает скрипт ИДЕМПОТЕНТНЫМ (можно запускать многократно)
IF EXISTS 

-- mv_dmitriy_visits_and_eats - название материализованного представления
-- Создано в Exercise 06
-- mv_ - префикс для materialized view (соглашение об именовании)
-- dmitriy_visits_and_eats - описательное имя
mv_dmitriy_visits_and_eats 

-- CASCADE - каскадное удаление зависимых объектов
-- CASCADE = "каскад", "водопад" (от французского "cascade")
-- Означает: "удалить И все зависимые объекты"
-- 
-- Что удаляется CASCADE:
-- - VIEW, которые используют этот MATERIALIZED VIEW
-- - Другие MATERIALIZED VIEW, зависящие от этого
-- - Индексы на MATERIALIZED VIEW
-- - Правила (rules)
-- 
-- Альтернатива: RESTRICT (по умолчанию)
-- RESTRICT - запретить удаление, если есть зависимости
-- 
-- Пример:
-- Если есть VIEW: CREATE VIEW v AS SELECT * FROM mv_dmitriy_visits_and_eats;
-- DROP ... без CASCADE → ERROR: cannot drop ... because other objects depend on it
-- DROP ... CASCADE → удаляет mv_dmitriy_visits_and_eats И v
-- 
-- В нашем случае зависимостей скорее всего нет, но CASCADE используется
-- для гарантии (на случай, если кто-то создал зависимые объекты)
CASCADE;

-- Точка с запятой завершает команду DROP

-- ВАЖНО: Почему MATERIALIZED VIEW удаляется ПЕРВЫМ?
-- Потому что MVIEW может зависеть от обычных VIEW
-- Если удалить VIEW первым, а MVIEW от него зависит → ошибка
-- Поэтому порядок: сначала MVIEW, потом VIEW
-- (от более зависимых к менее зависимым)


-- =============================================================================
-- Удаление обычных VIEW
-- =============================================================================
-- Удаляем все VIEW, созданные в Exercise 00-05

-- DROP VIEW - команда удаления обычного представления
-- VIEW - виртуальное представление (не хранит данные, только SQL-запрос)
-- 
-- Отличие от MATERIALIZED VIEW:
-- VIEW - виртуальная таблица (только определение SQL)
-- MATERIALIZED VIEW - физическая таблица (сохранённые данные)
DROP VIEW 

-- IF EXISTS - условное удаление (как описано выше)
-- Предотвращает ошибку, если VIEW не существует
IF EXISTS 

-- v_generated_dates - VIEW из Exercise 02
-- Генерировал все даты января 2022 года
-- Использовал функцию generate_series
v_generated_dates 

-- CASCADE - каскадное удаление (как описано выше)
-- Удалит все объекты, зависящие от v_generated_dates
-- Например, если есть VIEW, который делает SELECT из v_generated_dates
CASCADE;

-- Точка с запятой завершает команду


-- DROP VIEW IF EXISTS v_persons_female CASCADE;
-- v_persons_female - VIEW из Exercise 00
-- Фильтровал людей по полу: WHERE gender = 'female'
-- Содержал: Anna, Kate, Elvira, Irina, Nataly
DROP VIEW IF EXISTS v_persons_female CASCADE;


-- DROP VIEW IF EXISTS v_persons_male CASCADE;
-- v_persons_male - VIEW из Exercise 00
-- Фильтровал людей по полу: WHERE gender = 'male'
-- Содержал: Andrey, Denis, Peter, Dmitriy
DROP VIEW IF EXISTS v_persons_male CASCADE;


-- DROP VIEW IF EXISTS v_price_with_discount CASCADE;
-- v_price_with_discount - VIEW из Exercise 05
-- Показывал заказы с ценами и скидкой 10%
-- Формула: CAST(price - price * 0.1 AS INTEGER)
DROP VIEW IF EXISTS v_price_with_discount CASCADE;


-- DROP VIEW IF EXISTS v_symmetric_union CASCADE;
-- v_symmetric_union - VIEW из Exercise 04
-- Реализовывал симметричную разность множеств: (R - S) ∪ (S - R)
-- R = посещения 02.01.2022, S = посещения 06.01.2022
DROP VIEW IF EXISTS v_symmetric_union CASCADE;

-- Все DROP команды завершены
-- На этом этапе все VIEW и MVIEW должны быть удалены


-- =============================================================================
-- ПРОВЕРКА удаления (валидация результата)
-- =============================================================================

-- SELECT COUNT(*) = 0 AS check - проверочный запрос
-- Цель: убедиться, что все представления действительно удалены
-- 
-- Логика:
-- COUNT(*) = 0 означает "количество найденных объектов равно нулю"
-- Если TRUE → всё удалено успешно ✅
-- Если FALSE → что-то осталось ❌
SELECT 
    -- COUNT(*) = 0 - условие проверки
    -- COUNT(*) - подсчитывает количество строк в результате
    -- = 0 - сравнивает с нулём
    -- Результат: BOOLEAN (true или false)
    -- 
    -- true = все объекты удалены (COUNT = 0)
    -- false = остались объекты (COUNT > 0)
    COUNT(*) = 0 
    
    -- AS check - название колонки в результате
    -- check = "проверка"
    -- Результат будет выглядеть так:
    --  check
    -- -------
    --  true   ← если всё удалено
    -- или
    --  false  ← если что-то осталось
    AS check

-- FROM pg_class - системная таблица PostgreSQL
-- pg_class - системный каталог (system catalog)
-- 
-- Расшифровка названия:
-- pg_ - префикс PostgreSQL для системных объектов
-- class - "класс" объектов БД
-- 
-- Что хранит pg_class:
-- Информацию обо ВСЕХ объектах в базе данных:
-- - Таблицы (tables)
-- - VIEW (представления)
-- - MATERIALIZED VIEW (материализованные представления)
-- - Индексы (indexes)
-- - Последовательности (sequences)
-- - И другие объекты
-- 
-- Структура pg_class (важные колонки):
-- - oid: уникальный идентификатор объекта
-- - relname: название объекта (relation name)
-- - relkind: тип объекта ('r'=таблица, 'v'=view, 'm'=mview)
-- - relnamespace: схема, в которой находится объект
FROM pg_class

-- WHERE relname IN (...) - условие фильтрации
-- WHERE - "где", условие отбора строк
-- relname - колонка в pg_class с названием объекта
-- 
-- Расшифровка relname:
-- rel = relation (отношение, таблица в широком смысле)
-- name = имя
-- relname = "имя отношения" (название объекта БД)
-- 
-- IN (...) - оператор "входит в список"
-- Проверяет, что значение находится в списке значений
-- Эквивалент: relname = 'v_generated_dates' OR relname = 'v_persons_female' OR ...
WHERE relname IN (
    -- Список всех названий VIEW и MVIEW, которые мы удалили
    -- Эти значения должны СОВПАДАТЬ с названиями в DROP командах
    
    -- 'v_generated_dates' - VIEW из Exercise 02
    -- Кавычки обязательны, так как это строковый литерал
    'v_generated_dates',
    
    -- 'v_persons_female' - VIEW из Exercise 00
    'v_persons_female',
    
    -- 'v_persons_male' - VIEW из Exercise 00
    'v_persons_male',
    
    -- 'v_price_with_discount' - VIEW из Exercise 05
    'v_price_with_discount',
    
    -- 'v_symmetric_union' - VIEW из Exercise 04
    'v_symmetric_union',
    
    -- 'mv_dmitriy_visits_and_eats' - MVIEW из Exercise 06
    'mv_dmitriy_visits_and_eats'
    
    -- ВАЖНО: В списке 6 объектов (5 VIEW + 1 MVIEW)
    -- Все они должны быть удалены
);

-- Точка с запятой завершает запрос

-- Как работает проверка:
-- 
-- Шаг 1: FROM pg_class
-- Берём ВСЕ объекты из системного каталога
-- 
-- Шаг 2: WHERE relname IN (...)
-- Фильтруем только наши 6 объектов
-- 
-- Шаг 3: COUNT(*)
-- Подсчитываем, сколько из них найдено
-- 
-- Шаг 4: COUNT(*) = 0
-- Сравниваем с нулём
-- 
-- Результаты:
-- Если COUNT(*) = 0 → true ✅ (всё удалено)
-- Если COUNT(*) > 0 → false ❌ (что-то осталось)
-- 
-- Примеры:
-- - Все удалены: COUNT(*) = 0 → 0 = 0 → true
-- - Остался 1: COUNT(*) = 1 → 1 = 0 → false
-- - Остались 2: COUNT(*) = 2 → 2 = 0 → false


-- =============================================================================
-- ДОПОЛНИТЕЛЬНАЯ ИНФОРМАЦИЯ ДЛЯ ЗАЩИТЫ
-- =============================================================================

-- ВОПРОС: Почему используется pg_class, а не pg_views?
-- ОТВЕТ: pg_class содержит И VIEW, И MATERIALIZED VIEW
-- 
-- pg_views - только обычные VIEW
-- pg_matviews - только MATERIALIZED VIEW
-- pg_class - ВСЕ объекты (включая VIEW и MVIEW)
-- 
-- Мы проверяем 5 VIEW + 1 MVIEW → нужна общая таблица
-- pg_class подходит идеально
-- 
-- Альтернативный подход (двумя запросами):
-- SELECT COUNT(*) FROM pg_views 
-- WHERE viewname IN ('v_generated_dates', ...);
-- + 
-- SELECT COUNT(*) FROM pg_matviews 
-- WHERE matviewname IN ('mv_dmitriy_visits_and_eats');

-- ВОПРОС: Что такое CASCADE и чем отличается от RESTRICT?
-- ОТВЕТ: 
-- 
-- CASCADE - "каскадное удаление"
-- Удаляет объект И все зависимые от него объекты
-- 
-- RESTRICT - "ограниченное удаление" (по умолчанию)
-- Запрещает удаление, если есть зависимости
-- 
-- Пример:
-- CREATE VIEW v1 AS SELECT * FROM person;
-- CREATE VIEW v2 AS SELECT * FROM v1;  -- v2 зависит от v1
-- 
-- DROP VIEW v1 RESTRICT;
-- ERROR: cannot drop view v1 because other objects depend on it
-- HINT: Use DROP ... CASCADE to drop the dependent objects too.
-- 
-- DROP VIEW v1 CASCADE;
-- NOTICE: drop cascades to view v2
-- ✅ Удалены v1 И v2
-- 
-- Визуализация:
-- v1 ← v2 ← v3
-- 
-- DROP v1 RESTRICT: ❌ Ошибка (v2 зависит)
-- DROP v1 CASCADE: ✅ Удаляет v1, v2, v3 (всю цепочку)

-- ВОПРОС: Зачем IF EXISTS, если потом проверяем через pg_class?
-- ОТВЕТ: Разные цели!
-- 
-- IF EXISTS в DROP:
-- - Предотвращает ОШИБКУ выполнения
-- - Делает скрипт идемпотентным
-- - Можно запускать многократно
-- 
-- Проверка через pg_class:
-- - ВАЛИДАЦИЯ результата
-- - Убедиться, что удаление прошло успешно
-- - Автоматическое тестирование
-- 
-- Без IF EXISTS:
-- Первый запуск: ✅ удаляет
-- Второй запуск: ❌ ERROR: view does not exist
-- 
-- С IF EXISTS:
-- Первый запуск: ✅ удаляет
-- Второй запуск: ✅ пропускает (нет ошибки)
-- Третий запуск: ✅ пропускает
-- 
-- Проверка через pg_class показывает ИТОГ:
-- true → всё чисто
-- false → что-то осталось (возможная проблема)

-- ВОПРОС: Почему MVIEW удаляется первым?
-- ОТВЕТ: Из-за возможных зависимостей
-- 
-- Иерархия зависимостей:
-- Таблицы → VIEW → MATERIALIZED VIEW
-- 
-- MATERIALIZED VIEW может ссылаться на VIEW:
-- CREATE VIEW v AS SELECT * FROM person;
-- CREATE MATERIALIZED VIEW mv AS SELECT * FROM v;
-- 
-- Если удалить v первым:
-- DROP VIEW v;  -- без CASCADE
-- ERROR: cannot drop view v because mv_... depends on it
-- 
-- Правильный порядок:
-- 1. DROP MATERIALIZED VIEW (самые зависимые)
-- 2. DROP VIEW (менее зависимые)
-- 3. DROP TABLE (базовые объекты)
-- 
-- Аналогия из программирования:
-- Сначала удаляем объекты верхнего уровня,
-- потом базовые компоненты

-- ВОПРОС: Что вернёт проверка, если один объект остался?
-- ОТВЕТ: false
-- 
-- Сценарий:
-- Удалили всё, кроме v_persons_female
-- 
-- SELECT COUNT(*) = 0 FROM pg_class 
-- WHERE relname IN ('v_generated_dates', 'v_persons_female', ...);
-- 
-- Шаг 1: WHERE фильтрует по именам
-- Находит: v_persons_female (1 строка)
-- 
-- Шаг 2: COUNT(*) = 1
-- 
-- Шаг 3: 1 = 0 → false
-- 
-- Результат:
--  check
-- -------
--  false  ← показывает проблему!
-- 
-- Для отладки можно использовать:
-- SELECT relname FROM pg_class 
-- WHERE relname IN (...);
-- 
-- Покажет, что именно осталось:
--      relname      
-- ------------------
--  v_persons_female

-- ВОПРОС: Можно ли удалить все VIEW одной командой?
-- ОТВЕТ: Нет стандартного способа в PostgreSQL
-- 
-- В других СУБД:
-- MySQL: DROP VIEW IF EXISTS v1, v2, v3;  -- список через запятую
-- 
-- PostgreSQL: каждый VIEW отдельной командой
-- DROP VIEW IF EXISTS v1;
-- DROP VIEW IF EXISTS v2;
-- DROP VIEW IF EXISTS v3;
-- 
-- Можно через динамический SQL (PL/pgSQL):
-- DO $$
-- DECLARE
--     v RECORD;
-- BEGIN
--     FOR v IN SELECT viewname FROM pg_views 
--              WHERE viewname LIKE 'v_%' LOOP
--         EXECUTE 'DROP VIEW IF EXISTS ' || v.viewname || ' CASCADE';
--     END LOOP;
-- END $$;
-- 
-- Но в задании требуется явное удаление каждого VIEW

-- =============================================================================
```

---

## 🎓 Дополнительные вопросы для защиты

### Вопрос 1: "Что такое pg_class?"

**Ответ:**

```
pg_class - системный каталог PostgreSQL (system catalog)

Расшифровка:
pg_ = PostgreSQL (префикс для системных объектов)
class = класс объектов базы данных

Что хранит:
Информацию обо ВСЕХ объектах в базе данных:
• Таблицы (tables) - relkind='r'
• VIEW (представления) - relkind='v'
• MATERIALIZED VIEW - relkind='m'
• Индексы (indexes) - relkind='i'
• Последовательности (sequences) - relkind='S'
• И другие объекты

Важные колонки:
┌──────────────┬─────────────────────────────────┐
│ Колонка      │ Описание                        │
├──────────────┼─────────────────────────────────┤
│ oid          │ Уникальный ID объекта           │
│ relname      │ Название объекта                │
│ relkind      │ Тип объекта (r/v/m/i/S)         │
│ relnamespace │ Схема (namespace)               │
│ relowner     │ Владелец объекта                │
└──────────────┴─────────────────────────────────┘

Пример использования:
-- Все таблицы:
SELECT relname FROM pg_class WHERE relkind = 'r';

-- Все VIEW:
SELECT relname FROM pg_class WHERE relkind = 'v';

-- Все MVIEW:
SELECT relname FROM pg_class WHERE relkind = 'm';

Аналоги в других СУБД:
MySQL: information_schema.tables
Oracle: all_objects, dba_objects
MS SQL: sys.objects
```

---

### Вопрос 2: "Чем CASCADE отличается от RESTRICT?"

**Ответ:**

```sql
CASCADE vs RESTRICT - два режима удаления

CASCADE (каскадное удаление):
- Удаляет объект И все зависимые объекты
- "Водопад" - удаление распространяется вниз

RESTRICT (ограниченное удаление):
- Удаляет только если НЕТ зависимостей
- По умолчанию в PostgreSQL

Пример с зависимостями:

-- Создаём цепочку:
CREATE TABLE t1 (id INT);
CREATE VIEW v1 AS SELECT * FROM t1;
CREATE VIEW v2 AS SELECT * FROM v1;
CREATE MATERIALIZED VIEW mv AS SELECT * FROM v2;

Зависимости:
t1 ← v1 ← v2 ← mv

Попытка удалить с RESTRICT:
DROP VIEW v1 RESTRICT;
❌ ERROR: cannot drop view v1 because other objects depend on it
HINT: Use DROP ... CASCADE to drop the dependent objects too.

Удаление с CASCADE:
DROP VIEW v1 CASCADE;
NOTICE: drop cascades to view v2
NOTICE: drop cascades to materialized view mv
✅ Удалены: v1, v2, mv

Визуализация:

RESTRICT:
v1 ← v2 ← v3
 ↓
 ✗ Ошибка! (есть зависимости)

CASCADE:
v1 ← v2 ← v3
 ↓    ↓    ↓
 ✅   ✅   ✅  Всё удалено!

Когда использовать:

CASCADE:
✅ При очистке БД (удалить всё связанное)
✅ При удалении тестовых данных
⚠️ ОПАСНО в production! (может удалить больше, чем планировали)

RESTRICT:
✅ Для безопасности (защита от случайного удаления)
✅ В production среде
✅ Когда нужна уверенность, что нет зависимостей
```

---

### Вопрос 3: "Зачем IF EXISTS, если есть проверка через pg_class?"

**Ответ:**

```
Разные цели!

IF EXISTS (в DROP):
Цель: ПРЕДОТВРАТИТЬ ОШИБКУ
Делает скрипт идемпотентным

БЕЗ IF EXISTS:
DROP VIEW v_persons_female;

Первый запуск:
✅ VIEW существует → удаляется

Второй запуск:
❌ ERROR: view "v_persons_female" does not exist
Скрипт падает!

С IF EXISTS:
DROP VIEW IF EXISTS v_persons_female;

Первый запуск:
✅ VIEW существует → удаляется

Второй запуск:
✅ VIEW не существует → пропускается (без ошибки)

Третий запуск:
✅ Пропускается

───────────────────────────────────────

Проверка через pg_class:
Цель: ВАЛИДАЦИЯ результата
Убедиться, что удаление прошло успешно

SELECT COUNT(*) = 0 FROM pg_class WHERE ...;

Результат:
• true → всё чисто ✅
• false → что-то осталось ❌

Зачем проверка, если IF EXISTS?

1. Автоматическое тестирование:
   Скрипт можно использовать в CI/CD
   Проверка показывает успех/провал

2. Диагностика проблем:
   Если false → что-то пошло не так
   (может быть права доступа, блокировки и т.д.)

3. Документирование ожидаемого результата:
   "После этого скрипта должно быть 0 объектов"

Аналогия из программирования:

// IF EXISTS = try-catch (избежать ошибки)
try {
    deleteFile("file.txt");
} catch (FileNotFoundException e) {
    // игнорируем
}

// Проверка = assert (валидация результата)
assert(!fileExists("file.txt"));  // проверяем результат
```

---

### Вопрос 4: "Почему MVIEW удаляется первым?"

**Ответ:**

```
Причина: ИЕРАРХИЯ ЗАВИСИМОСТЕЙ

Уровни объектов (от базовых к зависимым):
1. Таблицы (tables) - базовый уровень
2. VIEW - зависят от таблиц
3. MATERIALIZED VIEW - могут зависеть от VIEW

Возможная ситуация:

CREATE TABLE person (...);
CREATE VIEW v_persons AS SELECT * FROM person;
CREATE MATERIALIZED VIEW mv_stats AS SELECT COUNT(*) FROM v_persons;

Зависимости:
person → v_persons → mv_stats

Если удалять в неправильном порядке:

1. DROP VIEW v_persons;  -- без CASCADE
   ❌ ERROR: cannot drop view v_persons 
      because materialized view mv_stats depends on it

2. DROP TABLE person;  -- без CASCADE
   ❌ ERROR: cannot drop table person
      because view v_persons depends on it

Правильный порядок (снизу вверх):

1. DROP MATERIALIZED VIEW mv_stats; ✅
2. DROP VIEW v_persons; ✅
3. DROP TABLE person; ✅

В нашей задаче:
DROP MATERIALIZED VIEW ... CASCADE;  -- сначала
DROP VIEW ... CASCADE;                -- потом

CASCADE решает проблему порядка:
Но явный порядок более понятен и безопасен

Визуализация:

Неправильно:         Правильно:
Базовый уровень      Зависимый уровень
     ↓                    ↓
 ✗ Ошибка!            ✅ MVIEW
                         ↓
                      ✅ VIEW
                         ↓
                      ✅ TABLE

Аналогия из программирования:

// Удаление зависимостей
class Base { }
class Derived extends Base { }
class GrandChild extends Derived { }

// Правильно:
delete grandChild;  // сначала самый зависимый
delete derived;
delete base;        // потом базовый

// Неправильно:
delete base;  // ❌ derived и grandChild используют base!
```

---

### Вопрос 5: "Что вернёт проверка, если один объект остался?"

**Ответ:**

```sql
Сценарий: остался v_persons_female

SELECT COUNT(*) = 0 AS check
FROM pg_class
WHERE relname IN (
    'v_generated_dates',
    'v_persons_female',  -- ← этот остался!
    'v_persons_male',
    'v_price_with_discount',
    'v_symmetric_union',
    'mv_dmitriy_visits_and_eats'
);

Пошаговое выполнение:

Шаг 1: FROM pg_class
Берём все объекты из системного каталога

Шаг 2: WHERE relname IN (...)
Фильтруем по именам
Находит: v_persons_female (1 строка)

Шаг 3: COUNT(*)
Подсчитывает: 1

Шаг 4: COUNT(*) = 0
1 = 0 → false

Результат:
┌───────┐
│ check │
├───────┤
│ false │ ← показывает проблему!
└───────┘

Отладка - узнать, ЧТО осталось:

SELECT relname, relkind
FROM pg_class
WHERE relname IN (
    'v_generated_dates',
    'v_persons_female',
    'v_persons_male',
    'v_price_with_discount',
    'v_symmetric_union',
    'mv_dmitriy_visits_and_eats'
);

Результат:
┌──────────────────┬─────────┐
│ relname          │ relkind │
├──────────────────┼─────────┤
│ v_persons_female │ v       │ ← VIEW остался!
└──────────────────┴─────────┘

relkind расшифровка:
'v' = VIEW
'm' = MATERIALIZED VIEW
'r' = обычная таблица

Возможные причины, почему объект остался:

1. Права доступа:
   У пользователя нет прав на удаление

2. Блокировка:
   Объект используется другой сессией

3. Опечатка в названии:
   DROP VIEW v_person_female;  -- ← typo!
   Реальное название: v_persons_female

4. Схема (schema):
   Объект в другой схеме:
   public.v_persons_female - удалился
   other_schema.v_persons_female - остался
```

---

### Вопрос 6: "Можно ли удалить все VIEW одной командой?"

**Ответ:**

```sql
В PostgreSQL НЕТ команды для удаления нескольких VIEW сразу

В других СУБД:

MySQL (поддерживает список):
DROP VIEW IF EXISTS v1, v2, v3, v4;
✅ Одна команда

PostgreSQL (только по одному):
DROP VIEW IF EXISTS v1;
DROP VIEW IF EXISTS v2;
DROP VIEW IF EXISTS v3;
DROP VIEW IF EXISTS v4;
❌ Несколько команд

Альтернативы в PostgreSQL:

1. Динамический SQL (PL/pgSQL):

DO $$
DECLARE
    view_name TEXT;
BEGIN
    FOR view_name IN 
        SELECT viewname FROM pg_views 
        WHERE viewname LIKE 'v_%'
    LOOP
        EXECUTE 'DROP VIEW IF EXISTS ' || view_name || ' CASCADE';
    END LOOP;
END $$;

2. Генерация команд через SELECT:

SELECT 'DROP VIEW IF EXISTS ' || viewname || ' CASCADE;'
FROM pg_views
WHERE viewname IN (
    'v_generated_dates',
    'v_persons_female',
    'v_persons_male',
    'v_price_with_discount',
    'v_symmetric_union'
);

Результат:
┌──────────────────────────────────────────────────┐
│ DROP VIEW IF EXISTS v_generated_dates CASCADE;   │
│ DROP VIEW IF EXISTS v_persons_female CASCADE;    │
│ DROP VIEW IF EXISTS v_persons_male CASCADE;      │
│ DROP VIEW IF EXISTS v_price_with_discount ...   │
│ DROP VIEW IF EXISTS v_symmetric_union CASCADE;   │
└──────────────────────────────────────────────────┘

Копируем и выполняем!

3. Bash скрипт:

#!/bin/bash
for view in v_generated_dates v_persons_female v_persons_male; do
    psql -c "DROP VIEW IF EXISTS $view CASCADE;"
done

Но в учебном задании:
Требуется ЯВНО удалить каждый VIEW отдельной командой
Это показывает понимание того, ЧТО именно удаляется
```

---

## 📊 Визуализация удаления

```
СОСТОЯНИЕ ДО УДАЛЕНИЯ:

pg_class содержит:
┌─────────────────────────┬─────────┐
│ relname                 │ relkind │
├─────────────────────────┼─────────┤
│ person                  │ r       │ ← таблица
│ menu                    │ r       │
│ v_generated_dates       │ v       │ ← VIEW
│ v_persons_female        │ v       │ ← VIEW
│ v_persons_male          │ v       │ ← VIEW
│ v_price_with_discount   │ v       │ ← VIEW
│ v_symmetric_union       │ v       │ ← VIEW
│ mv_dmitriy_visits...    │ m       │ ← MVIEW
│ ...                     │ ...     │
└─────────────────────────┴─────────┘

         ↓ DROP команды
         
СОСТОЯНИЕ ПОСЛЕ УДАЛЕНИЯ:

pg_class содержит:
┌─────────────────────────┬─────────┐
│ relname                 │ relkind │
├─────────────────────────┼─────────┤
│ person                  │ r       │ ← таблица (осталась)
│ menu                    │ r       │
│ ...                     │ ...     │
└─────────────────────────┴─────────┘

VIEW и MVIEW удалены! ✅

Проверка:
SELECT COUNT(*) = 0 FROM pg_class 
WHERE relname IN ('v_generated_dates', ...)

COUNT(*) = 0 → true ✅
```

---

## 📋 Шпаргалка для защиты

### Команды удаления:

| Команда | Описание | Особенности |
|---------|----------|-------------|
| `DROP VIEW` | Удалить VIEW | Виртуальная таблица |
| `DROP MATERIALIZED VIEW` | Удалить MVIEW | Физические данные |
| `IF EXISTS` | Условное удаление | Без ошибки если нет |
| `CASCADE` | Каскадное удаление | + зависимые объекты |
| `RESTRICT` | Ограниченное | Только если нет зависимостей |

### Системные таблицы:

| Таблица | Содержит | Для проверки |
|---------|----------|--------------|
| `pg_class` | Все объекты БД | VIEW + MVIEW |
| `pg_views` | Только VIEW | Только VIEW |
| `pg_matviews` | Только MVIEW | Только MVIEW |

---

## 🎯 Краткий ответ для защиты (60 секунд)

```
Я удаляю все VIEW и MATERIALIZED VIEW, созданные в упражнениях.

Порядок важен: сначала MVIEW, потом VIEW.
Причина: MVIEW может зависеть от VIEW.
Если удалить VIEW первым → ошибка зависимости.

Использую DROP MATERIALIZED VIEW для mv_dmitriy_visits_and_eats,
затем DROP VIEW для остальных пяти представлений.

IF EXISTS делает скрипт идемпотентным - можно запускать многократно
без ошибок. Если объект не существует → пропускается.

CASCADE удаляет зависимые объекты. Если что-то зависит от VIEW →
удаляется вместе с ним. Без CASCADE была бы ошибка при наличии
зависимостей.

Проверка через pg_class - системный каталог PostgreSQL.
Содержит информацию обо всех объектах БД.
relname - колонка с названием объекта.

SELECT COUNT(*) = 0 проверяет, что все 6 объектов удалены.
Если COUNT = 0 → true (всё чисто).
Если COUNT > 0 → false (что-то осталось).

Результат должен быть true - все представления удалены успешно.
```

---

**Готово к защите! 🎓**