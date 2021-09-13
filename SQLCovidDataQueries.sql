--Fetch All Data
--Select * 
--From [Portfolio Project]..Corona_Deaths
--Order by 3,4

--Select * 
--From [Portfolio Project]..Corona_Vacc
--Order by 3,4

-- COVID DEATHS DATA SECTION

-- Fetching Testing Data
--Select location,date,total_cases,new_cases,total_deaths,population
--From [Portfolio Project]..Corona_Deaths
--Order by 1,2

-- Total Cases vs Total Deaths Percentage
--Select location,date,total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
--From [Portfolio Project]..Corona_Deaths
--Where location like 'pakistan' and total_deaths  not like 'null'
--Order by 1,2

-- Case Percentage
--Select location,date,population, total_cases, (total_cases/population)*100 as CasePercentage
--From [Portfolio Project]..Corona_Deaths
--Where location like 'pakistan' and total_deaths  not like 'null'
--Order by 3,4

-- Infection Percentage
--Select location,population, MAX(total_cases) as totalInfected, MAX((total_cases/population))*100 as InfectionPercentage
--From [Portfolio Project]..Corona_Deaths
----Where location like 'pakistan' and total_deaths  not like 'null'
--Group by location,population
--Order by population desc


-- Total Cases Order Desc order by continent
--Select location, MAX(CAST(total_deaths as int)) as totalDeaths
--From [Portfolio Project]..Corona_Deaths
--Where continent is null
--Group by location
--Order by totalDeaths desc

-- Global Data
--Select date, SUM(new_cases) as SumOfNewCase,SUM(CAST(new_deaths as int))as SumOfNewDeaths,SUM(CAST(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage --total_deaths,total_cases, total_deaths/total_cases*100 as DeathsPercentage
--From [Portfolio Project]..Corona_Deaths
--Where continent is not null and new_cases is not null 
--Group by date
--Order by date desc

-- BY continent
--Select continent, MAX(CAST(total_deaths as int)) as totalDeaths
--From [Portfolio Project]..Corona_Deaths
--Where continent is not null
--Group by continent
--Order by totalDeaths desc

-- COVID VACCINATION DATA SECTION


-- JOINED TABLES SECTION


-- New Vaccitations 
--Select dea.continent,dea.location, dea.date ,dea.population , vac.new_vaccinations, 
--SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as TotalVaccByDate
--From [Portfolio Project]..Corona_Deaths dea
--Join [Portfolio Project]..Corona_Vacc vac
--	On dea.location = vac.location
--	and dea.date = vac.date
--Where dea.continent is not null
--Order by 2,3 


-- Use CTE
--With PopVsVac (continent, location,date,population,new_vaccinations,TotalVaccByDate)
--as
--(
--Select dea.continent,dea.location, dea.date ,dea.population , vac.new_vaccinations, 
--SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as TotalVaccByDate
--From [Portfolio Project]..Corona_Deaths dea
--Join [Portfolio Project]..Corona_Vacc vac
--	On dea.location = vac.location
--	and dea.date = vac.date
--Where dea.continent is not null
----Order by 2,3
--)
--Select * , (TotalVaccByDate/population)*100 as VaccPercentage
--From PopVsVac

-- Temp Table
--Drop Table if exists #PerPopVac
--Create Table #PerPopVac
--(
--continent nvarchar(255),
--location nvarchar(255),
--data datetime,
--population numeric,
--newVac numeric,
--TotalVaccByDate numeric,
--)
--Insert into #PerPopVac
--Select dea.continent,dea.location, dea.date ,dea.population , vac.new_vaccinations, 
--SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as TotalVaccByDate
--From [Portfolio Project]..Corona_Deaths dea
--Join [Portfolio Project]..Corona_Vacc vac
--	On dea.location = vac.location
--	and dea.date = vac.date
--Where dea.continent is not null and vac.new_vaccinations is not null
----Order by 2,3

--Select * , (TotalVaccByDate/population)*100 as VaccPercentage
--From #PerPopVac


-- View

--Create View ContinentData as 
--Select continent, MAX(CAST(total_deaths as int)) as totalDeaths
--From [Portfolio Project]..Corona_Deaths
--Where continent is not null
--Group by continent

Select * 
From ContinentData