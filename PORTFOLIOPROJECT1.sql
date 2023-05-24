select * 
from PortifolioProject..[dbo.TotalCases]
order by 1,2


select * 
from PortifolioProject..[dbo.TotalDeaths]
order by 1,2


--Seleceting data that we're going to use

select date, world, Africa, Asia, Europe
from PortifolioProject..[dbo.TotalCases]
order by 1,2


select date, world, Africa, Asia, Europe
from PortifolioProject..[dbo.TotalDeaths]
order by 1,2

--Looking at what percentages of infections and death
--Percentages of infections

select date, world, Africa, (Africa/world)*100 as AfricanCasesPercentage
from PortifolioProject..[dbo.TotalCases]
order by AfricanCasesPercentage asc


select date, world, Asia, (Asia/world)*100 as AsianCasesPercentage
from PortifolioProject..[dbo.TotalCases]
order by AsianCasesPercentage asc


select date, world, Europe, (Europe/world)*100 as EuropeanCasesPercentage
from PortifolioProject..[dbo.TotalCases]
order by EuropeanCasesPercentage asc

--Percentages of deaths

select date, world, Africa, (Africa/world)*100 as AfricanDeathPercentage 
from PortifolioProject..[dbo.TotalDeaths]
order by AfricanDeathPercentage asc


select date, world, Asia, (Asia/world)*100 as AsianDeathPercentage 
from PortifolioProject..[dbo.TotalDeaths]
order by AsianDeathPercentage asc


select date, world, Europe, (Europe/world)*100 as EuropeanDeathPercentage 
from PortifolioProject..[dbo.TotalDeaths]
order by EuropeanDeathPercentage asc


--Global numbers
--Joining TotalCases+TotalDeaths

select *
from PortifolioProject..[dbo.TotalCases] as TCases
join PortifolioProject..[dbo.TotalDeaths] as TDeaths
on Tcases.date = TDeaths.date 
order by 1,2

select TCases.date, TCases.world, TDeaths.world, (TDeaths.world/TCases.world)*100 as WorldDeathPercentage
from PortifolioProject..[dbo.TotalCases]  Tcases
join PortifolioProject..[dbo.TotalDeaths]  TDeaths
on TCases.date = TDeaths.date 
order by WorldDeathPercentage desc  

--Creating a CTE

select TCases.date, TDeaths.world
, sum(cast(TDeaths.world as int)) over (Partition by TCases.world) as RollingWorldDeaths
from PortifolioProject..[dbo.TotalCases] as TCases
join PortifolioProject..[dbo.TotalDeaths] as TDeaths
on TCases.date = TDeaths.date
where TDeaths.world >= 1
--order by 3,4

--Using CTE

with CasesvsDeaths (date, world, RollingWorldDeaths) 
as 
(
select TCases.date, TCases.world
, sum(convert(int,TDeaths.world)) over (Partition by TCases.world) as RollingWorldDeaths
--, (RollingWorldDeaths/TCases.world)*100
from PortifolioProject..[dbo.TotalCases] as TCases
join PortifolioProject..[dbo.TotalDeaths] as TDeaths
on TCases.date = TDeaths.date
where TDeaths.world >= 1
--order by 3,4
)
select *, (RollingWorldDeaths/world)*100 
from CasesvsDeaths 

--2
with CasesvsDeaths (date, Africa, RollingAfricaDeaths) 
as 
(
select TCases.date, TCases.Africa
, sum(convert(int,TDeaths.Africa)) over (Partition by TCases.Africa) as RollingAfricaDeaths
--, (RollingAfricaDeaths/TCases.Africa)*100
from PortifolioProject..[dbo.TotalCases] as TCases
join PortifolioProject..[dbo.TotalDeaths] as TDeaths
on TCases.date = TDeaths.date
where TDeaths.Africa is not null
--order by 3,4
)
select *, (RollingAfricaDeaths/Africa)*100 
from CasesvsDeaths 

--3
with CasesvsDeaths (date, Asia, RollingAsiaDeaths) 
as 
(
select TCases.date, TCases.Asia
, sum(convert(int,TDeaths.Asia)) over (Partition by TCases.Asia) as RollingAsiaDeaths
--, (RollingAsiaDeaths/TCases.Asia)*100
from PortifolioProject..[dbo.TotalCases] as TCases
join PortifolioProject..[dbo.TotalDeaths] as TDeaths
on TCases.date = TDeaths.date
where TDeaths.Asia is not null
--order by 3,4
)
select *, (RollingAsiaDeaths/Asia)*100 
from CasesvsDeaths 

--4
with CasesvsDeaths (date, Europe, RollingEUropeDeaths) 
as 
(
select TCases.date, TCases.Europe
, sum(convert(int,TDeaths.Europe)) over (Partition by TCases.Europe) as RollingEuropeDeaths
--, (RollingEuropeDeaths/TCases.Europe)*100
from PortifolioProject..[dbo.TotalCases] as TCases
join PortifolioProject..[dbo.TotalDeaths] as TDeaths
on TCases.date = TDeaths.date
where TDeaths.Europe is not null
--order by 3,4
)
select *, (RollingEuropeDeaths/Europe)*100 
from CasesvsDeaths 


--Using Temp Tables
--1

create table #PercentAfricaCDs
(
    date datetime,
    Africa numeric,
    RollingAfricaDeaths numeric
)
 insert into #PercentAfricaCDs
select TCases.date, TCases.Africa
, sum(convert(int,TDeaths.Africa)) over (Partition by TCases.Africa) as RollingAfricaDeaths
--, (RollingAfricaDeaths/TCases.Africa)*100
from PortifolioProject..[dbo.TotalCases] as TCases
join PortifolioProject..[dbo.TotalDeaths] as TDeaths
on TCases.date = TDeaths.date
where TDeaths.Africa is not null
--order by 3,4

select *, (RollingAfricaDeaths/Africa)*100 
from #PercentAfricaCDs

--2

drop table if exists #PercentAsiaCDs
create table #PercentAsiaCDs
(
    date datetime,
    Asia numeric,
    RollingAsiaDeaths numeric
)
 insert into #PercentAsiaCDs
select TCases.date, TCases.Asia
, sum(convert(int,TDeaths.Asia)) over (Partition by TCases.Asia) as RollingAsiaDeaths
--, (RollingAsiaDeaths/TCases.Asia)*100
from PortifolioProject..[dbo.TotalCases] as TCases
join PortifolioProject..[dbo.TotalDeaths] as TDeaths
on TCases.date = TDeaths.date
where TDeaths.Asia is not null
--order by 3,4

select *, (RollingAsiaDeaths/Asia)*100 
from #PercentAsiaCDs

--3

drop table if exists #PercentEuropeCDs
create table #PercentEuropeCDs
(
    date datetime,
    Europe numeric,
    RollingEuropeDeaths numeric
)
 insert into #PercentEuropeCDs
select TCases.date, TCases.Europe
, sum(convert(int,TDeaths.Europe)) over (Partition by TCases.Europe) as RollingEuropeDeaths
--, (RollingEuropeDeaths/TCases.Europe)*100
from PortifolioProject..[dbo.TotalCases] as TCases
join PortifolioProject..[dbo.TotalDeaths] as TDeaths
on TCases.date = TDeaths.date
where TDeaths.Europe is not null
--order by 3,4

select *, (RollingEuropeDeaths/Europe)*100 
from #PercentEuropeCDs 

-- Creating views

create view PercentAfricaCDs as
select TCases.date, TCases.Africa
, sum(convert(int,TDeaths.Africa)) over (Partition by TCases.Africa) as RollingAfricaDeaths
--, (RollingAfricaDeaths/TCases.Africa)*100
from PortifolioProject..[dbo.TotalCases] as TCases
join PortifolioProject..[dbo.TotalDeaths] as TDeaths
on TCases.date = TDeaths.date
where TDeaths.Africa is not null
--order by 3,4

--2

create view PercentAsiaCDs as
select TCases.date, TCases.Asia
, sum(convert(int,TDeaths.Asia)) over (Partition by TCases.Asia) as RollingAsiaDeaths
--, (RollingAsiaDeaths/TCases.Asia)*100
from PortifolioProject..[dbo.TotalCases] as TCases
join PortifolioProject..[dbo.TotalDeaths] as TDeaths
on TCases.date = TDeaths.date
where TDeaths.Asia is not null
--order by 3,4

--3

create view PercentEuropeCDs as
select TCases.date, TCases.Europe
, sum(convert(int,TDeaths.Europe)) over (Partition by TCases.Europe) as RollingEuropeDeaths
--, (RollingEuropeDeaths/TCases.Europe)*100
from PortifolioProject..[dbo.TotalCases] as TCases
join PortifolioProject..[dbo.TotalDeaths] as TDeaths
on TCases.date = TDeaths.date
where TDeaths.Europe is not null
--order by 3,4