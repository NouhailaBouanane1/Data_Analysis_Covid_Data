
Select * 
From dbo.CovidDeaths
Where continent is not null


Select location,date,population,total_cases,new_cases,total_deaths
From dbo.CovidDeaths
Order by 1,2


--Total Cases VS Total Death
Select location,date,total_cases,total_deaths,((total_deaths/total_cases)*100) As 'death_over_cases%'
From dbo.CovidDeaths
where location like '%Morocco%'
Order By date,location


--Total Cases VS Population
Select location,date,total_cases,population,((total_cases/population)*100) As 'cases_over_population%'
From dbo.CovidDeaths
where location like '%Morocco%'
Order By date,location


--Countries that has the most cases
Select Top 10 location,population,MAX(total_cases) As 'max_cases', MAX((total_cases/population)*100) As 'max_cases_over_population%'
From dbo.CovidDeaths
Group By location,population
Order By 'max_cases_over_population%' desc


--Countries that has the most death number
Select location,population,MAX(cast (total_deaths As int)) As 'max_death'
From dbo.CovidDeaths
Where continent is not null
Group By location,population
Order By 'max_death' desc


--Countries that has the most death number over population
Select location,population,MAX(cast (total_deaths As int)) As 'max_death', MAX((total_deaths/population)*100) As 'max_death_over_population%'
From dbo.CovidDeaths
Where continent is not null
Group By location,population
Order By 'max_death_over_population%' desc


--Continents that has the most death number over population
Select continent,MAX(cast (total_deaths As int)) As 'max_death'
From dbo.CovidDeaths
Where continent is not null
Group By continent
Order By 'max_death' desc

--sum of new cases and new death on every day 
Select date, Sum(new_cases) As 'sum_new_cases',Sum(cast (new_deaths as int))As 'sum_new_deaths'
From dbo.CovidDeaths
Group By date
Order By 1


--sum of all new cases and new death 
Select Sum(new_cases) As 'sum_new_cases',Sum(cast (new_deaths as int))As 'sum_new_deaths'
From dbo.CovidDeaths


--CovidVaccinations table
Select * 
From dbo.CovidVaccinations

--Join the 2 tables
Select * 
From dbo.CovidVaccinations  Vaccinations
join dbo.CovidDeaths  Deaths
on Vaccinations.location=Deaths.location
and Vaccinations.date=Deaths.date

 --sum of vaccination over date in all countries
Select Deaths.continent,Deaths.location, Deaths.date, Deaths.population, Vaccinations.new_vaccinations,
Sum(Cast (new_vaccinations as int)) Over (Partition By Deaths.location Order By Deaths.date) As 'sum_new_vaccination'
From dbo.CovidVaccinations  Vaccinations
join dbo.CovidDeaths  Deaths
on Vaccinations.location=Deaths.location
and Vaccinations.date=Deaths.date
where Deaths.continent is not null

--percentage of vaccinated people over country by date
With Vac_over_Country(date, continent, location,population,new_vaccinations,new_vaccinations_over_country_percentage) 
As(
Select Deaths.date, Deaths.continent, Deaths.location,Deaths.population,Vaccination.new_vaccinations,
((Sum(Cast(Vaccination.new_vaccinations as int)) Over (Partition By Deaths.location  order by Deaths.location,Deaths.date ) )/ Deaths.population)*100 AS 'new_vaccinations_over_country%' 
From dbo.CovidDeaths Deaths
join dbo.CovidVaccinations Vaccination
On Deaths.location=Vaccination.location
and Deaths.date=Vaccination.Date
Where Deaths.continent is not null
)
Select * From Vac_over_Country


