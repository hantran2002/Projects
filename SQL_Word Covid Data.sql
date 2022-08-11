select * from Covid_Deaths

Alter table Covid_Deaths
Drop Column F10, F11, F12, F13, F14, F15, F16, F17, F18, F19, F20, F21, F22, F23, F24, F25, F26, F27, F28, F29, F30, F31, F32, F33, F34, F35, F36, F37, F38, F39

-- Show Covid total_cases for each location
SELECT location, sum(total_cases) as Total_cases_per_area
FROM Covid_Deaths 
WHERE continent is not null
GROUP BY location


-- Show the highest total_cases per population for each location
SELECT location, population, max(total_cases/population)*100 as Percentage_Infected_Rate
FROM Covid_Deaths
GROUP BY location, population
ORDER BY Percentage_Infected_Rate DESC

--Show the highest total_deaths per population for each location
SELECT location, population, max(total_deaths/population)*100 as Percentage_Death_Rate
FROM Covid_Deaths
GROUP BY location, population
ORDER BY Percentage_Death_Rate DESC

-- Using CTE to perform Calculation on Partition By
With Population_vs_Vac (Continent, Location, Date, Population, New_Vaccinations, PeopleVaccinated)
as
(
Select d.continent, d.location, d.date, d.population, v.new_vaccinations
, SUM(CONVERT(int,v.new_vaccinations)) OVER (Partition by d.Location Order by d.location, d.Date) as PeopleVaccinated
From Covid_Deaths d
Join Covid_Vaccinations v
	On d.location = v.location
	and d.date = v.date
where d.continent is not null 
)
Select *, (PeopleVaccinated/Population)*100 as People_vaccinated_Rate
From Population_vs_Vac


-- Create View for later visualizations
Create View Population_vs_Mac as
Select d.continent, d.location, d.date, d.population, v.new_vaccinations
, SUM(CONVERT(int,v.new_vaccinations)) OVER (Partition by d.Location Order by d.location, d.Date) as PeopleVaccinated
From Covid_Deaths d
Join Covid_Vaccinations v
	On d.location = v.location
	and d.date = v.date
where d.continent is not null 





