-- ====================================================================================
-- MASTER SCRIPT FOR BRIGHTON & HOVE ALBION FC SYNTHETIC DATASET (V3 - FULLY RELATIONAL)
-- ====================================================================================
-- This script creates and populates 14 interconnected tables for a comprehensive
-- analysis of Brighton & Hove Albion FC. All data is synthetic.
-- ====================================================================================


-- ====================================================================================
-- TABLE 1: players
-- ====================================================================================
CREATE OR REPLACE TABLE `football_agent.players` AS
WITH PlayerData AS (
  SELECT 'Bart' AS first_name, 'Verbruggen' AS last_name, 'Goalkeeper' AS position, 'Netherlands' AS nationality, 1 AS squad_number, DATE('1992-08-18') AS date_of_birth UNION ALL
  SELECT 'Tariq' AS first_name, 'Lamptey' AS last_name, 'Defender' AS position, 'Ghana' AS nationality, 2 AS squad_number, DATE('2000-09-30') AS date_of_birth UNION ALL
  SELECT 'Igor' AS first_name, 'Julio' AS last_name, 'Defender' AS position, 'Brazil' AS nationality, 3 AS squad_number, DATE('1998-02-07') AS date_of_birth UNION ALL
  SELECT 'Adam' AS first_name, 'Webster' AS last_name, 'Defender' AS position, 'England' AS nationality, 4 AS squad_number, DATE('1995-01-04') AS date_of_birth UNION ALL
  SELECT 'Lewis' AS first_name, 'Dunk' AS last_name, 'Defender' AS position, 'England' AS nationality, 5 AS squad_number, DATE('1991-11-21') AS date_of_birth UNION ALL
  SELECT 'James' AS first_name, 'Milner' AS last_name, 'Midfielder' AS position, 'England' AS nationality, 6 AS squad_number, DATE('1986-01-04') AS date_of_birth UNION ALL
  SELECT 'Solly' AS first_name, 'March' AS last_name, 'Midfielder' AS position, 'England' AS nationality, 7 AS squad_number, DATE('1994-07-20') AS date_of_birth UNION ALL
  SELECT 'João' AS first_name, 'Pedro' AS last_name, 'Forward' AS position, 'Brazil' AS nationality, 9 AS squad_number, DATE('2001-09-26') AS date_of_birth UNION ALL
  SELECT 'Julio' AS first_name, 'Enciso' AS last_name, 'Forward' AS position, 'Paraguay' AS nationality, 10 AS squad_number, DATE('2004-01-23') AS date_of_birth UNION ALL
  SELECT 'Pascal' AS first_name, 'Groß' AS last_name, 'Midfielder' AS position, 'Germany' AS nationality, 13 AS squad_number, DATE('1991-06-15') AS date_of_birth UNION ALL
  SELECT 'Jakub' AS first_name, 'Moder' AS last_name, 'Midfielder' AS position, 'Poland' AS nationality, 15 AS squad_number, DATE('1999-04-07') AS date_of_birth UNION ALL
  SELECT 'Kaoru' AS first_name, 'Mitoma' AS last_name, 'Forward' AS position, 'Japan' AS nationality, 22 AS squad_number, DATE('1997-05-20') AS date_of_birth UNION ALL
  SELECT 'Jason' AS first_name, 'Steele' AS last_name, 'Goalkeeper' AS position, 'England' AS nationality, 23 AS squad_number, DATE('1990-08-18') AS date_of_birth UNION ALL
  SELECT 'Jan Paul' AS first_name, 'van Hecke' AS last_name, 'Defender' AS position, 'Netherlands' AS nationality, 29 AS squad_number, DATE('2000-06-08') AS date_of_birth UNION ALL
  SELECT 'Pervis' AS first_name, 'Estupiñán' AS last_name, 'Defender' AS position, 'Ecuador' AS nationality, 30 AS squad_number, DATE('1998-01-21') AS date_of_birth UNION ALL
  SELECT 'Evan' AS first_name, 'Ferguson' AS last_name, 'Forward' AS position, 'Ireland' AS nationality, 28 AS squad_number, DATE('2004-10-19') AS date_of_birth UNION ALL
  SELECT 'Ansu' AS first_name, 'Fati' AS last_name, 'Forward' AS position, 'Spain' AS nationality, 31 AS squad_number, DATE('2002-10-31') AS date_of_birth UNION ALL
  SELECT 'Facundo' AS first_name, 'Buonanotte' AS last_name, 'Midfielder' AS position, 'Argentina' AS nationality, 40 AS squad_number, DATE('2004-12-23') AS date_of_birth
)
SELECT
  ROW_NUMBER() OVER() AS player_id,
  pd.*,
  DATE_SUB(CURRENT_DATE(), INTERVAL CAST(FLOOR(1 + RAND() * 5) * 365 AS INT64) DAY) AS join_date,
  TRUE AS is_active
FROM PlayerData pd;


-- ====================================================================================
-- TABLE 2: matches
-- ====================================================================================
CREATE OR REPLACE TABLE `football_agent.matches` AS
WITH
  DataSource AS (
    SELECT
      'Brighton & Hove Albion' AS our_team,
      'American Express Community Stadium' as venue,
      ['Arsenal', 'Aston Villa', 'Bournemouth', 'Brentford', 'Chelsea', 'Crystal Palace', 'Everton', 'Fulham', 'Ipswich Town', 'Leicester City', 'Liverpool', 'Manchester City', 'Manchester United', 'Newcastle United', 'Nottingham Forest', 'Southampton', 'Tottenham Hotspur', 'West Ham United', 'Wolverhampton Wanderers'] AS premier_league_opponents
  ),
  MatchList AS (
    SELECT '2023-2024' AS season, 'Premier League' AS competition, our_team AS home_team, opponent AS away_team FROM DataSource, UNNEST(premier_league_opponents) AS opponent
    UNION ALL
    SELECT '2023-2024' AS season, 'Premier League' AS competition, opponent AS home_team, our_team AS away_team FROM DataSource, UNNEST(premier_league_opponents) AS opponent
  )
SELECT
  ROW_NUMBER() OVER() AS match_id,
  DATE_ADD(PARSE_DATE('%Y', LEFT(season, 4)), INTERVAL CAST(FLOOR(8 + RAND() * 10) AS INT64) MONTH) AS match_date,
  season,
  competition,
  home_team,
  away_team,
  CASE WHEN home_team = d.our_team THEN d.venue ELSE home_team || ' Stadium' END as venue_name,
  CONCAT(CAST(CAST(FLOOR(RAND() * 4) AS INT64) AS STRING), '-', CAST(CAST(FLOOR(RAND() * 4) AS INT64) AS STRING)) AS final_score,
  CASE WHEN home_team = d.our_team THEN CAST(FLOOR(30000 + RAND() * 1799) AS INT64) ELSE CAST(FLOOR(40000 + RAND() * 35000) AS INT64) END AS attendance
FROM MatchList, DataSource d;


-- ====================================================================================
-- TABLE 3: fan_database
-- ====================================================================================
CREATE OR REPLACE TABLE `football_agent.fan_database` AS
WITH
  DataSource AS (
    SELECT
      ['James', 'Mary', 'John', 'Patricia', 'Robert', 'Jennifer', 'Michael', 'Linda'] AS first_names,
      ['Smith', 'Johnson', 'Williams', 'Brown', 'Jones', 'Garcia', 'Miller', 'Davis'] AS last_names,
      ['Germany', 'France', 'Spain', 'Italy', 'Netherlands', 'USA', 'Japan', 'Australia', 'Canada', 'Brazil'] AS international_countries
  ),
  GeneratedRows AS (
    SELECT id, RAND() AS r FROM UNNEST(GENERATE_ARRAY(1, 500000)) AS id
  )
SELECT
  g.id AS fan_id,
  d.first_names[OFFSET(CAST(FLOOR(RAND() * ARRAY_LENGTH(d.first_names)) AS INT64))] AS first_name,
  d.last_names[OFFSET(CAST(FLOOR(RAND() * ARRAY_LENGTH(d.last_names)) AS INT64))] AS last_name,
  CASE
    WHEN g.r < 0.70 THEN 'United Kingdom'
    WHEN g.r < 0.85 THEN 'USA'
    ELSE d.international_countries[OFFSET(CAST(FLOOR(RAND() * ARRAY_LENGTH(d.international_countries)) AS INT64))]
  END AS supporter_country,
  CASE WHEN RAND() < 0.90 THEN 'yes' ELSE 'no' END AS attended_game,
  CASE WHEN RAND() < 0.20 THEN 'yes' ELSE 'no' END AS paid_app_member
FROM GeneratedRows AS g, DataSource AS d;


-- ====================================================================================
-- TABLE 4: employees
-- ====================================================================================
CREATE OR REPLACE TABLE `football_agent.employees` AS
WITH
  DataSource AS (
    SELECT
      ['Olivia', 'Emma', 'Amelia', 'Ava', 'Sophia', 'Isabella', 'Charlotte', 'Mia'] AS first_names,
      ['Smith', 'Johnson', 'Williams', 'Brown', 'Jones', 'Garcia', 'Miller', 'Davis'] AS last_names,
      [
        STRUCT('Coaching' AS department, 'Head Coach' AS job_title), STRUCT('Coaching' AS department, 'Assistant Coach' AS job_title),
        STRUCT('Medical' AS department, 'Team Doctor' AS job_title), STRUCT('Medical' AS department, 'Physiotherapist' AS job_title),
        STRUCT('Recruitment' AS department, 'Head of Recruitment' AS job_title), STRUCT('Recruitment' AS department, 'First Team Scout' AS job_title),
        STRUCT('Marketing' AS department, 'Marketing Manager' AS job_title), STRUCT('Commercial' AS department, 'Sponsorship Manager' AS job_title)
      ] AS roles
  )
SELECT
  1000 + id AS employee_id,
  d.first_names[OFFSET(CAST(FLOOR(RAND() * ARRAY_LENGTH(d.first_names)) AS INT64))] AS first_name,
  d.last_names[OFFSET(CAST(FLOOR(RAND() * ARRAY_LENGTH(d.last_names)) AS INT64))] AS last_name,
  r.*,
  DATE_SUB(CURRENT_DATE(), INTERVAL CAST(FLOOR(90 + RAND() * 3000) AS INT64) DAY) AS start_date
FROM UNNEST(GENERATE_ARRAY(1, 150)) AS id, DataSource AS d, UNNEST([d.roles[OFFSET(CAST(FLOOR(RAND() * ARRAY_LENGTH(d.roles)) AS INT64))]]) as r;


-- ====================================================================================
-- DEPENDENT TABLES START HERE
-- The following tables have foreign key relationships to the tables above.
-- ====================================================================================


-- ====================================================================================
-- TABLE 5: ticket_sales (depends on matches, fan_database)
-- ====================================================================================
CREATE OR REPLACE TABLE `football_agent.ticket_sales` AS
WITH
  HomeMatches AS (
    SELECT match_id, match_date, CAST(attendance * 0.8 AS INT64) as tickets_to_sell
    FROM `football_agent.matches`
    WHERE home_team = 'Brighton & Hove Albion'
  ),
  FanPurchases AS (
    SELECT
      m.match_id,
      m.match_date,
      (SELECT fan_id FROM `football_agent.fan_database` ORDER BY RAND() LIMIT 1) as fan_id
    FROM HomeMatches m, UNNEST(GENERATE_ARRAY(1, m.tickets_to_sell))
  )
SELECT
  GENERATE_UUID() AS ticket_id,
  fp.match_id,
  fp.fan_id,
  TIMESTAMP_SUB(CAST(fp.match_date AS TIMESTAMP), INTERVAL CAST(FLOOR(5 + RAND() * 40) * 24 AS INT64) HOUR) AS purchase_timestamp,
  ['North Stand', 'East Stand', 'South Stand', 'West Stand', 'Corporate Box'][OFFSET(CAST(FLOOR(RAND() * 5) AS INT64))] AS seat_section,
  CAST(FLOOR(45 + RAND() * 120) AS NUMERIC) AS price_paid,
  ['Adult', 'Child', 'Senior'][OFFSET(CAST(FLOOR(RAND() * 3) AS INT64))] AS ticket_type
FROM FanPurchases fp;


-- ====================================================================================
-- TABLE 6: player_stats_per_match (depends on matches, players)
-- ====================================================================================
CREATE OR REPLACE TABLE `football_agent.player_stats_per_match` AS
WITH
  MatchRoster AS (
    SELECT m.match_id, p.player_id, p.position, ROW_NUMBER() OVER(PARTITION BY m.match_id ORDER BY RAND()) as player_order
    FROM `football_agent.matches` m, `football_agent.players` p
    WHERE p.is_active = TRUE
    QUALIFY ROW_NUMBER() OVER(PARTITION BY m.match_id ORDER BY RAND()) <= 16
  )
SELECT
  GENERATE_UUID() AS stat_id,
  mr.match_id,
  mr.player_id,
  CASE WHEN mr.player_order <= 11 THEN CAST(60 + RAND() * 30 AS INT64) ELSE CAST(FLOOR(RAND() * 30) AS INT64) END AS minutes_played,
  CASE WHEN mr.position IN ('Forward', 'Midfielder') AND RAND() < 0.1 THEN 1 ELSE 0 END AS goals,
  CASE WHEN mr.position != 'Goalkeeper' AND RAND() < 0.15 THEN 1 ELSE 0 END AS assists,
  CAST(FLOOR(RAND() * 4) AS INT64) AS shots_on_target,
  CAST(FLOOR(15 + RAND() * 40) AS INT64) AS passes_completed,
  CAST(FLOOR(RAND() * 5) AS INT64) AS tackles_won,
  CASE WHEN RAND() < 0.1 THEN 1 ELSE 0 END AS yellow_cards,
  CASE WHEN RAND() < 0.01 THEN 1 ELSE 0 END AS red_cards
FROM MatchRoster mr;


-- ====================================================================================
-- TABLE 7: merchandise_sales (depends on fan_database)
-- ====================================================================================
CREATE OR REPLACE TABLE `football_agent.merchandise_sales` AS
WITH
  DataSource AS (
    SELECT [
      STRUCT('HM-25-L' AS sku, 'Home Kit 2024/25 - Large' AS name, 'Kits' AS category, 75.00 AS price),
      STRUCT('SCARF-01' AS sku, 'Classic Club Scarf' AS name, 'Accessories' AS category, 18.00 AS price),
      STRUCT('MUG-05' AS sku, 'Crest Mug' AS name, 'Souvenirs' AS category, 12.50 AS price)
    ] AS products
  ),
  Transactions AS (
    SELECT
      id,
      p.*,
      (SELECT fan_id FROM `football_agent.fan_database` ORDER BY RAND() LIMIT 1) as fan_id
    FROM UNNEST(GENERATE_ARRAY(1, 100000)) as id, DataSource d,
    UNNEST([d.products[OFFSET(CAST(FLOOR(RAND() * ARRAY_LENGTH(d.products)) AS INT64))]]) AS p
  )
SELECT
  GENERATE_UUID() AS sale_id,
  t.fan_id,
  t.sku AS product_sku,
  t.name AS product_name,
  t.category,
  1 AS quantity,
  t.price AS total_price,
  TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL CAST(FLOOR(RAND() * 365 * 24 * 60) AS INT64) MINUTE) AS purchase_timestamp,
  ['Online Store', 'Stadium Megastore'][OFFSET(CAST(FLOOR(RAND() * 2) AS INT64))] AS purchase_location
FROM Transactions t;


-- ====================================================================================
-- TABLE 8: sponsorships
-- ====================================================================================
CREATE OR REPLACE TABLE `football_agent.sponsorships` AS
SELECT
  2000 + id AS sponsorship_id,
  d.sponsor_name,
  d.industry,
  d.deal_type,
  DATE_SUB(CURRENT_DATE(), INTERVAL CAST(FLOOR(100 + RAND() * 1500) AS INT64) DAY) AS start_date,
  DATE_ADD(CURRENT_DATE(), INTERVAL CAST(FLOOR(365 + RAND() * 1000) AS INT64) DAY) AS end_date,
  CAST(500000 + FLOOR(RAND() * 20000000) AS NUMERIC) AS annual_value_gbp
FROM
  UNNEST(GENERATE_ARRAY(1, 20)) AS id,
  (
    SELECT
      ['American Express', 'Nike', 'SnickersUK', 'Betway'] AS sponsor_name,
      ['Finance', 'Apparel', 'Confectionery', 'Betting'] AS industry,
      ['Main Kit Sponsor', 'Sleeve Sponsor', 'Official Training Wear', 'Stadium Naming Rights'] AS deal_type
  ) AS d;


-- ====================================================================================
-- TABLE 9: youth_academy_players
-- ====================================================================================
CREATE OR REPLACE TABLE `football_agent.youth_academy_players` AS
SELECT
  5000 + id AS youth_player_id,
  d.first_names[OFFSET(CAST(FLOOR(RAND() * ARRAY_LENGTH(d.first_names)) AS INT64))] AS first_name,
  d.last_names[OFFSET(CAST(FLOOR(RAND() * ARRAY_LENGTH(d.last_names)) AS INT64))] AS last_name,
  DATE_SUB(CURRENT_DATE(), INTERVAL CAST(FLOOR(16 + RAND() * 5) * 365 AS INT64) DAY) AS date_of_birth,
  ['U18', 'U21'][OFFSET(CAST(FLOOR(RAND() * 2) AS INT64))] AS age_group,
  ['Goalkeeper', 'Defender', 'Midfielder', 'Forward'][OFFSET(CAST(FLOOR(RAND() * 4) AS INT64))] AS position,
  CAST(60 + FLOOR(RAND() * 35) AS INT64) AS potential_rating,
  'Active' as status
FROM
  UNNEST(GENERATE_ARRAY(1, 50)) AS id,
  (
    SELECT
      ['Alfie', 'Archie', 'Finley', 'Freddie', 'Jude', 'Leo'] AS first_names,
      ['Hughes', 'Shaw', 'Bailey', 'Cole', 'Dunn', 'Fletcher'] AS last_names
  ) AS d;


-- ====================================================================================
-- TABLE 10: player_injuries (depends on players)
-- ====================================================================================
CREATE OR REPLACE TABLE `football_agent.player_injuries` AS
WITH InjuryTypes AS (
  SELECT
    ['Hamstring Strain', 'Ankle Sprain', 'Groin Strain', 'ACL Tear'] AS types,
    [21, 28, 14, 240] AS recovery_days
),
InjuryEvents AS (
  SELECT
    (SELECT player_id FROM `football_agent.players` ORDER BY RAND() LIMIT 1) AS player_id,
    CAST(FLOOR(RAND() * 4) AS INT64) AS injury_idx
  FROM UNNEST(GENERATE_ARRAY(1, 40))
)
SELECT
  GENERATE_UUID() AS injury_id,
  ie.player_id,
  it.types[OFFSET(ie.injury_idx)] AS injury_type,
  DATE_SUB(CURRENT_DATE(), INTERVAL CAST(FLOOR(10 + RAND() * 500) AS INT64) DAY) AS date_of_injury,
  DATE_ADD(
    DATE_SUB(CURRENT_DATE(), INTERVAL CAST(FLOOR(10 + RAND() * 500) AS INT64) DAY),
    INTERVAL it.recovery_days[OFFSET(ie.injury_idx)] DAY
  ) AS expected_return_date
FROM InjuryEvents ie, InjuryTypes it;


-- ====================================================================================
-- TABLE 11: social_media_engagement
-- ====================================================================================
CREATE OR REPLACE TABLE `football_agent.social_media_engagement` AS
SELECT
  GENERATE_UUID() AS post_id,
  d.platform,
  TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL CAST(FLOOR(1 + RAND() * 365 * 24 * 60) AS INT64) MINUTE) AS post_timestamp,
  d.post_category,
  CAST(FLOOR(500 + RAND() * 50000) AS INT64) AS likes,
  CAST(FLOOR(50 + RAND() * 5000) AS INT64) AS shares,
  CAST(FLOOR(20 + RAND() * 1000) AS INT64) AS comments,
  CAST(FLOOR(5000 + RAND() * 2000000) AS INT64) AS impressions
FROM
  UNNEST(GENERATE_ARRAY(1, 2000)) AS id,
  (
    SELECT
      ['Twitter', 'Instagram', 'Facebook', 'TikTok'] AS platform,
      ['Match Day', 'Player Interview', 'Training', 'Sponsor Announcement'] AS post_category
  ) AS d;


-- ====================================================================================
-- TABLE 12: player_contracts (replaces player_transfers_and_contracts)
-- ====================================================================================
CREATE OR REPLACE TABLE `football_agent.player_contracts` AS
SELECT
  p.player_id AS contract_id,
  p.player_id,
  p.join_date AS contract_start_date,
  DATE_ADD(p.join_date, INTERVAL CAST(3 + FLOOR(RAND() * 3) AS INT64) YEAR) AS contract_end_date,
  ['£15k-£30k', '£30k-£50k', '£50k-£80k', '£80k-£120k'][OFFSET(CAST(FLOOR(RAND() * 4) AS INT64))] AS weekly_salary_band
FROM `football_agent.players` AS p;


-- ====================================================================================
-- TABLE 13: matchday_concession_sales (depends on matches)
-- ====================================================================================
CREATE OR REPLACE TABLE `football_agent.matchday_concession_sales` AS
WITH
  HomeMatches AS (
    SELECT match_id, match_date FROM `football_agent.matches` WHERE home_team = 'Brighton & Hove Albion'
  ),
  Transactions AS (
    SELECT
      hm.match_id,
      hm.match_date,
      p.*
    FROM HomeMatches hm, UNNEST(GENERATE_ARRAY(1, 5000)) as t, -- 5000 transactions per home game
    (
      SELECT
        ['Steak Pie', 'Hot Dog', 'Lager', 'Soda', 'Crisps'] AS name,
        [4.50, 5.00, 5.50, 3.00, 2.00] AS price
    ) AS p
  )
SELECT
  GENERATE_UUID() AS concession_sale_id,
  t.match_id,
  ['North Stand', 'East Stand', 'South Stand', 'West Stand'][OFFSET(CAST(FLOOR(RAND() * 4) AS INT64))] AS kiosk_location,
  t.name[OFFSET(CAST(FLOOR(RAND() * 5) AS INT64))] AS product_name,
  1 + CAST(FLOOR(RAND() * 2) AS INT64) AS quantity,
  TIMESTAMP_ADD(TIMESTAMP(DATETIME(t.match_date, TIME(15, 0, 0))), INTERVAL CAST(FLOOR(RAND() * 180) - 90 AS INT64) MINUTE) AS sale_timestamp
FROM Transactions t;


-- ====================================================================================
-- TABLE 14: scouting_reports (depends on employees)
-- ====================================================================================
CREATE OR REPLACE TABLE `football_agent.scouting_reports` AS
WITH
  Scouts AS (
    SELECT employee_id FROM `football_agent.employees` WHERE job_title = 'First Team Scout'
  )
SELECT
  GENERATE_UUID() AS report_id,
  d.first_names[OFFSET(CAST(FLOOR(RAND() * ARRAY_LENGTH(d.first_names)) AS INT64))] || ' ' || d.last_names[OFFSET(CAST(FLOOR(RAND() * ARRAY_LENGTH(d.last_names)) AS INT64))] AS scouted_player_name,
  d.clubs[OFFSET(CAST(FLOOR(RAND() * ARRAY_LENGTH(d.clubs)) AS INT64))] AS scouted_player_club,
  (SELECT employee_id FROM Scouts ORDER BY RAND() LIMIT 1) AS scout_employee_id,
  DATE_SUB(CURRENT_DATE(), INTERVAL CAST(FLOOR(5 + RAND() * 500) AS INT64) DAY) AS report_date,
  CAST(65 + FLOOR(RAND() * 30) AS INT64) AS overall_rating,
  CASE
    WHEN RAND() < 0.3 THEN 'Sign Immediately'
    WHEN RAND() < 0.7 THEN 'Monitor Closely'
    ELSE 'Reject'
  END AS recommendation
FROM
  UNNEST(GENERATE_ARRAY(1, 200)) AS id,
  (
    SELECT
      ['Liam', 'Noah', 'Oliver', 'James', 'Elijah'] AS first_names,
      ['Müller', 'Schmidt', 'Schneider', 'Fischer', 'Weber'] AS last_names,
      ['Ajax', 'Benfica', 'RB Leipzig', 'Lyon', 'Santos'] AS clubs
  ) AS d;


-- ====================================================================================
-- NEW TABLES START HERE
-- ====================================================================================


-- ====================================================================================
-- TABLE 15: player_transfers (new table, depends on players)
-- ====================================================================================
CREATE OR REPLACE TABLE `football_agent.player_transfers` AS
WITH
  PreviousClubs AS (
    SELECT ['Independiente del Valle', 'Rosario Central', 'Club Libertad', 'FC Nordsjælland', 'Villarreal CF'] AS clubs
  )
SELECT
  GENERATE_UUID() AS transfer_id,
  p.player_id,
  p.join_date AS transfer_date,
  'in' AS transfer_direction,
  c.clubs[OFFSET(CAST(FLOOR(RAND() * ARRAY_LENGTH(c.clubs)) AS INT64))] AS from_club,
  'Brighton & Hove Albion' AS to_club,
  CAST(1000000 + FLOOR(RAND() * 20000000) AS NUMERIC) AS transfer_fee_gbp
FROM `football_agent.players` p, PreviousClubs c
WHERE p.first_name NOT IN ('Lewis', 'Solly'); -- Exclude likely academy graduates


-- ====================================================================================
-- TABLE 16: player_valuations (new table, depends on players)
-- ====================================================================================
CREATE OR REPLACE TABLE `football_agent.player_valuations` AS
WITH
  ValuationPoints AS (
    SELECT player_id, join_date FROM `football_agent.players`
    UNION ALL
    SELECT player_id, DATE_ADD(join_date, INTERVAL 1 YEAR) FROM `football_agent.players`
    UNION ALL
    SELECT player_id, DATE_ADD(join_date, INTERVAL 2 YEAR) FROM `football_agent.players`
  )
SELECT
  GENERATE_UUID() AS valuation_id,
  vp.player_id,
  vp.join_date AS valuation_date,
  -- Simulate value increasing over time
  CAST(
    (10000000 + FLOOR(RAND() * 30000000)) * (1 + (DATE_DIFF(vp.join_date, p.join_date, YEAR) * (0.5 + RAND())))
  AS NUMERIC) AS market_value_gbp
FROM ValuationPoints vp
JOIN `football_agent.players` p ON vp.player_id = p.player_id;


-- ====================================================================================
-- TABLE 17: club_finances (new table, depends on player_transfers)
-- ====================================================================================
CREATE OR REPLACE TABLE `football_agent.club_finances` AS
WITH
  Seasons AS (
    SELECT '2023-2024' AS season
  ),
  TransferIncome AS (
    -- Simulate major player sales like Caicedo and Mac Allister
    SELECT '2023-2024' as season, 115000000 + 55000000 AS total_income
  ),
  TransferExpenditure AS (
    SELECT
      '2023-2024' as season,
      SUM(transfer_fee_gbp) AS total_expenditure
    FROM `football_agent.player_transfers`
    WHERE EXTRACT(YEAR FROM transfer_date) IN (2023, 2024)
  )
SELECT
  s.season as season_id,
  s.season,
  350000000 AS total_revenue_gbp,
  120000000 AS wage_bill_gbp,
  te.total_expenditure AS transfer_expenditure_gbp,
  ti.total_income AS transfer_income_gbp,
  (350000000 - 120000000 - te.total_expenditure + ti.total_income) AS profit_loss_gbp
FROM Seasons s
JOIN TransferIncome ti ON s.season = ti.season
JOIN TransferExpenditure te ON s.season = te.season;

-- ====================================================================================
-- TABLE 18: supplier_contracts (new table)
-- ====================================================================================
CREATE OR REPLACE TABLE `football_agent.supplier_contracts` AS
WITH
  Suppliers AS (
    SELECT 'VenuePro Catering' AS name, 'Catering' AS service, 5000000 AS base_cost UNION ALL
    SELECT 'SafeGuard Security' AS name, 'Stadium Security' AS service, 3000000 AS base_cost UNION ALL
    SELECT 'Nike' AS name, 'Kit Manufacturer' AS service, 8000000 AS base_cost UNION ALL
    SELECT 'Global Travel Partners' AS name, 'Team Travel' AS service, 2500000 AS base_cost UNION ALL
    SELECT 'TechSolutions Ltd' AS name, 'IT Support' AS service, 1500000 AS base_cost
  )
SELECT
  7000 + ROW_NUMBER() OVER() AS contract_id,
  s.name AS supplier_name,
  s.service AS service_provided,
  DATE_SUB(CURRENT_DATE(), INTERVAL CAST(FLOOR(1 + RAND() * 4) * 365 AS INT64) DAY) AS contract_start_date,
  DATE_ADD(CURRENT_DATE(), INTERVAL CAST(FLOOR(1 + RAND() * 3) * 365 AS INT64) DAY) AS contract_end_date,
  CAST(s.base_cost * (0.8 + RAND() * 0.4) AS NUMERIC) AS annual_cost_gbp
FROM Suppliers s;