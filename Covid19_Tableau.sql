/*
Covid-19 Queries used for Tableau Project
*/

-- Death Percentage in New Cases
select sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths,
		sum(new_deaths)/sum(new_cases)*100 as DeathPercentage
from coviddeaths
where continent is not null;

select location, sum(new_deaths) as totalDeathCount
from coviddeaths
where continent is null
and location not in ('World', 'European Union', 'International', 'High income', 'Upper middle income'
					, 'Lower middle income', 'Low income')
group by location
order by 2 desc;

select location, population, max(total_cases) as highestinfectionCount, max(total_cases/population)*100 as percentpopulationinfected
from coviddeaths
group by 1, 2
order by percentpopulationinfected desc;

select location, population, date, max(total_cases) as highestinfectedCount, max(total_cases/population)*100 as percentpopulationinfected
from coviddeaths
group by 1, 2, 3
order by percentpopulationinfected;




