
-- Query 1: Top 5 districts with most professional colleges
SELECT District, COUNT(DISTINCT CollegeName) AS CollegeCount
FROM CollegeCourses
WHERE IsProfessional = 'Professional Course'
GROUP BY District
ORDER BY CollegeCount DESC
LIMIT 5;

-- Query 2: Average course duration by course type
SELECT CourseType, AVG(DurationMonths) AS AvgDuration
FROM CollegeCourses
GROUP BY CourseType
ORDER BY AvgDuration DESC;

-- Query 3: Unique college count per course category
SELECT CourseCategory, COUNT(DISTINCT CollegeName) AS CollegeCount
FROM CollegeCourses
GROUP BY CourseCategory;

-- Query 4: Colleges offering both UG and PG
SELECT DISTINCT a.CollegeName
FROM CollegeCourses a
JOIN CollegeCourses b ON a.CollegeName = b.CollegeName
WHERE a.CourseType = 'Under Graduate' AND b.CourseType = 'Post Graduate';

-- Query 5: Universities with more than 10 unaided, non-professional courses
SELECT University, COUNT(*) AS CourseCount
FROM CollegeCourses
WHERE IsAided = 'Unaided' AND IsProfessional = 'Non-Professional Course'
GROUP BY University
HAVING COUNT(*) > 10;

-- Query 6: Colleges in Engineering category with course duration > category avg
WITH category_avg AS (
  SELECT AVG([Course Duration (In months)]) AS avg_duration
  FROM CollegeCourses
  WHERE [Course Category] = 'Engineering'
)
SELECT DISTINCT [College Name]
FROM CollegeCourses, category_avg
WHERE [Course Category] = 'Engineering'
  AND [Course Duration (In months)] > avg_duration;
  
-- Query 7: Rank each course within a college by duration
SELECT [College Name], [Course Name], [Course Duration (In months)],
       RANK() OVER (PARTITION BY [College Name] ORDER BY [Course Duration (In months)] DESC) AS DurationRank
FROM CollegeCourses;

-- Query 8: Colleges where longest and shortest course durations differ > 24 months
SELECT College Name
FROM CollegeCourses
GROUP BY [College Name]
HAVING MAX([Course Duration (In months)]) - MIN([Course Duration (In months)]) > 24;
✅ 
-- Query 9: Cumulative number of professional courses by university
SELECT University, COUNT(*) AS ProfessionalCourseCount
FROM CollegeCourses
WHERE [Is Professional] = 'Professional Course'
GROUP BY University
ORDER BY University;

-- Query 10: Colleges offering more than one course category
SELECT [College Name]
FROM CollegeCourses
GROUP BY [College Name]
HAVING COUNT(DISTINCT [Course Category]) > 1;

-- Query 11: Talukas with average duration > district average
WITH district_avg AS (
  SELECT District, AVG([Course Duration (In months)]) AS district_avg
  FROM CollegeCourses
  GROUP BY District
),
taluka_avg AS (
  SELECT District, Taluka, AVG([Course Duration (In months)]) AS taluka_avg
  FROM CollegeCourses
  GROUP BY District, Taluka
)
SELECT taluka_avg.District, taluka_avg.Taluka, taluka_avg.taluka_avg
FROM taluka_avg
JOIN district_avg ON taluka_avg.District = district_avg.District
WHERE taluka_avg.taluka_avg > district_avg.district_avg;

 -- Query 12: Classify duration and count per course category
SELECT [Course Category],
       CASE 
         WHEN [Course Duration (In months)] < 12 THEN 'Short'
         WHEN [Course Duration (In months)] BETWEEN 12 AND 36 THEN 'Medium'
         ELSE 'Long'
       END AS DurationType,
       COUNT(*) AS CourseCount
FROM CollegeCourses
GROUP BY [Course Category], DurationType;

-- Query 13: Extract specialization from Course Name
SELECT [Course Name],
       TRIM(SUBSTR([Course Name], INSTR([Course Name], '-') + 1)) AS Specialization
FROM CollegeCourses
WHERE [Course Name] LIKE '%-%';

-- Query 14: Count of courses with the word "Engineering"
SELECT COUNT(*) AS EngineeringCourseCount
FROM CollegeCourses
WHERE [Course Name] LIKE '%Engineering%';

-- Query 15: Unique combinations of Course Name, Course Type, and Course Category
SELECT DISTINCT [Course Name], [Course Type], [Course Category]
FROM CollegeCourses;

-- Query 16: Courses not offered by Government colleges
SELECT *
FROM CollegeCourses
WHERE [College Type] != 'Government';

-- Query 17: University with 2nd highest number of aided courses
SELECT University, COUNT(*) AS AidedCourses
FROM CollegeCourses
WHERE [Course (Aided / Unaided)] = 'Aided'
GROUP BY University
ORDER BY AidedCourses DESC
LIMIT 1 OFFSET 1;

-- Query 18: Courses with durations above the median
WITH ordered_courses AS (
  SELECT *, 
         PERCENT_RANK() OVER (ORDER BY [Course Duration (In months)]) AS pr
  FROM CollegeCourses
)
SELECT *
FROM ordered_courses
WHERE pr > 0.5;

-- Query 19: % of unaided courses that are professional, per university
SELECT University,
       ROUND(
         SUM(CASE WHEN [Is Professional] = 'Professional Course' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
         2
       ) AS ProfessionalPercent
FROM CollegeCourses
WHERE [Course (Aided / Unaided)] = 'Unaided'
GROUP BY University;

-- Query 20: Top 3 course categories with highest average duration
SELECT [Course Category],
       AVG([Course Duration (In months)]) AS AvgDuration
FROM CollegeCourses
GROUP BY [Course Category]
ORDER BY AvgDuration DESC
LIMIT 3;


