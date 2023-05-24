select *
from PortfolioProject..CovidDeaths
where continent is not null
Order by 3,4


--select *
--from PortfolioProject..CovidVaccinations
--Order by 3,4

Select Location, date, total_cases, total_deaths, (total_deaths/
From PortfolioProject..CovidDeaths 
order by 1,2 

--Select total_deaths, total_cases, location, date, CONVERT(DECIMAL(18, 2), (CONVERT(DECIMAL(18, 2), total_deaths) / CONVERT(DECIMAL(18, 2), total_cases))) as [DeathsOverTotal]
--from PortfolioProject..CovidDeaths
--order by 1,2

Select *
From PortfolioProject..CovidDeaths
Where continent is not null 
order by 3,4

Select Location, date, population, total_cases, (total_cases/Population)*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths
Where location like '%States%'
Order by 1,2

select location, population, MAX(total_cases) as HighestInfectionCount, Max((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
--Where location like '%States%'
Group by location, population
Order by PercentPopulationInfected desc

-- Showing Countries with the highest death count per population

select location, MAX(cast(total_deaths as INT)) as TotalDeathCount
From PortfolioProject..CovidDeaths
--Where location like '%States%'
where continent is not null
Group by location
Order by TotalDeathCount desc

--BREAK IT DOWN BY CONTINENT

select continent, MAX(cast(total_deaths as INT)) as TotalDeathCount
From PortfolioProject..CovidDeaths
--Where location like '%States%'
where continent is not null
Group by location
Order by TotalDeathCount desc

--GLOBAL NUMBERS

Select date, SUM(new_cases)--, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths
 --location like '%States%'
 where continent is not null
 group  by date
Order by 1,2

--looking at total Population vs Vaccinations

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac

 DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null 
--order by 2,3

select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths
where continent is not null
group by continent
order by TotalDeathCount

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
