-- QUESTIONS

-- What is the gender distribution of employees in the company?
SELECT gender, COUNT(*) AS count
FROM hr
WHERE termdate IS NULL
GROUP BY gender;

-- What is the race/ethnicity distribution of the employees?
SELECT race, COUNT(*) AS count
FROM hr
WHERE termdate is NULL
GROUP BY race
ORDER BY count DESC;


-- What is the age distribution of the emplpoyees?
SELECT 
	min(age) AS youngest,
    max(age) AS oldest
FROM hr
WHERE termdate IS NULL;

SELECT 
	CASE 
		WHEN age >= 18 AND age <= 24 THEN '18-24'
        WHEN age >= 25 AND age <= 34 THEN '25-34'
        WHEN age >= 35 AND age <= 44 THEN '35-44'
        WHEN age >= 45 AND age <= 54 THEN '45-54'
		WHEN age >= 55 AND age <= 64 THEN '55-64'
        ELSE '65+'
	END AS age_group,
    COUNT(*) as count
FROM hr
WHERE termdate IS NULL
GROUP BY age_group
ORDER BY age_group;
        

SELECT 
	CASE 
		WHEN age >= 18 AND age <= 24 THEN '18-24'
        WHEN age >= 25 AND age <= 34 THEN '25-34'
        WHEN age >= 35 AND age <= 44 THEN '35-44'
        WHEN age >= 45 AND age <= 54 THEN '45-54'
		WHEN age >= 55 AND age <= 64 THEN '55-64'
        ELSE '65+'
	END AS age_group,
    gender,
    COUNT(*) as count
FROM hr
WHERE termdate IS NULL
GROUP BY age_group, gender
ORDER BY age_group, gender;

-- How many employees work at the headquaters vs remotely
SELECT location, COUNT(*) as count
FROM hr
WHERE termdate IS NULL
GROUP BY location;

-- What is the average length of employment for terminated staff
SELECT round(avg(timestampdiff(YEAR, hire_date, termdate)), 0) as avg_employment_length
FROM hr
WHERE termdate <= curdate() AND termdate IS NOT NULL;

-- What is the average length of employment for terminated staff per department
SELECT department, round(avg(timestampdiff(YEAR, hire_date, termdate)), 0) as avg_employment_length
FROM hr
WHERE termdate <= curdate() AND termdate IS NOT NULL
GROUP BY department;

-- What is the gender distribution across departments and jobtitles
SELECT department, gender, COUNT(*) as distribution
FROM hr
WHERE termdate IS NOT NULL
GROUP BY department, gender
ORDER BY department, distribution DESC;

-- What is the distribution of job titles 
SELECT jobtitle, count(*) as count
FROM hr
WHERE termdate IS NULL
GROUP BY jobtitle 
ORDER BY jobtitle DESC;

-- Termination rate per department
SELECT department,
	total_count,
    termination_count,
    termination_count/total_count AS termination_rate
FROM
    (SELECT department,
	COUNT(*) as total_count,
    SUM(CASE WHEN termdate IS NOT NULL AND termdate <= curdate() THEN 1 ELSE 0 END) AS termination_count
FROM hr
GROUP BY department
) AS subquery
ORDER BY termination_rate DESC;

-- Distribution of staff by location
SELECT location_state, count(*) AS employee_count 
FROM hr
WHERE termdate IS NOT NULL
GROUP BY location_state
ORDER BY employee_count DESC;

-- Turnover rate per year
SELECT year,
	hires,
    terminations,
    hires-terminations AS net_change,
    round(((hires-terminations) /hires * 100), 2) AS net_change_percentage
FROM(
	SELECT 
		YEAR(hire_date) as year,
		COUNT(*) as hires,
		SUM(CASE WHEN termdate IS NOT NULL AND termdate <= curdate() THEN 1 ELSE 0 END) as terminations
	FROM hr
	GROUP BY YEAR(hire_date)
	) AS subquery
ORDER BY year;

-- Average tenure per department
SELECT department, ROUND(AVG(DATEDIFF(CURDATE(), termdate)/365),0) as avg_tenure
FROM hr
WHERE termdate <= CURDATE() AND termdate IS NOT NULL
GROUP BY department;

select * from hr