select *
From PortfolioProject..CovidDeaths 
where continent is not null
order by 3,4
--select *
--From PortfolioProject..CovidVaccinations
--order by 3,4

select Location, date, total_cases, new_cases,total_deaths, population 
from PortfolioProject..CovidDeaths
where continent is not null
order by 1,2

select Location ,date ,total_cases ,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
where continent is not null
where location like '%india%'
order by 1,2

select Location ,date ,total_cases ,population, (total_cases/population)*100 as PercentageofpopulationINfected
From PortfolioProject..CovidDeaths
where continent is not null
where location like '%india%'
order by 1,2


  select Location ,Max(total_cases) as HighestInfectionCount ,population, Max(total_cases/population)*100 as PercentageofpopulationINfected
From PortfolioProject..CovidDeaths
where continent is not null
--where location like '%india%'
group by location, Population
order by PercentageofpopulationINfected desc

select Location , Max(cast(Total_deaths as int)) as totaldeathcount
From PortfolioProject..CovidDeaths
where continent is null
--where location like '%india%'
group by location, Population
order by totaldeathcount desc


select continent , Max(cast(Total_deaths as int)) as totaldeathcount
From PortfolioProject..CovidDeaths
where continent is not null
--where location like '%india%'
group by continent
order by totaldeathcount desc

--showing  continents with height death count per popultaion 

select continent , Max(cast(Total_deaths as int)) as totaldeathcount
From PortfolioProject..CovidDeaths
where continent is not null
--where location like '%india%'
group by continent
order by totaldeathcount desc

--Global Numbers
select  date ,Sum(new_cases) as total_cases, Sum(cast(new_deaths as int)) as total_deaths, Sum(cast(new_deaths as int))/sum(new_cases)*100 as Deathpecentage
from PortfolioProject..CovidDeaths
--where location like '%states%'
where continent is not null 
Group by date 
order by 1,2

--total cases
select Sum(new_cases) as total_cases, Sum(cast(new_deaths as int)) as total_deaths, Sum(cast(new_deaths as int))/sum(new_cases)*100 as Deathpecentage
from PortfolioProject..CovidDeaths
--where location like '%states%'
where continent is not null 
--Group by date 
order by 1,2

-- total popultaion vs vaccinations
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, Sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.Date) as RollingPeopleVaccinated 
--,(RollingpeopleVaccinated/population)*100
from PortfolioProject..Coviddeaths dea
join PortfolioProject..CovidVaccinations vac
  on dea.location = vac.location 
   and dea.date = vac.date
   where dea.continent is not null
   order by 2,3


   -- use cte

   with Popvsvac (continent, location, date, population, New_vaccinations, RollingPeopleVaccinated )
   as
   (
   select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, Sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.Date) as RollingPeopleVaccinated 
--,(RollingpeopleVaccinated/population)*100
from PortfolioProject..Coviddeaths dea
join PortfolioProject..CovidVaccinations vac
  on dea.location = vac.location 
   and dea.date = vac.date
   where dea.continent is not null
   --order by 2,3
   )

   select * , (RollingPeopleVaccinated/population)*100
   From Popvsvac



   -- temp table 

   Drop table if exists #PercentPopulaitonVaccinated
   create Table #PercentPopulaitonVaccinated
   (
   continent nvarchar(255),
   location nvarchar(255),
   Date datetime,
   Population numeric,
   New_vacciantions numeric,
   rollingpeopleVaccinated numeric
   )

   insert into #PercentPopulaitonVaccinated 
   select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, Sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.Date) as RollingPeopleVaccinated 
--,(RollingpeopleVaccinated/population)*100
from PortfolioProject..Coviddeaths dea
join PortfolioProject..CovidVaccinations vac
  on dea.location = vac.location 
   and dea.date = vac.date
   where dea.continent is not null
   --order by 2,3

   select * , (RollingPeopleVaccinated/population)*100
   From #PercentPopulaitonVaccinated

   --creating view to store data for view
   
   
   create View PercentPopulaitonVaccinated as 
   select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, Sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.Date) as RollingPeopleVaccinated 
--,(RollingpeopleVaccinated/population)*100
from PortfolioProject..Coviddeaths dea
join PortfolioProject..CovidVaccinations vac
  on dea.location = vac.location 
   and dea.date = vac.date
   where dea.continent is not null
  --order by 2,3

  select * 
  from PercentPopulaitonVaccinated