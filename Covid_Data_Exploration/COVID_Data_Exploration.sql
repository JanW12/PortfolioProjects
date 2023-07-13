/*
Written in MySQL workbench
Covid 19 Data Exploration 
Skills used: Joins, CTE's(Common Table Expression), Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types
*/
use portfolio

Select *
From portfolio.coviddeaths
Where continent is not null 
order by 3, 4


-- Select Data that we are going to be starting with

Select Location, date, total_cases, new_cases, total_deaths, population
From portfolio.coviddeaths
Where continent is not null 
order by 1,2


-- Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in your country

Select Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From portfolio.coviddeaths
Where location like '%states%'
and continent is not null 
order by 1,2;


-- Total Cases vs Population
-- Shows what percentage of population infected with Covid

Select Location, date, Population, total_cases,  (total_cases/population)*100 as PercentPopulationInfected
From portfolio.coviddeaths
order by 1,2


-- Countries with Highest Infection Rate compared to Population

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From portfolio.coviddeaths
Group by Location, Population
order by PercentPopulationInfected desc


-- Countries with Highest Death Count per Population, for some reason query is ignoring my "where continent is not null" which I wrote to ignore continents in location column so I manually limited it

Select Location, MAX(cast(Total_deaths as signed)) as TotalDeathCount
From portfolio.coviddeaths
where continent IS NOT NULL
Group by Location
order by TotalDeathCount desc
LIMIT 200 OFFSET 4



-- BREAKING THINGS DOWN BY CONTINENT

-- Showing contintents with the highest death count per population

Select continent, MAX(cast(Total_deaths as signed)) as TotalDeathCount
From portfolio.coviddeaths
Where continent is not null 
Group by continent
order by TotalDeathCount desc



-- GLOBAL NUMBERS

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as signed)) as total_deaths, SUM(cast(new_deaths as signed))/SUM(New_Cases)*100 as DeathPercentage
From portfolio.coviddeaths
where continent is not null 
order by 1,2



-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(vac.new_vaccinations, signed)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From portfolio.coviddeaths dea
Join portfolio.covidvaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3


-- First solution - Using CTE to perform Calculation on Partition By in previous query

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(vac.new_vaccinations, signed)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From portfolio.coviddeaths dea
Join portfolio.covidvaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac



-- Second solution - Using Temp Table to perform Calculation on Partition By in previous query. Mysql converts warnings into errors so I found solution and added sql_mode='' to make it works

DROP Table if exists PercentPopulationVaccinated
SET sql_mode = ''
Create temporary Table PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(vac.new_vaccinations, signed)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From portfolio.coviddeaths dea
Join portfolio.covidvaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date

Select *, (RollingPeopleVaccinated/Population)*100
From PercentPopulationVaccinated




-- Third solution - Creating View to store data for later visualizations or analysis

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(vac.new_vaccinations, signed)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From portfolio.coviddeaths dea
Join portfolio.covidvaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 