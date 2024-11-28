-- NETFLIX DATA ANALYSIS
-- USE THE DATABASE IN WHICH YOU PERFORM TASK
USE NETFLIX_PROJECT;
-- NOW IMPORT THE CSV FILE USING IMPORT WIZARD 
-- SELECT THE TABLE IN WHICH CSV FILE ARE IMPORTED
SELECT * FROM NETFLIX;
-- NOW CHECK HOW MANY ROWS ARE THERE
SELECT COUNT(*) FROM NETFLIX;

-- 15 problems and their solutions 

-- 1. Count the number of Movies and TV Show
SELECT types_ , count(*) FROM NETFLIX 
GROUP BY types_ ;

-- 2. Find the most common rating for movie and TV Show 
with RatingCounts AS (
SELECT types_ , rating , count(*) as rating_count from NETFLIX 
group by types_, rating 
) ,
RankedRating AS (
SELECT types_ , rating ,rating_count ,RANK() OVER (PARTITION BY types_ ORDER BY rating_count DESC) AS ranking from RatingCounts
)
SELECT types_ ,rating ,rating_count from RankedRating 
WHERE ranking = 1 ;

-- 3. List all the movies released in specific year (eg : 2020)
SELECT * FROM NETFLIX
where types_ = 'Movie' and release_year = 2020;

-- 4. Find the top 10 country with most content 
SELECT countrys , count(*) as country_count from
( SELECT TRIM(VALUE) as countrys from NETFLIX
  cross apply string_split(country, ',')) as t1
where countrys is not null 
group by countrys
order by country_count desc 
OFFSET 0 ROWS FETCH NEXT 10 ROWS ONLY;

-- 5. identify the longest movie 
SELECT show_id, title, duration from NETFLIX 
where types_ = 'Movie'
ORDER BY cast(left(duration, CHARINDEX(' ', duration ) - 1) as Int) desc;

-- 6. Find the content added in last 5 years
SELECT *
FROM NETFLIX
WHERE YEAR(date_added) >= YEAR(GETDATE()) - 5;

-- 7. List all TV Shows with more than 5 seasons
SELECT show_id, title, duration from NETFLIX
where types_ = 'TV Show' and cast(left(duration, CHARINDEX(' ', duration) - 1) as INT) >= 5 
ORDER BY cast(left(duration, CHARINDEX(' ', duration) - 1) as INT) desc;

-- 8. Find all the movies/ TV Shows by director 'Rajiv Chilaka'!
SELECT show_id, title, types_, director from NETFLIX 
where director like '%Rajiv Chilaka%';

-- 9. Count the number of content items in each genre
SELECT genre , count(*) as Count_content from
(SELECT TRIM(VALUE) AS genre from NETFLIX
 cross apply string_split(listed_in, ',')) as t1
 where genre is not null
 group by genre
 order by Count_content desc;

 -- 10. List all the movies that are documentries
 SELECT show_id , title , types_, listed_in from NETFLIX
 where listed_in like '%documentaries%';

 -- 11. Find all content without director 
 SELECT * from NETFLIX 
 where director is null;

 -- 12. find how many movies actor 'Salman khan' appeared in last 10 years
 SELECT * FROM NETFLIX
 where year(date_added) >= year(getdate()) - 10 and casts like '%salman khan%';

 -- 13. find the top 10 actors who appeared in the higest number of movies produced in India 
 SELECT actors , count(*) as movies from
 (SELECT TRIM(VALUE) as actors from NETFLIX 
  CROSS APPLY string_split(casts , ',')
  where country like '%india%') as t1
  group by actors 
  order by movies desc 
  OFFSET 0 ROWS FETCH NEXT 10 ROWS ONLY;

  -- 14. Count how many movies are available per year of release
  SELECT release_year , count(*) as Movie_count from NETFLIX 
  where types_ = 'Movie'
  group by release_year
  order by Movie_count desc;

  -- 15. Find the top 5 directors with the most content on Netflix
  SELECT directors , count(*) as contents from
  (SELECT TRIM(VALUE) as directors from NETFLIX
   cross apply string_split(director,',')) as t1
   group by directors 
   order by contents desc;

