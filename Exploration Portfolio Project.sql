--Covid 19 Data Exploration 

--Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types

Select *
From PortfolioProject..CovidDeaths
Order by 3,4

--Select *
--From PortfolioProject..CovidVaccinations
--Order by 3,4


Select Location, Date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
Order by 1,2

-- Looking at Total Cases vs Total Deaths
-- Shows Likelihood of death by country

Select Location, Date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
Where location like '%states%'
Order by 1,2

-- Loking at Total Cases vs Population
-- Shows what percentage of the population got Covid

Select Location, Date, population, total_cases, (total_cases/population)*100 as PercentofInfection
From PortfolioProject..CovidDeaths
Where location like '%states%'
Order by 1,2

-- Looking at countries with highest infection rate compared to Population

Select Location, population, Max(total_cases) as HighestInfectionCount, Max((total_cases/population))*100 as PercentofInfection
From PortfolioProject..CovidDeaths
Group by location, population
Order by PercentofInfection desc 

--Creating view for later visualization

Use PortfolioProject
Go
Create View InfectionRateByCountry as 
Select Location, population, Max(total_cases) as HighestInfectionCount, Max((total_cases/population))*100 as PercentofInfection
From PortfolioProject..CovidDeaths
Group by location, population

-- Showing the Countries With the Highest Death Count per Population

Select Location, Max(Cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
where continent is not NULL
Group by location
Order by TotalDeathCount desc 

--Creating view for later visualization

Use PortfolioProject
Go
Create View DeathCountByCountry as 
Select Location, Max(Cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
where continent is not NULL
Group by location


-- Showing Continents with the highest death Count per population

Select continent, Max(Cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
where continent is not NULL
Group by continent
Order by TotalDeathCount desc

--Creating View for Later Visualization

Use PortfolioProject
Go
Create View DeathCountByContinent as 
Select continent, Max(Cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
where continent is not NULL
Group by continent


-- global Numbers by day

Select  Date, Sum(new_cases) as TotalCases, sum(Cast(New_deaths as int)) as TotalDeaths,
SUM(CAST(New_deaths AS INT)) / NULLIF(SUM(New_cases), 0) * 100 AS DeathPercentage
From PortfolioProject..CovidDeaths
Where Continent is not null
Group by date
Order by 1, 2

-- global in total

Select Sum(new_cases) as TotalCases, sum(Cast(New_deaths as int)) as TotalDeaths, sum(Cast(New_deaths as int))/sum(new_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
Where Continent is not null
Order by 1, 2

--Looking at Total Population vs Vaccinations

Select Dea.Continent, Dea.Location, Dea.date, Dea.Population, Vac.new_vaccinations
, Sum(Cast(Vac.new_vaccinations as Bigint)) Over (partition by Dea.Location order by Dea.location, Dea.Date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths Dea
Join PortfolioProject..CovidVaccinations Vac
	on dea.Location = Vac.location
	and Dea.Date = Vac.Date
Where dea.Continent is not null
Order by 2,3

--CTE for Above Script

With PopvsVac (continent, location, Date, population, New_Vaccinations, rollingpeoplevaccinated)
as
(
Select Dea.Continent, Dea.Location, Dea.date, Dea.Population, Vac.new_vaccinations
, Sum(Cast(Vac.new_vaccinations as bigint)) Over (partition by Dea.Location order by Dea.location, Dea.Date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths Dea
Join PortfolioProject..CovidVaccinations Vac
	on dea.Location = Vac.location
	and Dea.Date = Vac.Date
Where dea.Continent is not null
)
Select *, (rollingpeopleVaccinated/population)*100
From PopvsVac

-- Alternitive option for CTE above - Temp Table

Drop table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent Nvarchar(255),
Location Nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
rollingPeopleVaccinated Numeric
)

Insert into #PercentPopulationVaccinated
Select Dea.Continent, Dea.Location, Dea.date, Dea.Population, Vac.new_vaccinations
, Sum(Cast(Vac.new_vaccinations as bigint)) Over (partition by Dea.Location order by Dea.location, Dea.Date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths Dea
Join PortfolioProject..CovidVaccinations Vac
	on dea.Location = Vac.location
	and Dea.Date = Vac.Date
Order by 2,3

Select *, (rollingpeopleVaccinated/population)*100
From #PercentPopulationVaccinated


--Creating View to Store Data for Visualizations

Use PortfolioProject
Go
Create View PercentPopulationVaccinated as 
Select Dea.Continent, Dea.Location, Dea.date, Dea.Population, Vac.new_vaccinations
, Sum(Cast(Vac.new_vaccinations as int)) Over (partition by Dea.Location order by Dea.location, Dea.Date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths Dea
Join PortfolioProject..CovidVaccinations Vac
	on dea.Location = Vac.location
	and Dea.Date = Vac.Date
Where dea.continent is not null

