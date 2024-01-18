# Data Exploration using Covid Data

## project Overview
This project is a comprehensive exploration of COVID-19 data, demonstrating a range of SQL skills and techniques, from basic data retrieval to more advanced concepts like CTEs, window functions, and data visualization preparation.. The primary focus is on analyzing COVID-19 death and vaccination data to extract meaningful insights.

## Technical skills Used
### Creating Views for Visualization
Views like InfectionRateByCountry and DeathCountByCountry are created for later use in visualizations. This step demonstrates foresight in data management, making future data retrieval more efficient for specific analysis purposes.
### Population vs. Vaccination Analysis
This section joins CovidDeaths with CovidVaccinations to analyze vaccination progress. It uses window functions to calculate a rolling total of people vaccinated over time, a critical metric for assessing vaccination campaigns.
### Using CTEs and Temp Tables
The project employs Common Table Expressions (CTEs) and temporary tables to handle complex queries. This demonstrates an understanding of SQL functionality and is beneficial for breaking down complicated data processing into more manageable steps.
### Creating a View for Vaccination Data
A view named PercentPopulationVaccinated is created to store data for future visualizations, showing the percentage of the population vaccinated over time.

## Analytics that I explored  
### Analyzing Total Cases vs. Total Deaths
This part of the project calculates the death percentage by country, providing insights into the severity of the pandemic in different regions. It specifically focuses on the United States (indicated by 'states' in the location filter).
### Examining Total Cases vs. Population
Here, the project looks at what percentage of the population in different locations contracted COVID-19, again with a specific focus on the United States. This analysis helps in understanding the spread of the virus relative to population size.
### Identifying High Infection Rates
The project analyzes countries with the highest infection rate compared to their population, which is crucial for understanding the impact of the virus in different geographical regions.
### Comparing Death Counts
The analysis includes a comparison of death counts across countries and continents, providing a global perspective on the pandemic's impact.
### Global Summary by Day and in Total
The project provides a global summary of new cases and deaths by day, and a total summary, including a calculated death percentage. This temporal analysis is crucial for understanding the dynamics of the pandemic over time.


## Link to Data
https://ourworldindata.org/covid-deaths
