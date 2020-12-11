USE DataRobot
GO

-- drop tables if exist
if exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'nfl_draft') drop table nfl_draft;
if exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'nfl_combine') drop table nfl_combine;
if exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'nflcombineresults') drop table nflcombineresults;
if exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'ncaa_all_americans') drop table ncaa_all_americans;
if exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'ncaa_team_ratings') drop table ncaa_team_ratings;
if exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'ncaa_team_offense_defense') drop table ncaa_team_offense_defense;
if exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'ncaa_player_stats') drop table ncaa_player_stats;

-- create tables and insert data
CREATE TABLE nfl_draft(
[Year] int,
Player_ID nvarchar(16),
NCAA_Link nvarchar(256),
Rnd int,
Pick int,
Tm nvarchar(64),
Player nvarchar(64),
Pos nvarchar(8),
Age float,
AV float,
School nvarchar(64)
)
GO

BULK INSERT nfl_draft
FROM 'D:\ROLAND\DataRobot_University_Applied_DS\Capstone_project\2_clean_data\202_result\nfl_draft_2000_2020_clean_with_AV.csv'
WITH (
	FIRSTROW = 2,
    FIELDTERMINATOR =',',
    ROWTERMINATOR = '\n',
	DATAFILETYPE = 'char'
	);
GO

CREATE TABLE nfl_combine(
[Year] int,
Player_ID nvarchar(16),
NCAA_Link nvarchar(256),
Player nvarchar(64),
Pos nvarchar(8),
School nvarchar(64),
Ht int,
Wt int,
[40yd] float,
Vertical float,
Bench float,
BroadJump float,
[3Cone] float,
Shuttle float,
Team nvarchar(64),
[Round] int,
Pick int
)
GO
-- manually removed "," in names, pl "Odell Beckham, Jr." --> Odell Beckham Jr.
BULK INSERT nfl_combine
FROM 'D:\ROLAND\DataRobot_University_Applied_DS\Capstone_project\2_clean_data\202_result\nfl_combine_2000_2020_clean.csv'
WITH (
	FIRSTROW = 2,
    FIELDTERMINATOR =',',
    ROWTERMINATOR = '\n',
	DATAFILETYPE = 'char'
	);
GO

CREATE TABLE nflcombineresults(
[Year] int,
Name nvarchar(64),
College nvarchar(64),
Pos nvarchar(8),
Height float,
Weight float,
Hand_size float,
Arm_length float,
Wonderlic int,
[40yd] float,
Bench float,
Vertical float,
BroadJump float,
Shuttle float,
[3Cone] float,
[60ydShuttle] float
)
GO
-- manually removed "," in names, pl "Odell Beckham, Jr." --> Odell Beckham Jr.
BULK INSERT nflcombineresults
FROM 'D:\ROLAND\DataRobot_University_Applied_DS\Capstone_project\2_clean_data\202_result\nflcombineresults_2000_2020.csv'
WITH (
	FIRSTROW = 2,
    FIELDTERMINATOR =',',
    ROWTERMINATOR = '\n',
	DATAFILETYPE = 'char'
	);
GO

CREATE TABLE ncaa_all_americans(
[Year] int,
Player nvarchar(64),
Pos nvarchar(8),
School nvarchar(64),
NCAA_Link nvarchar(256)
)

BULK INSERT ncaa_all_americans
FROM 'D:\ROLAND\DataRobot_University_Applied_DS\Capstone_project\2_clean_data\202_result\ncaa_all_americans__1999_2019.csv'
WITH (
	FIRSTROW = 2,
    FIELDTERMINATOR =',',
    ROWTERMINATOR = '\n',
	DATAFILETYPE = 'char'
	);
GO

CREATE TABLE ncaa_team_ratings(
[Year] int,
Rk int,
School nvarchar(64),
Conf nvarchar(32),
AP_Rank float,
W int,
L int,
OSRS float,
DSRS float,
SRS float,
PPG float,
Opp_PPG float,
Pass_YPA float,
Opp_Pass_YPA float,
Rush_YPA float,
Opp_Rush_YPA float,
Total_YPP float,
Opp_Total_YPP float
)


BULK INSERT ncaa_team_ratings
FROM 'D:\ROLAND\DataRobot_University_Applied_DS\Capstone_project\2_clean_data\202_result\ncaaf_team_ratings_1999_2019_clean.csv'
WITH (
	FIRSTROW = 2,
    FIELDTERMINATOR =',',
    ROWTERMINATOR = '\n',
	DATAFILETYPE = 'char'
	);
GO


CREATE TABLE ncaa_team_offense_defense(
[Year] int,
Off_Rk int,
School nvarchar(64),
G int,
Pts float,
Pass_Cmp float,
Pass_Att float,
Pass_Pct float,
Pass_Yds float,
Pass_TD float,
Rush_Att float,
Rush_Yds float,
Rush_Avg float,
Rush_TD float,
Off_Plays float,
Off_Yds float,
Off_Avg float,
FD_Pass float,
FD_Rush float,
FD_Pen float,
FD_Tot float,
Pen float,
Pen_Yds float,
Fum float,
[Int] float,
TO_Tot float,
Def_Rk float,
Opp_Pts float,
Opp_Pass_Cmp float,
Opp_Pass_Att float,
Opp_Pass_Pct float,
Opp_Pass_Yds float,
Opp_Pass_TD float,
Opp_Rush_Att float,
Opp_Rush_Yds float,
Opp_Rush_Avg float,
Opp_Rush_TD float,
Opp_Off_Plays float,
Opp_Off_Yds float,
Opp_Off_Avg float,
Opp_FD_Pass float,
Opp_FD_Rush float,
Opp_FD_Pen float,
Opp_FD_Tot float,
Opp_Pen float,
Opp_Pen_Yds float,
Opp_Fum float,
Opp_Int float,
Opp_TO_Tot float
)

BULK INSERT ncaa_team_offense_defense
FROM 'D:\ROLAND\DataRobot_University_Applied_DS\Capstone_project\2_clean_data\202_result\ncaaf_team_offense_defense_2000_2019_clean.csv'
WITH (
	FIRSTROW = 2,
    FIELDTERMINATOR =',',
    ROWTERMINATOR = '\n',
	DATAFILETYPE = 'char'
	);
GO


CREATE TABLE ncaa_player_stats(
NCAA_Link nvarchar(256),
[Year] nvarchar(8),
School nvarchar(64),
Conf nvarchar(32),
Class nvarchar(2),
Pos nvarchar(8),
G float,
Def_Solo_Tackles float,
Def_Ast_Tackles float,
Def_Tot_Tackles float,
Def_Loss_Tackles float,
Def_Sk float,
Def_Int float,
Def_Int_Yds float,
Def_Int_Avg float,
Def_Int_TD float,
Def_Int_PD float,
Def_FR float,
Def_Yds_Fumbles float,
Def_TD_Fumbles float,
Def_FF float,
Kick_Ret float,
Kick_ret_Yds float,
Kick_ret_Avg float,
Kick_ret_TD float,
Punt_Ret float,
Punt_ret_Yds float,
Punt_ret_Avg float,
Punt_ret_TD float,
Rush_Att float,
Rush_Yds float,
Rush_Avg float,
Rush_TD float,
Rec float,
Rec_Yds float,
Rec_Avg float,
Rec_TD float,
Scrim_Plays float,
Scrim_Yds float,
Scrim_Avg float,
Scrim_TD float,
Punts float,
Punt_Yds float,
Punt_Avg float,
Kick_XPM float,
Kick_XPA float,
Kick_XP_pct float,
Kick_FGM float,
Kick_FGA float,
Kick_FG_pct float,
Kick_Pts float,
Pass_Cmp float,
Pass_Att float,
Pass_Pct float,
Pass_Yds float,
Pass_YA float,
Pass_AYA float,
Pass_TD float,
Pass_Int float,
Pass_Rate float
)

BULK INSERT ncaa_player_stats
FROM 'D:\ROLAND\DataRobot_University_Applied_DS\Capstone_project\2_clean_data\202_result\ncaa_all_player_ind_stats_extended_clean_v2.csv'
WITH (
	FIRSTROW = 2,
    FIELDTERMINATOR =',',
    ROWTERMINATOR = '\n',
	DATAFILETYPE = 'char'
	);
GO