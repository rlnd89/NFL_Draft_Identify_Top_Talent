/****** Script for SelectTopNRows command from SSMS  ******/
SELECT s1.rnd, s1.success, s2.bust, round(cast(s1.success as float)/(cast(s1.success as float)+cast(s2.bust as float)),2) success_rate
FROM
(SELECT rnd, count(success) success
  FROM [DataRobot].[dbo].[BASELINE_player_stats_final_raw_pg]
  where success='success' and rnd is not null
  group by rnd
  --order by rnd
  )s1
 INNER JOIN
  (
  SELECT rnd, count(success) bust
  FROM [DataRobot].[dbo].[BASELINE_player_stats_final_raw_pg]
  where success='bust' and rnd is not null
  group by rnd
  --order by rnd
  )s2
  ON s1.rnd=s2.rnd
  order by rnd

 -- select year, count(*) from nfl_draft group by year order by 1

select s1.rnd, s1.success, s2.bust, round(cast(s1.success as float)/(cast(s1.success as float)+cast(s2.bust as float)),2) success_rate
from(
  select rnd, count(success) success
  from
  (
  select rnd, case when av<exp_av then 'bust' else 'success' end success
  from nfl_draft where Year<2016)s
  where success='success'
   group by rnd
   )s1
inner join
(
  select rnd, count(success) bust
  from
  (
  select rnd, case when av<exp_av then 'bust' else 'success' end success
  from nfl_draft where year<2016)s
   where success='bust' 
   group by rnd
)s2
  ON s1.rnd=s2.rnd
  order by rnd