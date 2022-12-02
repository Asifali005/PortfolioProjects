/****** Script for SelectTopNRows command from SSMS  ******/
SELECT *
  FROM [Projects].[dbo].[covid_deaths$]
  where continent is not null
  order by 3,4


  --select *
  --from [Projects].[dbo].[covid_vaccinations$]
  ----order by 3,4

  --Select Data that we are going to be using

  select location, date, total_cases, new_cases, total_deaths, population
  from [Projects].[dbo].[covid_deaths$]
  where continent is not null
  order by 1,2

  --looking at Total Cases vs Total Deaths

    select location, date, total_cases, total_deaths,(Total_deaths/total_cases)*100 as Death_percentage
  from [Projects].[dbo].[covid_deaths$]
  where location = 'India'
  and continent is not null
  and total_deaths is not null
  order by 1,2

  --Looking at total cases vs population
  --Shows what percetage of popluation infected with covid

   select location, date, population, total_cases,(Total_deaths/population)*100 as Death_percentage
  from [Projects].[dbo].[covid_deaths$]
  --where location = 'India'
  where total_deaths is not null
  order by 1,2

  --Countries with highest infection rate compared to population

  select location, Population, Max(total_cases) as highest_infection_count, max( total_cases/population)*100 as  percentage_population_infected
  from [Projects].[dbo].[covid_deaths$]
  group by Location, population
  order by percentage_population_infected desc

  --showing countries with highest death count per polulation

  select location, max(cast (total_deaths as int)) as total_death_counts
    from [Projects].[dbo].[covid_deaths$]
	where continent is not null
	group by Location, population
	order by total_death_counts desc

	-- LET'S BREAK THINGS DOWN BY CONTINENT

	-- Showing the continent with the highest death count as per population


 select continent, max(cast (total_deaths as int)) as total_death_counts
    from [Projects].[dbo].[covid_deaths$]
	where continent is not null
	group by continent
	order by total_death_counts desc


	
	-- Global Numbers

select  date, sum(new_cases)as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as Death_ercentage
    from [Projects].[dbo].[covid_deaths$]
	where continent is not null
	group by date
	order by 1,2


select sum(new_cases)as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as Death_percentage
    from [Projects].[dbo].[covid_deaths$]
	where continent is not null
	--group by date
	order by 1,2


--Looking at Total Population vs Vaccinations

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(bigint,vac.new_vaccinations )) over (partition by dea.location order by dea.location,
 dea.date) as Rollingpeoplevaccinated
  --,(Rollingpeoplevaccinated/population)*100
	 from [Projects].[dbo].[covid_deaths$] dea
	 join [Projects].[dbo].[covid_vaccinations$] vac
	 on dea.location = vac.location
	 and dea.date = vac.date
	 where dea.continent is not null
	 order by 2,3


--USE CTE 

With PopvsVac ( Continent, Location, Date, Population,New_Vaccination, rollingpeoplevaccinated)
as

(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(bigint,vac.new_vaccinations)) over (partition by dea.location order by dea.location,
 dea.date) as Rollingpeoplevaccinated
  --,(Rollingpeoplevaccinated/population)*100
	 from [Projects].[dbo].[covid_deaths$] dea
	 join [Projects].[dbo].[covid_vaccinations$] vac
	 on dea.location = vac.location
	 and dea.date = vac.date
	 where dea.continent is not null
	-- order by 2,3	
)
select *, ( Rollingpeoplevaccinated/Population)*100
from PopvsVac



-- TEMP TABLE

Drop table if exists #PercentpopulationVaccinated
Create table #PercentpopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
Population bigint,
New_vaccination bigint,
RollingpeopleVaccinated bigint
)
Insert into #PercentpopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(bigint,vac.new_vaccinations)) over (partition by dea.location order by dea.location,
 dea.date) as Rollingpeoplevaccinated
  --,(Rollingpeoplevaccinated/population)*100
	 from [Projects].[dbo].[covid_deaths$] dea
	 join [Projects].[dbo].[covid_vaccinations$] vac
	 on dea.location = vac.location
	 and dea.date = vac.date
	 --where dea.continent is not null
	-- order by 2,3	

select *, (Rollingpeoplevaccinated/Population)*100
from #PercentpopulationVaccinated




-- Creating View to store data for later visualization

Create View  PercentpopulationVaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(bigint,vac.new_vaccinations)) over (partition by dea.location order by dea.location,
 dea.date) as Rollingpeoplevaccinated
  --,(Rollingpeoplevaccinated/population)*100
	 from [Projects].[dbo].[covid_deaths$] dea
	 join [Projects].[dbo].[covid_vaccinations$] vac
	 on dea.location = vac.location
	 and dea.date = vac.date
where dea.continent is not null
 --order by 2,3	




 select *
 from PercentpopulationVaccinated







  
