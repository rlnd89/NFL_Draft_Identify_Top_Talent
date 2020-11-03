USE DataRobot
GO


-- Delete tables if exist
if exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'player_stats_raw_total_draft_year') drop table player_stats_raw_total_draft_year;
if exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'player_stats_raw_total_prior') drop table player_stats_raw_total_prior;
if exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'player_stats_raw_avg_pg_draft_year') drop table player_stats_raw_avg_pg_draft_year;
if exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'player_stats_raw_avg_pg_prior') drop table player_stats_raw_avg_pg_prior;
if exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'player_stats_normalized_avg_pg_draft_year') drop table player_stats_normalized_avg_pg_draft_year;
if exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'player_stats_normalized_avg_pg_prior') drop table player_stats_normalized_avg_pg_prior;
if exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'player_stats_raw_pg_combined') drop table player_stats_raw_pg_combined;
if exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'player_stats_normalized_pg_combined') drop table player_stats_normalized_pg_combined;
if exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'player_stats_final_raw_pg') drop table player_stats_final_raw_pg;
if exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'player_stats_final_normalized_pg') drop table player_stats_final_normalized_pg;
GO

-- Create raw totals prior career table
SELECT
s.Year,
s.Combine_Year,
s.NCAA_Link,
s.Player,
s.School,
s.Off_Rk,
s.Def_Rk,
s.OSRS,
s.DSRS,
s.SRS,
s.Conf,
coalesce(s.Power_Conf,0) Power_Conf,
s.Class,
s.Pos,
coalesce(s.G,0) Games,
s.Pass_Att,
s.Pass_Cmp,
s.Pass_Pct,
s.Pass_Yds,
s.Pass_TD,
s.Pass_Int,
s.Pass_YA,
s.Pass_AYA,
s.Pass_Rate,
s.Rush_Att,
s.Rush_Yds,
s.Rush_Avg,
s.Rush_TD,
s.Rec,
s.Rec_Yds,
s.Rec_TD,
s.Scrim_Yds,
s.Scrim_TD,
s.Kick_FGA,
s.Kick_FGM,
s.Kick_FG_pct,
s.Kick_XPA,
s.Kick_XPM,
s.Kick_XP_pct,
s.Kick_ret_TD + s.Punt_ret_TD Non_offensive_TD,
s.Def_Solo_Tackles,
s.Def_Ast_Tackles,
s.Def_Tot_Tackles,
s.Def_Loss_Tackles,
s.Def_Sk,
s.Def_Int,
s.Def_Int_PD,
s.Def_FF,
s.Def_FR,
s.Def_Int_TD,
s.Def_TD_Fumbles,
s.Dominator_Rating,
s.Team_Pass_Att,
s.Team_Rush_Att,
s.Off_Plays,
s.Opp_Pass_Att,
s.Opp_Rush_Att,
s.Opp_Off_Plays
INTO player_stats_raw_total_prior
FROM
(
SELECT p.*, c.Player, c.Year Combine_Year, od.Rush_Att Team_Rush_Att, od.Pass_Att Team_Pass_Att, od.Off_Plays, od.Opp_Pass_Att, od.Opp_Rush_Att, od.Opp_Off_Plays, od.Off_Rk, od.Def_Rk, r.OSRS, r.DSRS, r.SRS, r.Power_Conf
FROM ncaa_player_stats_clean p
LEFT JOIN nfl_combine c
ON p.NCAA_Link = c.NCAA_Link
LEFT join ncaa_team_offense_defense od
ON p.School = od.School and p.Year = od.Year
LEFT JOIN ncaa_team_ratings r ON p.School = r.School and p.Year=r.Year
WHERE p.Year <> 'Career' AND p.Year IS NOT NULL
)s
WHERE Year+1 <> Combine_year
--AND Player = 'Ryan Tannehill'


-- Create raw totals draft year table
SELECT
s.Year,
s.Combine_Year,
s.NCAA_Link,
s.Player,
s.School,
s.Off_Rk,
s.Def_Rk,
s.OSRS,
s.DSRS,
s.SRS,
s.Conf,
coalesce(s.Power_Conf,0) Power_Conf,
s.Class,
s.Pos,
coalesce(s.G,0) Games,
s.Pass_Att,
s.Pass_Cmp,
s.Pass_Pct,
s.Pass_Yds,
s.Pass_TD,
s.Pass_Int,
s.Pass_YA,
s.Pass_AYA,
s.Pass_Rate,
s.Rush_Att,
s.Rush_Yds,
s.Rush_Avg,
s.Rush_TD,
s.Rec,
s.Rec_Yds,
s.Rec_TD,
s.Scrim_Yds,
s.Scrim_TD,
s.Kick_FGA,
s.Kick_FGM,
s.Kick_FG_pct,
s.Kick_XPA,
s.Kick_XPM,
s.Kick_XP_pct,
s.Kick_ret_TD + s.Punt_ret_TD Non_offensive_TD,
s.Def_Solo_Tackles,
s.Def_Ast_Tackles,
s.Def_Tot_Tackles,
s.Def_Loss_Tackles,
s.Def_Sk,
s.Def_Int,
s.Def_Int_PD,
s.Def_FF,
s.Def_FR,
s.Def_Int_TD,
s.Def_TD_Fumbles,
s.Dominator_Rating,
s.Team_Pass_Att,
s.Team_Rush_Att,
s.Off_Plays,
s.Opp_Pass_Att,
s.Opp_Rush_Att,
s.Opp_Off_Plays
INTO player_stats_raw_total_draft_year
FROM
(
SELECT p.*, c.Player, c.Year Combine_Year, od.Rush_Att Team_Rush_Att, od.Pass_Att Team_Pass_Att, od.Off_Plays, od.Opp_Pass_Att, od.Opp_Rush_Att, od.Opp_Off_Plays, od.Off_Rk, od.Def_Rk, r.OSRS, r.DSRS, r.SRS, r.Power_Conf
FROM ncaa_player_stats_clean p
LEFT JOIN nfl_combine c
ON p.NCAA_Link = c.NCAA_Link
LEFT join ncaa_team_offense_defense od
ON p.School = od.School and p.Year = od.Year
LEFT JOIN ncaa_team_ratings r ON p.School = r.School and p.Year=r.Year
WHERE p.Year <> 'Career' AND p.Year IS NOT NULL
)s
WHERE Year+1 = Combine_year
--AND Player = 'Ryan Tannehill'

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Create per game raw avg draft year table
SELECT 
Year,
Combine_Year,
NCAA_Link,
Player,
School,
Off_Rk,
Def_Rk,
OSRS,
DSRS,
SRS,
Conf,
Power_Conf,
Class,
Pos,
Games,
COALESCE(Pass_Att/NULLIF(Games,0),0) Pass_Att_PG,
COALESCE(Pass_Cmp/NULLIF(Games,0),0) Pass_Cmp_PG,
Pass_Pct,
COALESCE(Pass_Yds/NULLIF(Games,0),0) Pass_Yds_PG,
COALESCE(Pass_TD/NULLIF(Games,0),0) Pass_TD_PG,
COALESCE(Pass_Int/NULLIF(Games,0),0) Pass_Int_PG,
Pass_YA,
Pass_AYA,
Pass_Rate,
COALESCE(Rush_Att/NULLIF(Games,0),0) Rush_Att_PG,
COALESCE(Rush_Yds/NULLIF(Games,0),0) Rush_Yds_PG,
Rush_Avg,
COALESCE(Rush_TD/NULLIF(Games,0),0) Rush_TD_PG,
COALESCE(Rec/NULLIF(Games,0),0) Rec_PG,
COALESCE(Rec_Yds/NULLIF(Games,0),0) Rec_Yds_PG,
COALESCE(Rec_TD/NULLIF(Games,0),0) Rec_TD_PG,
COALESCE(Scrim_Yds/NULLIF(Games,0),0) Scrim_Yds_PG,
COALESCE(Scrim_TD/NULLIF(Games,0),0) Scrim_TD_PG,
COALESCE(Kick_FGA/NULLIF(Games,0),0) Kick_FGA_PG,
COALESCE(Kick_FGM/NULLIF(Games,0),0) Kick_FGM_PG,
Kick_FG_pct,
COALESCE(Kick_XPA/NULLIF(Games,0),0) Kick_XPA_PG,
COALESCE(Kick_XPM/NULLIF(Games,0),0) Kick_XPM_PG,
Kick_XP_pct,
COALESCE(Non_offensive_TD/NULLIF(Games,0),0) Non_offensive_TD_PG,
COALESCE(Def_Solo_Tackles/NULLIF(Games,0),0) Def_Solo_Tackles_PG,
COALESCE(Def_Ast_Tackles/NULLIF(Games,0),0) Def_Ast_Tackles_PG,
COALESCE(Def_Tot_Tackles/NULLIF(Games,0),0) Def_Tot_Tackles_PG,
COALESCE(Def_Loss_Tackles/NULLIF(Games,0),0) Def_Loss_Tackles_PG,
COALESCE(Def_Sk/NULLIF(Games,0),0) Def_Sk_PG,
COALESCE(Def_Int/NULLIF(Games,0),0) Def_Int_PG,
COALESCE(Def_Int_PD/NULLIF(Games,0),0) Def_PD_PG,
COALESCE(Def_FF/NULLIF(Games,0),0) Def_FF_PG,
COALESCE(Def_FR/NULLIF(Games,0),0) Def_FR_PG,
COALESCE(Def_Int_TD/NULLIF(Games,0),0) Def_Int_TD_PG,
COALESCE(Def_TD_Fumbles/NULLIF(Games,0),0) Def_TD_Fumbles_PG,
Dominator_Rating,
Team_Pass_Att,
Team_Rush_Att,
Off_Plays,
Opp_Pass_Att,
Opp_Rush_Att,
Opp_Off_Plays
INTO player_stats_raw_avg_pg_draft_year
FROM player_stats_raw_total_draft_Year
--where player in('ryan tannehill','calvin johnson','michael crabtree','ezekiel elliott','zane gonzalez','aaron donald')

-- Create per game raw avg prior career table
SELECT
Combine_Year,
NCAA_Link,
Player,
--Games,
coalesce(Pass_Att/NULLIF(Games,0),0) Pass_Att_PG,
coalesce(Pass_Cmp/NULLIF(Games,0),0) Pass_Cmp_PG,
Pass_Pct,
coalesce(Pass_Yds/NULLIF(Games,0),0) Pass_Yds_PG,
coalesce(Pass_TD/NULLIF(Games,0),0) Pass_TD_PG,
coalesce(Pass_Int/NULLIF(Games,0),0) Pass_Int_PG,
Pass_YA,
coalesce((Pass_Yds+20*Pass_TD-45*Pass_Int)/NULLIF(Pass_Att,0),0) Pass_AYA,
coalesce((8.4*Pass_Yds+330*Pass_TD-200*Pass_Int+100*Pass_Cmp)/NULLIF(Pass_Att,0),0) Pass_Rate,
coalesce(Rush_Att/NULLIF(Games,0),0) Rush_Att_PG,
coalesce(Rush_Yds/NULLIF(Games,0),0) Rush_Yds_PG,
Rush_Avg,
coalesce(Rush_TD/NULLIF(Games,0),0) Rush_TD_PG,
coalesce(Rec/NULLIF(Games,0),0) Rec_PG,
coalesce(Rec_Yds/NULLIF(Games,0),0) Rec_Yds_PG,
coalesce(Rec_TD/NULLIF(Games,0),0) Rec_TD_PG,
coalesce(Scrim_Yds/NULLIF(Games,0),0) Scrim_Yds_PG,
coalesce(Scrim_TD/NULLIF(Games,0),0) Scrim_TD_PG,
coalesce(Kick_FGA/NULLIF(Games,0),0) Kick_FGA_PG,
coalesce(Kick_FGM/NULLIF(Games,0),0) Kick_FGM_PG,
Kick_FG_pct,
coalesce(Kick_XPA/NULLIF(Games,0),0) Kick_XPA_PG,
coalesce(Kick_XPM/NULLIF(Games,0),0) Kick_XPM_PG,
Kick_XP_pct,
coalesce(Non_offensive_TD/NULLIF(Games,0),0) Non_offensive_TD_PG,
coalesce(Def_Solo_Tackles/NULLIF(Games,0),0) Def_Solo_Tackles_PG,
coalesce(Def_Ast_Tackles/NULLIF(Games,0),0) Def_Ast_Tackles_PG,
coalesce(Def_Tot_Tackles/NULLIF(Games,0),0) Def_Tot_Tackles_PG,
coalesce(Def_Loss_Tackles/NULLIF(Games,0),0) Def_Loss_Tackles_PG,
coalesce(Def_Sk/NULLIF(Games,0),0) Def_Sk_PG,
coalesce(Def_Int/NULLIF(Games,0),0) Def_Int_PG,
coalesce(Def_Int_PD/NULLIF(Games,0),0) Def_PD_PG,
coalesce(Def_FF/NULLIF(Games,0),0) Def_FF_PG,
coalesce(Def_FR/NULLIF(Games,0),0) Def_FR_PG,
coalesce(Def_Int_TD/NULLIF(Games,0),0) Def_Int_TD_PG,
coalesce(Def_TD_Fumbles/NULLIF(Games,0),0) Def_TD_Fumbles_PG,
Dominator_Rating
INTO player_stats_raw_avg_pg_prior
FROM
(
SELECT
--Year,
Combine_Year,
NCAA_Link,
Player,
--School,
--Off_Rk,
--Def_Rk,
--OSRS,
--DSRS,
--SRS,
--Conf,
--Class,
--Pos,
SUM(Games) Games,
SUM(Pass_Att) Pass_Att,
SUM(Pass_Cmp) Pass_Cmp,
coalesce(SUM(Pass_Cmp)/NULLIF(SUM(Pass_Att),0),0) Pass_Pct,
SUM(Pass_Yds) Pass_Yds,
SUM(Pass_TD) Pass_TD,
SUM(Pass_Int) Pass_Int,
coalesce(SUM(Pass_yds)/NULLIF(SUM(Pass_Att),0),0) Pass_YA,
--Pass_AYA,
--Pass_Rate,
SUM(Rush_Att) Rush_Att,
SUM(Rush_Yds) Rush_Yds,
coalesce(SUM(Rush_Yds)/NULLIF(SUM(Rush_Att),0),0) Rush_Avg,
SUM(Rush_TD) Rush_TD,
SUM(Rec) Rec,
SUM(Rec_Yds) Rec_Yds,
SUM(Rec_TD) Rec_TD,
SUM(Scrim_Yds) Scrim_Yds,
SUM(Scrim_TD) Scrim_TD,
SUM(Kick_FGA) Kick_FGA,
SUM(Kick_FGM) Kick_FGM,
coalesce(SUM(Kick_FGM)/NULLIF(SUM(Kick_FGA),0),0) Kick_FG_pct,
SUM(Kick_XPA) Kick_XPA,
SUM(Kick_XPM) Kick_XPM,
coalesce(SUM(Kick_XPM)/NULLIF(SUM(Kick_XPA),0),0) Kick_XP_pct,
SUM(Non_offensive_TD) Non_offensive_TD,
SUM(Def_Solo_Tackles) Def_Solo_Tackles,
SUM(Def_Ast_Tackles) Def_Ast_Tackles,
SUM(Def_Tot_Tackles) Def_Tot_Tackles,
SUM(Def_Loss_Tackles) Def_Loss_Tackles,
SUM(Def_Sk) Def_Sk,
SUM(Def_Int) Def_Int,
SUM(Def_Int_PD) Def_Int_PD,
SUM(Def_FF) Def_FF,
SUM(Def_FR) Def_FR,
SUM(Def_Int_TD) Def_Int_TD,
SUM(Def_TD_Fumbles) Def_TD_Fumbles,
AVG(Dominator_Rating) Dominator_Rating
--Team_Pass_Att,
--Team_Rush_Att,
--Off_Plays,
--Opp_Pass_Att,
--Opp_Rush_Att,
--Opp_Off_Plays
FROM player_stats_raw_total_prior
--where player in('ryan tannehill','calvin johnson','michael crabtree','ezekiel elliott','zane gonzalez','aaron donald')
GROUP BY Combine_Year, NCAA_Link, Player
)s

--------------------------------------------------------------------------------------------------------------------------------------------

-- Create per game normalized avg draft year table
SELECT 
Year,
Combine_Year,
NCAA_Link,
Player,
School,
Off_Rk,
Def_Rk,
OSRS,
DSRS,
SRS,
Conf,
Power_Conf,
Class,
Pos,
Games,
coalesce(Pass_Att/NULLIF(ROUND(Team_Pass_Att*Games,0),0)*30,0) Adj_Pass_Att_PG,
coalesce(Pass_Cmp/NULLIF(ROUND(Team_Pass_Att*Games,0),0)*30,0) Adj_Pass_Cmp_PG,
Pass_Pct,
coalesce((Pass_Att/NULLIF(ROUND(Team_Pass_Att*Games,0),0)*30)*Pass_YA,0) Adj_Pass_Yds_PG,
coalesce((Pass_TD/NULLIF(Pass_Att,0))*(Pass_Att/NULLIF(ROUND(Team_Pass_Att*Games,0),0)*30),0) Adj_Pass_TD_PG,
coalesce((Pass_Int/NULLIF(Pass_Att,0))*(Pass_Att/NULLIF(ROUND(Team_Pass_Att*Games,0),0)*30),0) Adj_Pass_Int_PG,
Pass_YA,
Pass_AYA,
Pass_Rate,
coalesce(Rush_Att/NULLIF(ROUND(Team_Rush_Att*Games,0),0)*35,0) Adj_Rush_Att_PG,
coalesce((Rush_Att/NULLIF(ROUND(Team_Rush_Att*Games,0),0)*35)*Rush_Avg,0) Adj_Rush_Yds_PG,
Rush_Avg,
coalesce(Rush_TD/NULLIF(Rush_Att,0)*(Rush_Att/NULLIF(ROUND(Team_Rush_Att*Games,0),0)*35),0) Adj_Rush_TD_PG,
coalesce(30/NULLIF(ROUND(Team_Pass_Att*Games,0),0)*Rec,0) Adj_Rec_PG,
coalesce(Rec_Yds/NULLIF(Rec,0)*(30/NULLIF(ROUND(Team_Pass_Att*Games,0),0)*Rec),0) Adj_Rec_Yds_PG,
coalesce(Rec_TD/NULLIF(Rec,0)*(30/NULLIF(ROUND(Team_Pass_Att*Games,0),0)*Rec),0) Adj_Rec_TD_PG,
coalesce(((Rush_Att/NULLIF(ROUND(Team_Rush_Att*Games,0),0)*35)*Rush_Avg) + (Rec_Yds/NULLIF(Rec,0)*(30/NULLIF(ROUND(Team_Pass_Att*Games,0),0)*Rec)),0) Adj_Scrim_Yds_PG,
coalesce((Rush_TD/NULLIF(Rush_Att,0)*(Rush_Att/NULLIF(ROUND(Team_Rush_Att*Games,0),0)*35)) + (Rec_TD/NULLIF(Rec,0)*(30/NULLIF(ROUND(Team_Pass_Att*Games,0),0)*Rec)),0) Adj_Scrim_TD_PG,
coalesce(Kick_FGA/NULLIF(Games,0),0) Kick_FGA_PG,
coalesce(Kick_FGM/NULLIF(Games,0),0) Kick_FGM_PG,
Kick_FG_pct,
coalesce(Kick_XPA/NULLIF(Games,0),0) Kick_XPA_PG,
coalesce(Kick_XPM/NULLIF(Games,0),0) Kick_XPM_PG,
Kick_XP_pct,
coalesce(Non_offensive_TD/NULLIF(Games,0),0) Non_offensive_TD_PG,
coalesce(Def_Solo_Tackles/NULLIF(ROUND(Opp_Off_Plays*Games,0),0)*65,0) Adj_Def_Solo_Tackles_PG,
coalesce(Def_Ast_Tackles/NULLIF(ROUND(Opp_Off_Plays*Games,0),0)*65,0) Adj_Def_Ast_Tackles_PG,
coalesce(Def_Tot_Tackles/NULLIF(ROUND(Opp_Off_Plays*Games,0),0)*65,0) Adj_Def_Tot_Tackles_PG,
coalesce(Def_Loss_Tackles/NULLIF(ROUND(Opp_Off_Plays*Games,0),0)*65,0) Adj_Def_Loss_Tackles_PG,
coalesce(Def_Sk/NULLIF(ROUND(Opp_Pass_Att*Games,0),0)*30,0) Adj_Def_Sk_PG,
coalesce(Def_Int/NULLIF(ROUND(Opp_Pass_Att*Games,0),0)*30,0) Adj_Def_Int_PG,
coalesce(Def_Int_PD/NULLIF(ROUND(Opp_Pass_Att*Games,0),0)*30,0) Adj_Def_PD_PG,
coalesce(Def_FF/NULLIF(ROUND(Opp_Off_Plays*Games,0),0)*65,0) Adj_Def_FF_PG,
coalesce(Def_FR/NULLIF(ROUND(Opp_Off_Plays*Games,0),0)*65,0) Adj_Def_FR_PG,
coalesce(Def_Int_TD/NULLIF(ROUND(Opp_Pass_Att*Games,0),0)*30,0) Adj_Def_Int_TD_PG,
coalesce(Def_TD_Fumbles/NULLIF(ROUND(Opp_Off_Plays*Games,0),0)*65,0) Adj_Def_TD_Fumbles_PG,
Dominator_Rating,
Team_Pass_Att,
Team_Rush_Att,
Off_Plays,
Opp_Pass_Att,
Opp_Rush_Att,
Opp_Off_Plays
INTO player_stats_normalized_avg_pg_draft_year
FROM player_stats_raw_total_draft_Year
--where player in('ryan tannehill','calvin johnson','michael crabtree','ezekiel elliott','zane gonzalez','aaron donald','patrick willis')

----------------------------------------------------------------------------------------------------------------------------------------------------

-- Create per game normalized avg prior career table
SELECT 
s.Combine_Year,
s.NCAA_Link,
s.Player,
--School,
--Off_Rk,
--Def_Rk,
--OSRS,
--DSRS,
--SRS,
--Conf,
--Class,
--Pos,
--Games,
AVG(s.Adj_Pass_Att_PG) Adj_Pass_Att_PG,
AVG(s.Adj_Pass_Cmp_PG) Adj_Pass_Cmp_PG,
AVG(s.Pass_Pct) Pass_Pct,
AVG(s.Adj_Pass_Yds_PG) Adj_Pass_Yds_PG,
AVG(s.Adj_Pass_TD_PG) Adj_Pass_TD_PG,
AVG(s.Adj_Pass_Int_PG) Adj_Pass_Int_PG,
AVG(s.Pass_YA) Pass_YA,
AVG(s.Pass_AYA) Pass_AYA,
AVG(s.Pass_Rate) Pass_Rate,
AVG(s.Adj_Rush_Att_PG) Adj_Rush_Att_PG,
AVG(s.Adj_Rush_Yds_PG) Adj_Rush_Yds_PG,
AVG(s.Rush_Avg) Rush_Avg,
AVG(s.Adj_Rush_TD_PG) Adj_Rush_TD_PG,
AVG(s.Adj_Rec_PG) Adj_Rec_PG,
AVG(s.Adj_Rec_Yds_PG) Adj_Rec_Yds_PG,
AVG(s.Adj_Rec_TD_PG) Adj_Rec_TD_PG,
AVG(s.Adj_Scrim_Yds_PG) Adj_Scrim_Yds_PG,
AVG(s.Adj_Scrim_TD_PG) Adj_Scrim_TD_PG,
AVG(s.Kick_FGA_PG) Kick_FGA_PG,
AVG(s.Kick_FGM_PG) Kick_FGM_PG,
AVG(s.Kick_FG_pct) Kick_FG_pct,
AVG(s.Kick_XPA_PG) Kick_XPA_PG,
AVG(s.Kick_XPM_PG) Kick_XPM_PG,
AVG(s.Kick_XP_pct) Kick_XP_pct,
AVG(s.Non_offensive_TD_PG) Non_offensive_TD_PG,
AVG(s.Adj_Def_Solo_Tackles_PG) Adj_Def_Solo_Tackles_PG,
AVG(s.Adj_Def_Ast_Tackles_PG) Adj_Def_Ast_Tackles_PG,
AVG(s.Adj_Def_Tot_Tackles_PG) Adj_Def_Tot_Tackles_PG,
AVG(s.Adj_Def_Loss_Tackles_PG) Adj_Def_Loss_Tackles_PG,
AVG(s.Adj_Def_Sk_PG) Adj_Def_Sk_PG,
AVG(s.Adj_Def_Int_PG) Adj_Def_Int_PG,
AVG(s.Adj_Def_PD_PG) Adj_Def_PD_PG,
AVG(s.Adj_Def_FF_PG) Adj_Def_FF_PG,
AVG(s.Adj_Def_FR_PG) Adj_Def_FR_PG,
AVG(s.Adj_Def_Int_TD_PG) Adj_Def_Int_TD_PG,
AVG(s.Adj_Def_TD_Fumbles_PG) Adj_Def_TD_Fumbles_PG,
AVG(s.Dominator_Rating) Dominator_Rating
--Team_Pass_Att,
--Team_Rush_Att,
--Off_Plays,
--Opp_Pass_Att,
--Opp_Rush_Att,
--Opp_Off_Plays
INTO player_stats_normalized_avg_pg_prior
FROM
(
SELECT 
Year,
Combine_Year,
NCAA_Link,
Player,
School,
Off_Rk,
Def_Rk,
OSRS,
DSRS,
SRS,
Conf,
Power_Conf,
Class,
Pos,
Games,
coalesce(Pass_Att/NULLIF(ROUND(Team_Pass_Att*Games,0),0)*30,0) Adj_Pass_Att_PG,
coalesce(Pass_Cmp/NULLIF(ROUND(Team_Pass_Att*Games,0),0)*30,0) Adj_Pass_Cmp_PG,
Pass_Pct,
coalesce((Pass_Att/NULLIF(ROUND(Team_Pass_Att*Games,0),0)*30)*Pass_YA,0) Adj_Pass_Yds_PG,
coalesce((Pass_TD/NULLIF(Pass_Att,0))*(Pass_Att/NULLIF(ROUND(Team_Pass_Att*Games,0),0)*30),0) Adj_Pass_TD_PG,
coalesce((Pass_Int/NULLIF(Pass_Att,0))*(Pass_Att/NULLIF(ROUND(Team_Pass_Att*Games,0),0)*30),0) Adj_Pass_Int_PG,
Pass_YA,
Pass_AYA,
Pass_Rate,
coalesce(Rush_Att/NULLIF(ROUND(Team_Rush_Att*Games,0),0)*35,0) Adj_Rush_Att_PG,
coalesce((Rush_Att/NULLIF(ROUND(Team_Rush_Att*Games,0),0)*35)*Rush_Avg,0) Adj_Rush_Yds_PG,
Rush_Avg,
coalesce(Rush_TD/NULLIF(Rush_Att,0)*(Rush_Att/NULLIF(ROUND(Team_Rush_Att*Games,0),0)*35),0) Adj_Rush_TD_PG,
coalesce(30/NULLIF(ROUND(Team_Pass_Att*Games,0),0)*Rec,0) Adj_Rec_PG,
coalesce(Rec_Yds/NULLIF(Rec,0)*(30/NULLIF(ROUND(Team_Pass_Att*Games,0),0)*Rec),0) Adj_Rec_Yds_PG,
coalesce(Rec_TD/NULLIF(Rec,0)*(30/NULLIF(ROUND(Team_Pass_Att*Games,0),0)*Rec),0) Adj_Rec_TD_PG,
coalesce(((Rush_Att/NULLIF(ROUND(Team_Rush_Att*Games,0),0)*35)*Rush_Avg) + (Rec_Yds/NULLIF(Rec,0)*(30/NULLIF(ROUND(Team_Pass_Att*Games,0),0)*Rec)),0) Adj_Scrim_Yds_PG,
coalesce((Rush_TD/NULLIF(Rush_Att,0)*(Rush_Att/NULLIF(ROUND(Team_Rush_Att*Games,0),0)*35)) + (Rec_TD/NULLIF(Rec,0)*(30/NULLIF(ROUND(Team_Pass_Att*Games,0),0)*Rec)),0) Adj_Scrim_TD_PG,
coalesce(Kick_FGA/NULLIF(Games,0),0) Kick_FGA_PG,
coalesce(Kick_FGM/NULLIF(Games,0),0) Kick_FGM_PG,
Kick_FG_pct,
coalesce(Kick_XPA/NULLIF(Games,0),0) Kick_XPA_PG,
coalesce(Kick_XPM/NULLIF(Games,0),0) Kick_XPM_PG,
Kick_XP_pct,
coalesce(Non_offensive_TD/NULLIF(Games,0),0) Non_offensive_TD_PG,
coalesce(Def_Solo_Tackles/NULLIF(ROUND(Opp_Off_Plays*Games,0),0)*65,0) Adj_Def_Solo_Tackles_PG,
coalesce(Def_Ast_Tackles/NULLIF(ROUND(Opp_Off_Plays*Games,0),0)*65,0) Adj_Def_Ast_Tackles_PG,
coalesce(Def_Tot_Tackles/NULLIF(ROUND(Opp_Off_Plays*Games,0),0)*65,0) Adj_Def_Tot_Tackles_PG,
coalesce(Def_Loss_Tackles/NULLIF(ROUND(Opp_Off_Plays*Games,0),0)*65,0) Adj_Def_Loss_Tackles_PG,
coalesce(Def_Sk/NULLIF(ROUND(Opp_Pass_Att*Games,0),0)*30,0) Adj_Def_Sk_PG,
coalesce(Def_Int/NULLIF(ROUND(Opp_Pass_Att*Games,0),0)*30,0) Adj_Def_Int_PG,
coalesce(Def_Int_PD/NULLIF(ROUND(Opp_Pass_Att*Games,0),0)*30,0) Adj_Def_PD_PG,
coalesce(Def_FF/NULLIF(ROUND(Opp_Off_Plays*Games,0),0)*65,0) Adj_Def_FF_PG,
coalesce(Def_FR/NULLIF(ROUND(Opp_Off_Plays*Games,0),0)*65,0) Adj_Def_FR_PG,
coalesce(Def_Int_TD/NULLIF(ROUND(Opp_Pass_Att*Games,0),0)*30,0) Adj_Def_Int_TD_PG,
coalesce(Def_TD_Fumbles/NULLIF(ROUND(Opp_Off_Plays*Games,0),0)*65,0) Adj_Def_TD_Fumbles_PG,
Dominator_Rating,
Team_Pass_Att,
Team_Rush_Att,
Off_Plays,
Opp_Pass_Att,
Opp_Rush_Att,
Opp_Off_Plays
FROM player_stats_raw_total_prior
)s
--where player in('ryan tannehill','calvin johnson','michael crabtree','ezekiel elliott','zane gonzalez','aaron donald','patrick willis')
GROUP BY s.NCAA_Link, s.Combine_Year, s.Player

--------------------------------------------------------------------------------------------------------------------------------------------

-- Create combined raw per game table
SELECT
p.Combine_Year,
p.NCAA_Link,
p.Player,
d.Class,
d.Pos,
d.School,
d.Conf,
d.Power_Conf,
d.Off_Rk,
d.Def_Rk,
d.OSRS,
d.DSRS,
d.SRS,
p.Pass_Att_PG Pass_Att_PG_Prior,
d.Pass_Att_PG Pass_Att_PG_Draft,
p.Pass_Cmp_PG Pass_Cmp_PG_Prior,
d.Pass_Cmp_PG Pass_Cmp_PG_Draft,
p.Pass_Pct Pass_Pct_Prior,
d.Pass_Pct Pass_Pct_Draft,
p.Pass_Yds_PG Pass_Yds_PG_Prior,
d.Pass_Yds_PG Pass_Yds_PG_Draft,
p.Pass_TD_PG Pass_TD_PG_Prior,
d.Pass_TD_PG Pass_TD_PG_Draft,
p.Pass_Int_PG Pass_Int_PG_Prior,
d.Pass_Int_PG Pass_Int_PG_Draft,
p.Pass_YA Pass_YA_Prior,
d.Pass_YA Pass_YA_Draft,
p.Pass_AYA Pass_AYA_Prior,
d.Pass_AYA Pass_AYA_Draft,
p.Pass_Rate Pass_Rate_Prior,
d.Pass_Rate Pass_Rate_Draft,
p.Rush_Att_PG Rush_Att_PG_Prior,
d.Rush_Att_PG Rush_Att_PG_Draft,
p.Rush_Yds_PG Rush_Yds_PG_Prior,
d.Rush_Yds_PG Rush_Yds_PG_Draft,
p.Rush_Avg Rush_Avg_Prior,
d.Rush_Avg Rush_Avg_Draft,
p.Rush_TD_PG Rush_TD_PG_Prior,
d.Rush_TD_PG Rush_TD_PG_Draft,
p.Rec_PG Rec_PG_Prior,
d.Rec_PG Rec_PG_Draft,
p.Rec_Yds_PG Rec_Yds_PG_Prior,
d.Rec_Yds_PG Rec_Yds_PG_Draft,
p.Rec_TD_PG Rec_TD_PG_Prior,
d.Rec_TD_PG Rec_TD_PG_Draft,
p.Scrim_Yds_PG Scrim_Yds_PG_Prior,
d.Scrim_Yds_PG Scrim_Yds_PG_Draft,
p.Scrim_TD_PG Scrim_TD_PG_Prior,
d.Scrim_TD_PG Scrim_TD_PG_Draft,
p.Kick_FGA_PG Kick_FGA_PG_Prior,
d.Kick_FGA_PG Kick_FGA_PG_Draft,
p.Kick_FGM_PG Kick_FGM_PG_Prior,
d.Kick_FGM_PG Kick_FGM_PG_Draft,
p.Kick_FG_pct Kick_FG_pct_Prior,
d.Kick_FG_pct Kick_FG_pct_Draft,
p.Kick_XPA_PG Kick_XPA_PG_Prior,
d.Kick_XPA_PG Kick_XPA_PG_Draft,
p.Kick_XPM_PG Kick_XPM_PG_Prior,
d.Kick_XPM_PG Kick_XPM_PG_Draft,
p.Kick_XP_pct Kick_XP_pct_Prior,
d.Kick_XP_pct Kick_XP_pct_Draft,
p.Non_offensive_TD_PG Non_offensive_TD_PG_Prior,
d.Non_offensive_TD_PG Non_offensive_TD_PG_Draft,
p.Def_Solo_Tackles_PG Def_Solo_Tackles_PG_Prior,
d.Def_Solo_Tackles_PG Def_Solo_Tackles_PG_Draft,
p.Def_Ast_Tackles_PG Def_Ast_Tackles_PG_Prior,
d.Def_Ast_Tackles_PG Def_Ast_Tackles_PG_Draft,
p.Def_Tot_Tackles_PG Def_Tot_Tackles_PG_Prior,
d.Def_Tot_Tackles_PG Def_Tot_Tackles_PG_Draft,
p.Def_Loss_Tackles_PG Def_Loss_Tackles_PG_Prior,
d.Def_Loss_Tackles_PG Def_Loss_Tackles_PG_Draft,
p.Def_Sk_PG Def_Sk_PG_Prior,
d.Def_Sk_PG Def_Sk_PG_Draft,
p.Def_Int_PG Def_Int_PG_Prior,
d.Def_Int_PG Def_Int_PG_Draft,
p.Def_PD_PG Def_PD_PG_Prior,
d.Def_PD_PG Def_PD_PG_Draft,
p.Def_FF_PG Def_FF_PG_Prior,
d.Def_FF_PG Def_FF_PG_Draft,
p.Def_FR_PG Def_FR_PG_Prior,
d.Def_FR_PG Def_FR_PG_Draft,
p.Def_Int_TD_PG Def_Int_TD_PG_Prior,
d.Def_Int_TD_PG Def_Int_TD_PG_Draft,
p.Def_TD_Fumbles_PG Def_TD_Fumbles_PG_Prior,
d.Def_TD_Fumbles_PG Def_TD_Fumbles_PG_Draft,
p.Dominator_Rating Dominator_Rating_Prior,
d.Dominator_Rating Dominator_Rating_Draft
INTO player_stats_raw_pg_combined
FROM player_stats_raw_avg_pg_prior p
INNER JOIN player_stats_raw_avg_pg_draft_year d
ON p.NCAA_Link = d.NCAA_Link AND p.Combine_Year = d.Combine_Year AND p.Player = d.Player
--where p.player in('ryan tannehill','calvin johnson','michael crabtree','ezekiel elliott','zane gonzalez','aaron donald','patrick willis')


-- Create combined normalized per game table
SELECT
p.Combine_Year,
p.NCAA_Link,
p.Player,
d.Class,
d.Pos,
d.School,
d.Conf,
d.Power_Conf,
d.Off_Rk,
d.Def_Rk,
d.OSRS,
d.DSRS,
d.SRS,
p.Adj_Pass_Att_PG Adj_Pass_Att_PG_Prior,
d.Adj_Pass_Att_PG Adj_Pass_Att_PG_Draft,
p.Adj_Pass_Cmp_PG Adj_Pass_Cmp_PG_Prior,
d.Adj_Pass_Cmp_PG Adj_Pass_Cmp_PG_Draft,
p.Pass_Pct Pass_Pct_Prior,
d.Pass_Pct Pass_Pct_Draft,
p.Adj_Pass_Yds_PG Adj_Pass_Yds_PG_Prior,
d.Adj_Pass_Yds_PG Adj_Pass_Yds_PG_Draft,
p.Adj_Pass_TD_PG Adj_Pass_TD_PG_Prior,
d.Adj_Pass_TD_PG Adj_Pass_TD_PG_Draft,
p.Adj_Pass_Int_PG Adj_Pass_Int_PG_Prior,
d.Adj_Pass_Int_PG Adj_Pass_Int_PG_Draft,
p.Pass_YA Pass_YA_Prior,
d.Pass_YA Pass_YA_Draft,
p.Pass_AYA Pass_AYA_Prior,
d.Pass_AYA Pass_AYA_Draft,
p.Pass_Rate Pass_Rate_Prior,
d.Pass_Rate Pass_Rate_Draft,
p.Adj_Rush_Att_PG Adj_Rush_Att_PG_Prior,
d.Adj_Rush_Att_PG Adj_Rush_Att_PG_Draft,
p.Adj_Rush_Yds_PG Adj_Rush_Yds_PG_Prior,
d.Adj_Rush_Yds_PG Adj_Rush_Yds_PG_Draft,
p.Rush_Avg Rush_Avg_Prior,
d.Rush_Avg Rush_Avg_Draft,
p.Adj_Rush_TD_PG Adj_Rush_TD_PG_Prior,
d.Adj_Rush_TD_PG Adj_Rush_TD_PG_Draft,
p.Adj_Rec_PG Adj_Rec_PG_Prior,
d.Adj_Rec_PG Adj_Rec_PG_Draft,
p.Adj_Rec_Yds_PG Adj_Rec_Yds_PG_Prior,
d.Adj_Rec_Yds_PG Adj_Rec_Yds_PG_Draft,
p.Adj_Rec_TD_PG Adj_Rec_TD_PG_Prior,
d.Adj_Rec_TD_PG Adj_Rec_TD_PG_Draft,
p.Adj_Scrim_Yds_PG Adj_Scrim_Yds_PG_Prior,
d.Adj_Scrim_Yds_PG Adj_Scrim_Yds_PG_Draft,
p.Adj_Scrim_TD_PG Adj_Scrim_TD_PG_Prior,
d.Adj_Scrim_TD_PG Adj_Scrim_TD_PG_Draft,
p.Kick_FGA_PG Kick_FGA_PG_Prior,
d.Kick_FGA_PG Kick_FGA_PG_Draft,
p.Kick_FGM_PG Kick_FGM_PG_Prior,
d.Kick_FGM_PG Kick_FGM_PG_Draft,
p.Kick_FG_pct Kick_FG_pct_Prior,
d.Kick_FG_pct Kick_FG_pct_Draft,
p.Kick_XPA_PG Kick_XPA_PG_Prior,
d.Kick_XPA_PG Kick_XPA_PG_Draft,
p.Kick_XPM_PG Kick_XPM_PG_Prior,
d.Kick_XPM_PG Kick_XPM_PG_Draft,
p.Kick_XP_pct Kick_XP_pct_Prior,
d.Kick_XP_pct Kick_XP_pct_Draft,
p.Non_offensive_TD_PG Non_offensive_TD_PG_Prior,
d.Non_offensive_TD_PG Non_offensive_TD_PG_Draft,
p.Adj_Def_Solo_Tackles_PG Adj_Def_Solo_Tackles_PG_Prior,
d.Adj_Def_Solo_Tackles_PG Adj_Def_Solo_Tackles_PG_Draft,
p.Adj_Def_Ast_Tackles_PG Adj_Def_Ast_Tackles_PG_Prior,
d.Adj_Def_Ast_Tackles_PG Adj_Def_Ast_Tackles_PG_Draft,
p.Adj_Def_Tot_Tackles_PG Adj_Def_Tot_Tackles_PG_Prior,
d.Adj_Def_Tot_Tackles_PG Adj_Def_Tot_Tackles_PG_Draft,
p.Adj_Def_Loss_Tackles_PG Adj_Def_Loss_Tackles_PG_Prior,
d.Adj_Def_Loss_Tackles_PG Adj_Def_Loss_Tackles_PG_Draft,
p.Adj_Def_Sk_PG Adj_Def_Sk_PG_Prior,
d.Adj_Def_Sk_PG Adj_Def_Sk_PG_Draft,
p.Adj_Def_Int_PG Adj_Def_Int_PG_Prior,
d.Adj_Def_Int_PG Adj_Def_Int_PG_Draft,
p.Adj_Def_PD_PG Adj_Def_PD_PG_Prior,
d.Adj_Def_PD_PG Adj_Def_PD_PG_Draft,
p.Adj_Def_FF_PG Adj_Def_FF_PG_Prior,
d.Adj_Def_FF_PG Adj_Def_FF_PG_Draft,
p.Adj_Def_FR_PG Adj_Def_FR_PG_Prior,
d.Adj_Def_FR_PG Adj_Def_FR_PG_Draft,
p.Adj_Def_Int_TD_PG Adj_Def_Int_TD_PG_Prior,
d.Adj_Def_Int_TD_PG Adj_Def_Int_TD_PG_Draft,
p.Adj_Def_TD_Fumbles_PG Adj_Def_TD_Fumbles_PG_Prior,
d.Adj_Def_TD_Fumbles_PG Adj_Def_TD_Fumbles_PG_Draft,
p.Dominator_Rating Dominator_Rating_Prior,
d.Dominator_Rating Dominator_Rating_Draft
INTO player_stats_normalized_pg_combined
FROM player_stats_normalized_avg_pg_prior p
INNER JOIN player_stats_normalized_avg_pg_draft_year d
ON p.NCAA_Link = d.NCAA_Link AND p.Combine_Year = d.Combine_Year AND p.Player = d.Player
--where p.player in('ryan tannehill','calvin johnson','michael crabtree','ezekiel elliott','zane gonzalez','aaron donald','patrick willis')

-------------------------------------------------------------------------------------------------------------------------------------------------

-- Create final table raw
SELECT
p.Combine_Year,
replace(replace(p.NCAA_Link,'http://www.sports-reference.com/cfb/players/',''),'.html','') Player_ID,
CASE 
	WHEN d.Rnd IN(1,2,3) THEN 1
	WHEN d.Rnd IN(4,5,6,7) THEN 0
	ELSE 0
END Top_Talent,
d.Rnd,
CASE 
	WHEN d.Rnd IN(1,2,3) THEN 'Rounds 1-3'
	WHEN d.Rnd IN(4,5,6,7) THEN 'Rounds 4-7'
	ELSE 'Undrafted'
END Round_Cat,
d.Pick,
coalesce(d.Tm, 'Undrafted') Draft_Team,
p.Player,
d.AV,
d.Exp_AV,
CASE
	WHEN d.AV < d.Exp_AV THEN 'Bust'
	ELSE 'Success'
END Success,
p.Class,
CASE WHEN p.Class='SR' THEN '0' WHEN p.Class IS NULL THEN 'N/A' ELSE '1' END Underclassman,
c.Pos,
c.Pos_Group,
c.Pos_Type,
d.Age Draft_age,
p.School,
p.Conf,
p.Power_Conf,
c.Ht,
c.Wt,
ROUND(c.BMI,2) BMI,
c.Arm_length,
c.Hand_size,
c.[40yd],
ROUND(c.Speed_score,2) Speed_Score,
ROUND(c.HASS,2) HASS,
c.Vertical,
ROUND(c.Vertical_Jump_Power,2) Vertical_Jump_Power,
c.Bench,
ROUND(c.Exp_Bench,2) Exp_Bench,
ROUND(c.Bench_Diff,2) Bench_Diff,
c.BroadJump,
ROUND(c.Broad_Jump_Power,2) Broad_Jump_Power,
c.[3Cone],
c.Shuttle,
ROUND(c.Quix_score,2) Quix_Score,
p.Off_Rk School_Off_Rnk,
p.Def_Rk School_Def_Rnk,
p.OSRS School_Off_Rating,
p.DSRS School_Def_Rating,
p.SRS School_Rating,
CASE WHEN a.NCAA_Link IS NOT NULL THEN 1 ELSE 0 END Consensus_AA,
ROUND(p.Dominator_Rating_Prior,2) Dominator_Rating_Prior,
ROUND(p.Dominator_Rating_Draft,2) Dominator_Rating_Draft,
ROUND(p.Pass_Att_PG_Prior,2) Pass_Att_PG_Prior,
ROUND(p.Pass_Att_PG_Draft,2) Pass_Att_PG_Draft,
ROUND(p.Pass_Cmp_PG_Prior,2) Pass_Cmp_PG_Prior,
ROUND(p.Pass_Cmp_PG_Draft,2) Pass_Cmp_PG_Draft,
ROUND(p.Pass_Pct_Prior,2) Pass_Pct_Prior,
ROUND(p.Pass_Pct_Draft,2) Pass_Pct_Draft,
ROUND(p.Pass_Yds_PG_Prior,2) Pass_Yds_PG_Prior,
ROUND(p.Pass_Yds_PG_Draft,2) Pass_Yds_PG_Draft,
ROUND(p.Pass_TD_PG_Prior,2) Pass_TD_PG_Prior,
ROUND(p.Pass_TD_PG_Draft,2) Pass_TD_PG_Draft,
ROUND(p.Pass_Int_PG_Prior,2) Pass_Int_PG_Prior,
ROUND(p.Pass_Int_PG_Draft,2) Pass_Int_PG_Draft,
ROUND(p.Pass_YA_Prior,2) Pass_YA_Prior,
ROUND(p.Pass_YA_Draft,2) Pass_YA_Draft,
ROUND(p.Pass_AYA_Prior,2) Pass_AYA_Prior,
ROUND(p.Pass_AYA_Draft,2) Pass_AYA_Draft,
ROUND(p.Pass_Rate_Prior,2) Pass_Rate_Prior,
ROUND(p.Pass_Rate_Draft,2) Pass_Rate_Draft,
ROUND(p.Rush_Att_PG_Prior,2) Rush_Att_PG_Prior,
ROUND(p.Rush_Att_PG_Draft,2) Rush_Att_PG_Draft,
ROUND(p.Rush_Yds_PG_Prior,2) Rush_Yds_PG_Prior,
ROUND(p.Rush_Yds_PG_Draft,2) Rush_Yds_PG_Draft,
ROUND(p.Rush_Avg_Prior,2) Rush_Avg_Prior,
ROUND(p.Rush_Avg_Draft,2) Rush_Avg_Draft,
ROUND(p.Rush_TD_PG_Prior,2) Rush_TD_PG_Prior,
ROUND(p.Rush_TD_PG_Draft,2) Rush_TD_PG_Draft,
ROUND(p.Rec_PG_Prior,2) Rec_PG_Prior,
ROUND(p.Rec_PG_Draft,2) Rec_PG_Draft,
ROUND(p.Rec_Yds_PG_Prior,2) Rec_Yds_PG_Prior,
ROUND(p.Rec_Yds_PG_Draft,2) Rec_Yds_PG_Draft,
ROUND(p.Rec_TD_PG_Prior,2) Rec_TD_PG_Prior,
ROUND(p.Rec_TD_PG_Draft,2) Rec_TD_PG_Draft,
ROUND(p.Scrim_Yds_PG_Prior,2) Scrim_Yds_PG_Prior,
ROUND(p.Scrim_Yds_PG_Draft,2) Scrim_Yds_PG_Draft,
ROUND(p.Scrim_TD_PG_Prior,2) Scrim_TD_PG_Prior,
ROUND(p.Scrim_TD_PG_Draft,2) Scrim_TD_PG_Draft,
ROUND(p.Kick_FGA_PG_Prior,2) Kick_FGA_PG_Prior,
ROUND(p.Kick_FGA_PG_Draft,2) Kick_FGA_PG_Draft,
ROUND(p.Kick_FGM_PG_Prior,2) Kick_FGM_PG_Prior,
ROUND(p.Kick_FGM_PG_Draft,2) Kick_FGM_PG_Draft,
ROUND(p.Kick_FG_pct_Prior,2) Kick_FG_pct_Prior,
ROUND(p.Kick_FG_pct_Draft,2) Kick_FG_pct_Draft,
ROUND(p.Kick_XPA_PG_Prior,2) Kick_XPA_PG_Prior,
ROUND(p.Kick_XPA_PG_Draft,2) Kick_XPA_PG_Draft,
ROUND(p.Kick_XPM_PG_Prior,2) Kick_XPM_PG_Prior,
ROUND(p.Kick_XPM_PG_Draft,2) Kick_XPM_PG_Draft,
ROUND(p.Kick_XP_pct_Prior,2) Kick_XP_pct_Prior,
ROUND(p.Kick_XP_pct_Draft,2) Kick_XP_pct_Draft,
ROUND(p.Non_offensive_TD_PG_Prior,2) Non_offensive_TD_PG_Prior,
ROUND(p.Non_offensive_TD_PG_Draft,2) Non_offensive_TD_PG_Draft,
ROUND(p.Def_Solo_Tackles_PG_Prior,2) Def_Solo_Tackles_PG_Prior,
ROUND(p.Def_Solo_Tackles_PG_Draft,2) Def_Solo_Tackles_PG_Draft,
ROUND(p.Def_Ast_Tackles_PG_Prior,2) Def_Ast_Tackles_PG_Prior,
ROUND(p.Def_Ast_Tackles_PG_Draft,2) Def_Ast_Tackles_PG_Draft,
ROUND(p.Def_Tot_Tackles_PG_Prior,2) Def_Tot_Tackles_PG_Prior,
ROUND(p.Def_Tot_Tackles_PG_Draft,2) Def_Tot_Tackles_PG_Draft,
ROUND(p.Def_Loss_Tackles_PG_Prior,2) Def_Loss_Tackles_PG_Prior,
ROUND(p.Def_Loss_Tackles_PG_Draft,2) Def_Loss_Tackles_PG_Draft,
ROUND(p.Def_Sk_PG_Prior,2) Def_Sk_PG_Prior,
ROUND(p.Def_Sk_PG_Draft,2) Def_Sk_PG_Draft,
ROUND(p.Def_Int_PG_Prior,2) Def_Int_PG_Prior,
ROUND(p.Def_Int_PG_Draft,2) Def_Int_PG_Draft,
ROUND(p.Def_PD_PG_Prior,2) Def_PD_PG_Prior,
ROUND(p.Def_PD_PG_Draft,2) Def_PD_PG_Draft,
ROUND(p.Def_FF_PG_Prior,2) Def_FF_PG_Prior,
ROUND(p.Def_FF_PG_Draft,2) Def_FF_PG_Draft,
ROUND(p.Def_FR_PG_Prior,2) Def_FR_PG_Prior,
ROUND(p.Def_FR_PG_Draft,2) Def_FR_PG_Draft,
ROUND(p.Def_Int_TD_PG_Prior,2) Def_Int_TD_PG_Prior,
ROUND(p.Def_Int_TD_PG_Draft,2) Def_Int_TD_PG_Draft,
ROUND(p.Def_TD_Fumbles_PG_Prior,2) Def_TD_Fumbles_PG_Prior,
ROUND(p.Def_TD_Fumbles_PG_Draft,2) Def_TD_Fumbles_PG_Draft
INTO player_stats_final_raw_pg
FROM player_stats_raw_pg_combined p
LEFT JOIN nfl_combine c
ON p.Combine_Year = c.Year AND p.NCAA_Link=c.NCAA_Link
LEFT JOIN nfl_draft d
ON c.NCAA_Link = d.NCAA_Link and c.Year = d.Year
LEFT JOIN ncaa_all_americans a
ON c.NCAA_Link = a.NCAA_Link and c.Year = a.Year+1
WHERE c.NCAA_Link IS NOT NULL
--AND c.Pos NOT IN('LS','FB','P','K','OT','OG','C')
--AND p.Player = 'calvin johnson'
--ORDER BY p.NCAA_Link


-- Create final table normalized
SELECT
p.Combine_Year,
replace(replace(p.NCAA_Link,'http://www.sports-reference.com/cfb/players/',''),'.html','') Player_ID,
CASE 
	WHEN d.Rnd IN(1,2,3) THEN 1
	WHEN d.Rnd IN(4,5,6,7) THEN 0
	ELSE 0
END Top_Talent,
d.Rnd,
CASE 
	WHEN d.Rnd IN(1,2,3) THEN 'Rounds 1-3'
	WHEN d.Rnd IN(4,5,6,7) THEN 'Rounds 4-7'
	ELSE 'Undrafted'
END Round_Cat,
d.Pick,
coalesce(d.Tm, 'Undrafted') Draft_Team,
p.Player,
d.AV,
d.Exp_AV,
CASE
	WHEN d.AV < d.Exp_AV THEN 'Bust'
	ELSE 'Success'
END Success,
p.Class,
CASE WHEN p.Class='SR' THEN '0' WHEN p.Class IS NULL THEN 'N/A' ELSE '1' END Underclassman,
c.Pos,
c.Pos_Group,
c.Pos_Type,
d.Age Draft_age,
p.School,
p.Conf,
p.Power_Conf,
c.Ht,
c.Wt,
ROUND(c.BMI,2) BMI,
c.Arm_length,
c.Hand_size,
c.[40yd],
ROUND(c.Speed_score,2) Speed_Score,
ROUND(c.HASS,2) HASS,
c.Vertical,
ROUND(c.Vertical_Jump_Power,2) Vertical_Jump_Power,
c.Bench,
ROUND(c.Exp_Bench,2) Exp_Bench,
ROUND(c.Bench_Diff,2) Bench_Diff,
c.BroadJump,
ROUND(c.Broad_Jump_Power,2) Broad_Jump_Power,
c.[3Cone],
c.Shuttle,
ROUND(c.Quix_score,2) Quix_Score,
p.Off_Rk School_Off_Rnk,
p.Def_Rk School_Def_Rnk,
p.OSRS School_Off_Rating,
p.DSRS School_Def_Rating,
p.SRS School_Rating,
CASE WHEN a.NCAA_Link IS NOT NULL THEN 1 ELSE 0 END Consensus_AA,
ROUND(p.Dominator_Rating_Prior,2) Dominator_Rating_Prior,
ROUND(p.Dominator_Rating_Draft,2) Dominator_Rating_Draft,
ROUND(p.Adj_Pass_Att_PG_Prior,2) Adj_Pass_Att_PG_Prior,
ROUND(p.Adj_Pass_Att_PG_Draft,2) Adj_Pass_Att_PG_Draft,
ROUND(p.Adj_Pass_Cmp_PG_Prior,2) Adj_Pass_Cmp_PG_Prior,
ROUND(p.Adj_Pass_Cmp_PG_Draft,2) Adj_Pass_Cmp_PG_Draft,
ROUND(p.Pass_Pct_Prior,2) Pass_Pct_Prior,
ROUND(p.Pass_Pct_Draft,2) Pass_Pct_Draft,
ROUND(p.Adj_Pass_Yds_PG_Prior,2) Adj_Pass_Yds_PG_Prior,
ROUND(p.Adj_Pass_Yds_PG_Draft,2) Adj_Pass_Yds_PG_Draft,
ROUND(p.Adj_Pass_TD_PG_Prior,2) Adj_Pass_TD_PG_Prior,
ROUND(p.Adj_Pass_TD_PG_Draft,2) Adj_Pass_TD_PG_Draft,
ROUND(p.Adj_Pass_Int_PG_Prior,2) Adj_Pass_Int_PG_Prior,
ROUND(p.Adj_Pass_Int_PG_Draft,2) Adj_Pass_Int_PG_Draft,
ROUND(p.Pass_YA_Prior,2) Pass_YA_Prior,
ROUND(p.Pass_YA_Draft,2) Pass_YA_Draft,
ROUND(p.Pass_AYA_Prior,2) Pass_AYA_Prior,
ROUND(p.Pass_AYA_Draft,2) Pass_AYA_Draft,
ROUND(p.Pass_Rate_Prior,2) Pass_Rate_Prior,
ROUND(p.Pass_Rate_Draft,2) Pass_Rate_Draft,
ROUND(p.Adj_Rush_Att_PG_Prior,2) Adj_Rush_Att_PG_Prior,
ROUND(p.Adj_Rush_Att_PG_Draft,2) Adj_Rush_Att_PG_Draft,
ROUND(p.Adj_Rush_Yds_PG_Prior,2) Adj_Rush_Yds_PG_Prior,
ROUND(p.Adj_Rush_Yds_PG_Draft,2) Adj_Rush_Yds_PG_Draft,
ROUND(p.Rush_Avg_Prior,2) Rush_Avg_Prior,
ROUND(p.Rush_Avg_Draft,2) Rush_Avg_Draft,
ROUND(p.Adj_Rush_TD_PG_Prior,2) Adj_Rush_TD_PG_Prior,
ROUND(p.Adj_Rush_TD_PG_Draft,2) Adj_Rush_TD_PG_Draft,
ROUND(p.Adj_Rec_PG_Prior,2) Adj_Rec_PG_Prior,
ROUND(p.Adj_Rec_PG_Draft,2) Adj_Rec_PG_Draft,
ROUND(p.Adj_Rec_Yds_PG_Prior,2) Adj_Rec_Yds_PG_Prior,
ROUND(p.Adj_Rec_Yds_PG_Draft,2) Adj_Rec_Yds_PG_Draft,
ROUND(p.Adj_Rec_TD_PG_Prior,2) Adj_Rec_TD_PG_Prior,
ROUND(p.Adj_Rec_TD_PG_Draft,2) Adj_Rec_TD_PG_Draft,
ROUND(p.Adj_Scrim_Yds_PG_Prior,2) Adj_Scrim_Yds_PG_Prior,
ROUND(p.Adj_Scrim_Yds_PG_Draft,2) Adj_Scrim_Yds_PG_Draft,
ROUND(p.Adj_Scrim_TD_PG_Prior,2) Adj_Scrim_TD_PG_Prior,
ROUND(p.Adj_Scrim_TD_PG_Draft,2) Adj_Scrim_TD_PG_Draft,
ROUND(p.Kick_FGA_PG_Prior,2) Kick_FGA_PG_Prior,
ROUND(p.Kick_FGA_PG_Draft,2) Kick_FGA_PG_Draft,
ROUND(p.Kick_FGM_PG_Prior,2) Kick_FGM_PG_Prior,
ROUND(p.Kick_FGM_PG_Draft,2) Kick_FGM_PG_Draft,
ROUND(p.Kick_FG_pct_Prior,2) Kick_FG_pct_Prior,
ROUND(p.Kick_FG_pct_Draft,2) Kick_FG_pct_Draft,
ROUND(p.Kick_XPA_PG_Prior,2) Kick_XPA_PG_Prior,
ROUND(p.Kick_XPA_PG_Draft,2) Kick_XPA_PG_Draft,
ROUND(p.Kick_XPM_PG_Prior,2) Kick_XPM_PG_Prior,
ROUND(p.Kick_XPM_PG_Draft,2) Kick_XPM_PG_Draft,
ROUND(p.Kick_XP_pct_Prior,2) Kick_XP_pct_Prior,
ROUND(p.Kick_XP_pct_Draft,2) Kick_XP_pct_Draft,
ROUND(p.Non_offensive_TD_PG_Prior,2) Non_offensive_TD_PG_Prior,
ROUND(p.Non_offensive_TD_PG_Draft,2) Non_offensive_TD_PG_Draft,
ROUND(p.Adj_Def_Solo_Tackles_PG_Prior,2) Adj_Def_Solo_Tackles_PG_Prior,
ROUND(p.Adj_Def_Solo_Tackles_PG_Draft,2) Adj_Def_Solo_Tackles_PG_Draft,
ROUND(p.Adj_Def_Ast_Tackles_PG_Prior,2) Adj_Def_Ast_Tackles_PG_Prior,
ROUND(p.Adj_Def_Ast_Tackles_PG_Draft,2) Adj_Def_Ast_Tackles_PG_Draft,
ROUND(p.Adj_Def_Tot_Tackles_PG_Prior,2) Adj_Def_Tot_Tackles_PG_Prior,
ROUND(p.Adj_Def_Tot_Tackles_PG_Draft,2) Adj_Def_Tot_Tackles_PG_Draft,
ROUND(p.Adj_Def_Loss_Tackles_PG_Prior,2) Adj_Def_Loss_Tackles_PG_Prior,
ROUND(p.Adj_Def_Loss_Tackles_PG_Draft,2) Adj_Def_Loss_Tackles_PG_Draft,
ROUND(p.Adj_Def_Sk_PG_Prior,2) Adj_Def_Sk_PG_Prior,
ROUND(p.Adj_Def_Sk_PG_Draft,2) Adj_Def_Sk_PG_Draft,
ROUND(p.Adj_Def_Int_PG_Prior,2) Adj_Def_Int_PG_Prior,
ROUND(p.Adj_Def_Int_PG_Draft,2) Adj_Def_Int_PG_Draft,
ROUND(p.Adj_Def_PD_PG_Prior,2) Adj_Def_PD_PG_Prior,
ROUND(p.Adj_Def_PD_PG_Draft,2) Adj_Def_PD_PG_Draft,
ROUND(p.Adj_Def_FF_PG_Prior,2) Adj_Def_FF_PG_Prior,
ROUND(p.Adj_Def_FF_PG_Draft,2) Adj_Def_FF_PG_Draft,
ROUND(p.Adj_Def_FR_PG_Prior,2) Adj_Def_FR_PG_Prior,
ROUND(p.Adj_Def_FR_PG_Draft,2) Adj_Def_FR_PG_Draft,
ROUND(p.Adj_Def_Int_TD_PG_Prior,2) Adj_Def_Int_TD_PG_Prior,
ROUND(p.Adj_Def_Int_TD_PG_Draft,2) Adj_Def_Int_TD_PG_Draft,
ROUND(p.Adj_Def_TD_Fumbles_PG_Prior,2) Adj_Def_TD_Fumbles_PG_Prior,
ROUND(p.Adj_Def_TD_Fumbles_PG_Draft,2) Adj_Def_TD_Fumbles_PG_Draft
INTO player_stats_final_normalized_pg
FROM player_stats_normalized_pg_combined p
LEFT JOIN nfl_combine c
ON p.Combine_Year = c.Year AND p.NCAA_Link=c.NCAA_Link
LEFT JOIN nfl_draft d
ON c.NCAA_Link = d.NCAA_Link and c.Year = d.Year
LEFT JOIN ncaa_all_americans a
ON c.NCAA_Link = a.NCAA_Link and c.Year = a.Year+1
WHERE c.NCAA_Link IS NOT NULL 
--AND c.Pos NOT IN('LS','FB','P','K','OT','OG','C')
--AND p.Player = 'calvin johnson'
--ORDER BY p.NCAA_Link

-- Fill missing class values
UPDATE p
SET 
	p.Class = c.Class,
	p.Underclassman = c.Underclassman
FROM player_stats_final_raw_pg p
INNER JOIN Missing_class c
ON p.Player_ID=c.Player_ID
WHERE p.Class is NULL

UPDATE p
SET 
	p.Class = c.Class,
	p.Underclassman = c.Underclassman
FROM player_stats_final_normalized_pg p
INNER JOIN Missing_class c
ON p.Player_ID=c.Player_ID
WHERE p.Class is NULL

UPDATE player_stats_final_raw_pg
SET Rnd = 8, Pick=999
WHERE Rnd IS NULL

UPDATE player_stats_final_normalized_pg
SET Rnd = 8, Pick=999
WHERE Rnd IS NULL

-- Remove not relevant stats
-- Remove Def stats for offensive players
UPDATE player_stats_final_raw_pg
SET
	Def_Solo_Tackles_PG_Prior = 0,
	Def_Solo_Tackles_PG_Draft = 0,
	Def_Ast_Tackles_PG_Prior = 0,
	Def_Ast_Tackles_PG_Draft = 0,
	Def_Tot_Tackles_PG_Prior = 0,
	Def_Tot_Tackles_PG_Draft = 0,
	Def_Loss_Tackles_PG_Prior = 0,
	Def_Loss_Tackles_PG_Draft = 0,
	Def_Sk_PG_Prior = 0,
	Def_Sk_PG_Draft = 0,
	Def_Int_PG_Prior = 0,
	Def_Int_PG_Draft = 0,
	Def_PD_PG_Prior = 0,
	Def_PD_PG_Draft = 0,
	Def_FF_PG_Prior = 0,
	Def_FF_PG_Draft = 0,
	Def_FR_PG_Prior = 0,
	Def_FR_PG_Draft = 0,
	Def_Int_TD_PG_Prior = 0,
	Def_Int_TD_PG_Draft = 0,
	Def_TD_Fumbles_PG_Prior = 0,
	Def_TD_Fumbles_PG_Draft = 0
WHERE Pos_Type = 'Offense'

-- Remove Off stats for defensive players
UPDATE player_stats_final_raw_pg
SET
	Dominator_Rating_Prior = 0,
	Dominator_Rating_Draft = 0,
	Pass_Att_PG_Prior = 0,
	Pass_Att_PG_Draft = 0,
	Pass_Cmp_PG_Prior = 0,
	Pass_Cmp_PG_Draft = 0,
	Pass_Pct_Prior = 0,
	Pass_Pct_Draft = 0,
	Pass_Yds_PG_Prior = 0,
	Pass_Yds_PG_Draft = 0,
	Pass_TD_PG_Prior = 0,
	Pass_TD_PG_Draft = 0,
	Pass_Int_PG_Prior = 0,
	Pass_Int_PG_Draft = 0,
	Pass_YA_Prior = 0,
	Pass_YA_Draft = 0,
	Pass_AYA_Prior = 0,
	Pass_AYA_Draft = 0,
	Pass_Rate_Prior = 0,
	Pass_Rate_Draft = 0,
	Rush_Att_PG_Prior = 0,
	Rush_Att_PG_Draft = 0,
	Rush_Yds_PG_Prior = 0,
	Rush_Yds_PG_Draft = 0,
	Rush_Avg_Prior = 0,
	Rush_Avg_Draft = 0,
	Rush_TD_PG_Prior = 0,
	Rush_TD_PG_Draft = 0,
	Rec_PG_Prior = 0,
	Rec_PG_Draft = 0,
	Rec_Yds_PG_Prior = 0,
	Rec_Yds_PG_Draft = 0,
	Rec_TD_PG_Prior = 0,
	Rec_TD_PG_Draft = 0,
	Scrim_Yds_PG_Prior = 0,
	Scrim_Yds_PG_Draft = 0,
	Scrim_TD_PG_Prior = 0,
	Scrim_TD_PG_Draft = 0,
	Kick_FGA_PG_Prior = 0,
	Kick_FGA_PG_Draft = 0,
	Kick_FGM_PG_Prior = 0,
	Kick_FGM_PG_Draft = 0,
	Kick_FG_pct_Prior = 0,
	Kick_FG_pct_Draft = 0,
	Kick_XPA_PG_Prior = 0,
	Kick_XPA_PG_Draft = 0,
	Kick_XPM_PG_Prior = 0,
	Kick_XPM_PG_Draft = 0,
	Kick_XP_pct_Prior = 0,
	Kick_XP_pct_Draft = 0
WHERE Pos_Type = 'Defense'

-- Remove pass stats for non-QBs
UPDATE player_stats_final_raw_pg
SET
	Pass_Att_PG_Prior = 0,
	Pass_Att_PG_Draft = 0,
	Pass_Cmp_PG_Prior = 0,
	Pass_Cmp_PG_Draft = 0,
	Pass_Pct_Prior = 0,
	Pass_Pct_Draft = 0,
	Pass_Yds_PG_Prior = 0,
	Pass_Yds_PG_Draft = 0,
	Pass_TD_PG_Prior = 0,
	Pass_TD_PG_Draft = 0,
	Pass_Int_PG_Prior = 0,
	Pass_Int_PG_Draft = 0,
	Pass_YA_Prior = 0,
	Pass_YA_Draft = 0,
	Pass_AYA_Prior = 0,
	Pass_AYA_Draft = 0,
	Pass_Rate_Prior = 0,
	Pass_Rate_Draft = 0
WHERE pos <> 'QB'

 --Remove kick stats for non-kickers
UPDATE player_stats_final_raw_pg
SET
	Kick_FGA_PG_Prior = 0,
	Kick_FGA_PG_Draft = 0,
	Kick_FGM_PG_Prior = 0,
	Kick_FGM_PG_Draft = 0,
	Kick_FG_pct_Prior = 0,
	Kick_FG_pct_Draft = 0,
	Kick_XPA_PG_Prior = 0,
	Kick_XPA_PG_Draft = 0,
	Kick_XPM_PG_Prior = 0,
	Kick_XPM_PG_Draft = 0,
	Kick_XP_pct_Prior = 0,
	Kick_XP_pct_Draft = 0
WHERE pos NOT IN('K','P')

-- Remove Dominator rating for non-WRs and non-RBs
UPDATE player_stats_final_raw_pg
SET
	Dominator_Rating_Prior = 0,
	Dominator_Rating_Draft = 0
WHERE pos NOT IN ('WR', 'RB', 'TE')

-- Remove Def stats for offensive players
UPDATE player_stats_final_normalized_pg
SET
	Adj_Def_Solo_Tackles_PG_Prior = 0,
    Adj_Def_Solo_Tackles_PG_Draft = 0,
    Adj_Def_Ast_Tackles_PG_Prior = 0,
    Adj_Def_Ast_Tackles_PG_Draft = 0,
    Adj_Def_Tot_Tackles_PG_Prior = 0,
    Adj_Def_Tot_Tackles_PG_Draft = 0,
    Adj_Def_Loss_Tackles_PG_Prior = 0,
    Adj_Def_Loss_Tackles_PG_Draft = 0,
    Adj_Def_Sk_PG_Prior = 0,
    Adj_Def_Sk_PG_Draft = 0,
    Adj_Def_Int_PG_Prior = 0,
    Adj_Def_Int_PG_Draft = 0,
    Adj_Def_PD_PG_Prior = 0,
    Adj_Def_PD_PG_Draft = 0,
    Adj_Def_FF_PG_Prior = 0,
    Adj_Def_FF_PG_Draft = 0,
    Adj_Def_FR_PG_Prior = 0,
    Adj_Def_FR_PG_Draft = 0,
    Adj_Def_Int_TD_PG_Prior = 0,
    Adj_Def_Int_TD_PG_Draft = 0,
    Adj_Def_TD_Fumbles_PG_Prior = 0,
    Adj_Def_TD_Fumbles_PG_Draft = 0
WHERE Pos_Type = 'Offense'

-- Remove Off stats for defensive players
UPDATE player_stats_final_normalized_pg
SET
	Dominator_Rating_Prior = 0,
	Dominator_Rating_Draft = 0,
    Adj_Pass_Att_PG_Prior = 0,
    Adj_Pass_Att_PG_Draft = 0,
    Adj_Pass_Cmp_PG_Prior = 0,
    Adj_Pass_Cmp_PG_Draft = 0,
    Pass_Pct_Prior = 0,
    Pass_Pct_Draft = 0,
    Adj_Pass_Yds_PG_Prior = 0,
    Adj_Pass_Yds_PG_Draft = 0,
    Adj_Pass_TD_PG_Prior = 0,
    Adj_Pass_TD_PG_Draft = 0,
    Adj_Pass_Int_PG_Prior = 0,
    Adj_Pass_Int_PG_Draft = 0,
    Pass_YA_Prior = 0,
    Pass_YA_Draft = 0,
    Pass_AYA_Prior = 0,
    Pass_AYA_Draft = 0,
    Pass_Rate_Prior = 0,
    Pass_Rate_Draft = 0,
    Adj_Rush_Att_PG_Prior = 0,
    Adj_Rush_Att_PG_Draft = 0,
    Adj_Rush_Yds_PG_Prior = 0,
    Adj_Rush_Yds_PG_Draft = 0,
    Rush_Avg_Prior = 0,
    Rush_Avg_Draft = 0,
    Adj_Rush_TD_PG_Prior = 0,
    Adj_Rush_TD_PG_Draft = 0,
    Adj_Rec_PG_Prior = 0,
    Adj_Rec_PG_Draft = 0,
    Adj_Rec_Yds_PG_Prior = 0,
    Adj_Rec_Yds_PG_Draft = 0,
    Adj_Rec_TD_PG_Prior = 0,
    Adj_Rec_TD_PG_Draft = 0,
    Adj_Scrim_Yds_PG_Prior = 0,
    Adj_Scrim_Yds_PG_Draft = 0,
    Adj_Scrim_TD_PG_Prior = 0,
    Adj_Scrim_TD_PG_Draft = 0,
    Kick_FGA_PG_Prior = 0,
    Kick_FGA_PG_Draft = 0,
    Kick_FGM_PG_Prior = 0,
    Kick_FGM_PG_Draft = 0,
    Kick_FG_pct_Prior = 0,
    Kick_FG_pct_Draft = 0,
    Kick_XPA_PG_Prior = 0,
    Kick_XPA_PG_Draft = 0,
    Kick_XPM_PG_Prior = 0,
    Kick_XPM_PG_Draft = 0,
    Kick_XP_pct_Prior = 0,
    Kick_XP_pct_Draft = 0
WHERE Pos_Type = 'Defense'

---- Remove pass stats for non-QBs
UPDATE player_stats_final_normalized_pg
SET
	Adj_Pass_Att_PG_Prior = 0,
	Adj_Pass_Att_PG_Draft = 0,
	Adj_Pass_Cmp_PG_Prior = 0,
	Adj_Pass_Cmp_PG_Draft = 0,
	Pass_Pct_Prior = 0,
	Pass_Pct_Draft = 0,
	Adj_Pass_Yds_PG_Prior = 0,
	Adj_Pass_Yds_PG_Draft = 0,
	Adj_Pass_TD_PG_Prior = 0,
	Adj_Pass_TD_PG_Draft = 0,
	Adj_Pass_Int_PG_Prior = 0,
	Adj_Pass_Int_PG_Draft = 0,
	Pass_YA_Prior = 0,
	Pass_YA_Draft = 0,
	Pass_AYA_Prior = 0,
	Pass_AYA_Draft = 0,
	Pass_Rate_Prior = 0,
	Pass_Rate_Draft = 0
WHERE pos <> 'QB'

-- Remove kick stats for non-kickers
UPDATE player_stats_final_normalized_pg
SET
	Kick_FGA_PG_Prior = 0,
	Kick_FGA_PG_Draft = 0,
	Kick_FGM_PG_Prior = 0,
	Kick_FGM_PG_Draft = 0,
	Kick_FG_pct_Prior = 0,
	Kick_FG_pct_Draft = 0,
	Kick_XPA_PG_Prior = 0,
	Kick_XPA_PG_Draft = 0,
	Kick_XPM_PG_Prior = 0,
	Kick_XPM_PG_Draft = 0,
	Kick_XP_pct_Prior = 0,
	Kick_XP_pct_Draft = 0
WHERE pos NOT IN('K','P')

-- Remove Dominator rating for non-WRs and non-RBs
UPDATE player_stats_final_normalized_pg
SET
	Dominator_Rating_Prior = 0,
	Dominator_Rating_Draft = 0
WHERE pos NOT IN ('WR', 'RB','TE')



-- Impute median age
UPDATE player_stats_final_raw_pg
SET DRAFT_AGE =
CASE 
	WHEN Class='SR' THEN 23
	WHEN Class='JR' THEN 22
	WHEN Class='SO' THEN 21
	WHEN Class='FR' THEN 20
END
WHERE Draft_age IS NULL

--UPDATE player_stats_final_normalized_pg
--SET Draft_age = 22
--WHERE Draft_age IS NULL

--UPDATE player_stats_final_raw_pg
--SET
--      [Rec_PG_Prior] = 0
--      ,[Rec_PG_Draft]= 0
--      ,[Rec_Yds_PG_Prior]= 0
--      ,[Rec_Yds_PG_Draft]= 0
--      ,[Rec_TD_PG_Prior]= 0
--      ,[Rec_TD_PG_Draft]= 0
--      ,[Scrim_Yds_PG_Prior]= 0
--      ,[Scrim_Yds_PG_Draft]= 0
--      ,[Scrim_TD_PG_Prior]= 0
--      ,[Scrim_TD_PG_Draft]= 0
--WHERE Pos='QB'


--UPDATE player_stats_final_normalized_pg
--SET
--      [Adj_Rec_PG_Prior] = 0
--      ,[Adj_Rec_PG_Draft]= 0
--      ,[Adj_Rec_Yds_PG_Prior]= 0
--      ,[Adj_Rec_Yds_PG_Draft]= 0
--      ,[Adj_Rec_TD_PG_Prior]= 0
--      ,[Adj_Rec_TD_PG_Draft]= 0
--      ,[Adj_Scrim_Yds_PG_Prior]= 0
--      ,[Adj_Scrim_Yds_PG_Draft]= 0
--      ,[Adj_Scrim_TD_PG_Prior]= 0
--      ,[Adj_Scrim_TD_PG_Draft]= 0
--WHERE Pos='QB'

--UPDATE player_stats_final_normalized_pg
--SET
--      [Adj_Rush_Att_PG_Prior]= 0
--      ,[Adj_Rush_Att_PG_Draft]= 0
--      ,[Adj_Rush_Yds_PG_Prior]= 0
--      ,[Adj_Rush_Yds_PG_Draft]= 0
--      ,[Rush_Avg_Prior]= 0
--      ,[Rush_Avg_Draft]= 0
--      ,[Adj_Rush_TD_PG_Prior]= 0
--      ,[Adj_Rush_TD_PG_Draft]= 0
--	  ,[Adj_Scrim_Yds_PG_Prior]= 0
--      ,[Adj_Scrim_Yds_PG_Draft]= 0
--      ,[Adj_Scrim_TD_PG_Prior]= 0
--      ,[Adj_Scrim_TD_PG_Draft]= 0
--WHERE Pos IN('WR', 'TE')

-- remove players with missing statlines
--DELETE
--FROM player_stats_final_normalized_pg
--WHERE Adj_Pass_Att_PG_Prior=0
--AND Adj_Pass_Att_PG_Draft=0
--AND Adj_Rush_Att_PG_Prior=0
--AND Adj_Rush_Att_PG_Draft=0
--AND Adj_Rec_PG_Prior=0
--AND Adj_Rec_PG_Draft=0
--AND Adj_Def_Tot_Tackles_PG_Prior=0
--AND Adj_Def_Tot_Tackles_PG_Draft=0
--AND Adj_Def_Loss_Tackles_PG_Prior=0
--AND Adj_Def_Loss_Tackles_PG_Draft=0
--AND Adj_Def_Sk_PG_Prior=0
--AND Adj_Def_Sk_PG_Draft=0
--AND Adj_Def_Int_PG_Prior=0
--AND Adj_Def_Int_PG_Draft=0
--AND Adj_Def_PD_PG_Prior=0
--AND Adj_Def_PD_PG_Draft=0
--AND Adj_Def_FF_PG_Prior=0
--AND Adj_Def_FF_PG_Draft=0
--AND Adj_Def_FR_PG_Prior=0
--AND Adj_Def_FR_PG_Draft=0
