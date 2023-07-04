/*
Covid 19 Data Exploration (2023)
Skills used: Converting Data Types, Joins Tables, Temp Tables, CTE's, Aggregate Functions,
			Windows Functions,  Creating Views.
*/

-- Creating Table for Covid-19 Dataset
create table covid_data(
	iso_code varchar(255),
	continent varchar(255),
	location varchar(255),
	date date,
	total_cases decimal,
	new_cases decimal,
	new_cases_smoothed decimal,
	total_deaths decimal,
	new_deaths decimal,
	new_deaths_smoothed decimal,
	total_cases_per_million decimal,
	new_cases_per_million decimal,
	new_cases_smoothed_per_million decimal,
	total_deaths_per_million decimal,
	new_deaths_per_million decimal,
	new_deaths_smoothed_per_million decimal,
	reproduction_rate decimal,
	icu_patients decimal,	
	icu_patients_per_million decimal,
	hosp_patients decimal,
	hosp_patients_per_million decimal,
	weekly_icu_admissions decimal,	
	weekly_icu_admissions_per_million decimal,
	weekly_hosp_admissions decimal,	
	weekly_hosp_admissions_per_million decimal,
	total_tests decimal,
	new_tests decimal,
	total_tests_per_thousand decimal,
	new_tests_per_thousand decimal,	
	new_tests_smoothed decimal,	
	new_tests_smoothed_per_thousand decimal,
	positive_rate decimal,
	tests_per_case decimal,
	tests_units varchar(255),	
	total_vaccinations decimal,
	people_vaccinated decimal,
	people_fully_vaccinated decimal,
	total_boosters decimal,
	new_vaccinations decimal,
	new_vaccinations_smoothed decimal,
	total_vaccinations_per_hundred decimal,
	people_vaccinated_per_hundred decimal,
	people_fully_vaccinated_per_hundred decimal,
	total_boosters_per_hundred decimal,
	new_vaccinations_smoothed_per_million decimal,
	new_people_vaccinated_smoothed decimal,
	new_people_vaccinated_smoothed_per_hundred decimal,
	stringency_index decimal,
	population_density decimal,
	median_age decimal,
	aged_65_older decimal,
	aged_70_older decimal,
	gdp_per_capita decimal,
	extreme_poverty decimal,
	cardiovasc_death_rate decimal,
	diabetes_prevalence decimal,
	female_smokers decimal,
	male_smokers decimal,
	handwashing_facilities decimal,
	hospital_beds_per_thousand decimal,
	life_expectancy decimal,
	human_development_index decimal,
	population decimal,
	excess_mortality_cumulative_absolute decimal,
	excess_mortality_cumulative decimal,
	excess_mortality decimal,
	excess_mortality_cumulative_per_million decimal
)

drop table covid_data;

-- Copy or import Covid-19 Dataset
-- Sorce: https://ourworldindata.org/coronavirus
copy covid_data 
from '/Applications/PostgreSQL 15/owid-covid-data.csv' 
delimiter ',' CSV Header;

select * from covid_data;

-- Creating CovidDeaths table from original dataset (covid_data)
create table covidDeaths as
select iso_code, continent,	location, date, total_cases, new_cases, new_cases_smoothed, total_deaths,
		new_deaths, new_deaths_smoothed, total_cases_per_million, new_cases_per_million,
		new_cases_smoothed_per_million, total_deaths_per_million,
		new_deaths_per_million,	new_deaths_smoothed_per_million,
		reproduction_rate,	icu_patients,	icu_patients_per_million,	hosp_patients,
		hosp_patients_per_million, weekly_icu_admissions,	weekly_icu_admissions_per_million,
		weekly_hosp_admissions,	weekly_hosp_admissions_per_million,	new_tests,
		total_tests	total_tests_per_thousand,	new_tests_per_thousand,	new_tests_smoothed,
		new_tests_smoothed_per_thousand	positive_rate,	tests_per_case,	tests_units,
		total_vaccinations,	people_vaccinated,	people_fully_vaccinated,	new_vaccinations,
		new_vaccinations_smoothed,	total_vaccinations_per_hundred,	people_vaccinated_per_hundred,
		people_fully_vaccinated_per_hundred,	new_vaccinations_smoothed_per_million,
		stringency_index,	population,	population_density,
		median_age,	aged_65_older,	aged_70_older,
		gdp_per_capita,	extreme_poverty,	cardiovasc_death_rate,
		diabetes_prevalence	female_smokers,	male_smokers,	handwashing_facilities,
		hospital_beds_per_thousand,	life_expectancy	human_development_index
from covid_data;

-- Creating CovidVaccinations table from original dataset (covid_data)
create table covidVaccinations as
	select iso_code	continent, location, date, new_tests, total_tests,
	total_tests_per_thousand,	new_tests_per_thousand,	new_tests_smoothed,
	new_tests_smoothed_per_thousand,	positive_rate,	tests_per_case,
	tests_units	total_vaccinations,	people_vaccinated,	people_fully_vaccinated,
	new_vaccinations,	new_vaccinations_smoothed,	total_vaccinations_per_hundred,
	people_vaccinated_per_hundred,	people_fully_vaccinated_per_hundred,	new_vaccinations_smoothed_per_million,
	stringency_index,	population_density,	median_age,	aged_65_older,	aged_70_older,
	gdp_per_capita,	extreme_poverty	cardiovasc_death_rate,
	diabetes_prevalence,	female_smokers,	male_smokers,	handwashing_facilities,
	hospital_beds_per_thousand,	life_expectancy	human_development_index
from covid_data;


select * from coviddeaths
where continent is not null
order by 3, 4;

select location, date, total_cases, new_cases, total_deaths, population
from coviddeaths
where continent is not null
order by 1, 2;

-- Total Cases vs Total Deaths
-- Show the likihood if we contact covid-19
select continent, date, total_cases, total_deaths, (total_cases/total_deaths)*100 as DeathPercentage
from coviddeaths
where location like '%States%'
and continent is not null
group by continent, date 
order by 1, 2;

-- Looking at the Total cases vs Population
-- Shows what percentage of population got Covid
select location, date, population, total_cases, total_cases/population*100 as PopulationPercentage
from coviddeaths
order by 1, 2;

-- Countries
-- Countries the highest infection rate compared to Population
select location, population, max(total_cases) as HighestInfectionCount, 
		max(total_cases/population)*100 as PercentPopulationInfected
from coviddeaths
group by location, population
order by PercentPopulationInfected desc;

-- Contries with the highest death count per Population
select location, max(cast(total_deaths as int))  as total_death_count
from coviddeaths
where continent is not null
group by location
order by total_death_count desc;

-- Continents
-- Continents with highest death count per population
select continent, max(cast(total_deaths as int))  as total_death_count
from coviddeaths
where continent is not null
group by continent
order by total_death_count desc;

-- Global numbers

select sum(cast(new_deaths as int))/sum(new_cases)*100 from coviddeaths;

select sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths,
		sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
from coviddeaths
where continent is not null
order by 1, 2;


-- Total population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine
select death.continent, death.location, death.date, death.population, cast(vac.new_vaccinations as int), 
		sum(cast(vac.new_vaccinations as int)) 
		over (partition by death.location order by death.location, death.date)
		as RollingPeopleVaccinated
from coviddeaths death
join covidvaccinations vac
on death.location = vac.location 
and death.date = vac.date
where death.continent is not null
order by 2, 3;

-- Use CTM: Common Table Expression
with PopvsVac (Continent, Location, date, population, New_Vaccinations, RollingPeopleVaccinated)
as (
select death.continent, death.location, death.date, death.population, cast(vac.new_vaccinations as int), 
		sum(cast(vac.new_vaccinations as int)) 
		over (partition by death.location order by death.location, death.date)
		as RollingPeopleVaccinated
from coviddeaths death
join covidvaccinations vac
on death.location = vac.location 
and death.date = vac.date
where death.continent is not null
-- order by 2, 3
)
select *, (RollingPeopleVaccinated/Population) * 100 as 
from PopvsVac


-- Temp Table
drop table if exists PercentPopulationVaccinated;
create table PercentPopulationVaccinated
(
	Continent varchar(255),	
	Location varchar(255),
	Date date,
	Population numeric,
	New_vaccinations numeric,
	RollingPeopleVaccinated numeric
)

insert into PercentPopulationVaccinated
select death.continent, death.location, death.date, death.population, cast(vac.new_vaccinations as int), 
		sum(cast(vac.new_vaccinations as int)) 
		over (partition by death.location order by death.location, death.date)
		as RollingPeopleVaccinated
from coviddeaths death
join covidvaccinations vac
on death.location = vac.location 
and death.date = vac.date
-- where death.continent is not null
-- order by 2, 3
select *, (RollingPeopleVaccinated/Population) * 100
from PercentPopulationVaccinated

-- Creating View to store data for later visualazations
create view PercentPopulationVaccinated_view as 
select death.continent, death.location, death.date, death.population, cast(vac.new_vaccinations as int), 
		sum(cast(vac.new_vaccinations as int)) 
		over (partition by death.location order by death.location, death.date)
		as RollingPeopleVaccinated
from coviddeaths death
join covidvaccinations vac
on death.location = vac.location 
and death.date = vac.date
where death.continent is not null




