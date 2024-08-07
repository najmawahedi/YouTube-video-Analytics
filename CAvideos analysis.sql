-- observing few rows
SELECT TOP 100 * FROM CAvideos;

-- analyzing columns with their data types and null values
Select COLUMN_NAME, DATA_TYPE FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'CAvideos'

-- fixing the datatypes of each column
ALTER TABLE CAvideos ALTER COLUMN likes int NULL;
ALTER TABLE CAvideos ALTER COLUMN views int NULL;
ALTER TABLE CAvideos ALTER COLUMN dislikes int NULL;
ALTER TABLE CAvideos ALTER COLUMN category_id int NULL;
ALTER TABLE CAvideos ALTER COLUMN publish_time DATETIME NULL;
ALTER TABLE CAvideos ALTER COLUMN comment_count int NULL;

SELECT TOP 10 * FROM [helpme].[dbo].[CAvideos];

--rechecking the datatypes of each column
Select COLUMN_NAME, DATA_TYPE FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'CAvideos';

-- counting null values for each column
SELECT SUM(CASE WHEN 'video_id' IS NULL THEN 1 ELSE 0 END) AS Column1NullCounts, 
SUM(CASE WHEN 'trending_date' IS NULL THEN 1 ELSE 0 END) AS Column2NullCounts, 
SUM(CASE WHEN 'title' IS NULL THEN 1 ELSE 0 END) AS Column3NullCounts, 
SUM(CASE WHEN 'channel_title' IS NULL THEN 1 ELSE 0 END) AS Column4NullCounts, 
SUM(CASE WHEN 'category_id' IS NULL THEN 1 ELSE 0 END) AS Column5NullCounts, 
SUM(CASE WHEN 'publish_time' IS NULL THEN 1 ELSE 0 END) AS Column6NullCounts, 
SUM(CASE WHEN 'tags' IS NULL THEN 1 ELSE 0 END) AS Column7NullCounts, 
SUM(CASE WHEN 'views' IS NULL THEN 1 ELSE 0 END) AS Column8NullCounts, 
SUM(CASE WHEN 'likes' IS NULL THEN 1 ELSE 0 END) AS Column9NullCounts,
SUM(CASE WHEN 'dislikes' IS NULL THEN 1 ELSE 0 END) AS Column10NullCounts, 
SUM(CASE WHEN 'comment_count' IS NULL THEN 1 ELSE 0 END) AS Column11NullCountsn 
FROM CAvideos;
--we have 0 null values in our columns

-- checking for duplicates and dropping them
WITH CTE AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY video_id ORDER BY publish_time DESC) AS rn
    FROM CAvideos
)
DELETE FROM CTE WHERE rn > 1;

--counting the total number of rows after removing the duplicate vlaues
select count(*) from CAvideos;

-- counting the number of each category of the vedious and ordering them in decsending way
SELECT DISTINCT category_id, COUNT(*) AS number_of_occurance
FROM CAvideos
GROUP BY category_id
ORDER BY number_of_occurance DESC;

--adding year month and date column to the dataset
ALTER TABLE CAvideos ADD publish_year INT;
ALTER TABLE CAvideos ADD publish_month INT;
ALTER TABLE CAvideos ADD publish_day INT;

UPDATE CAvideos
SET publish_year = YEAR(publish_time),
    publish_month = MONTH(publish_time),
    publish_day = DAY(publish_time);

SELECT TOP 10 * FROM CAvideos;

-- observing which years this dataset contains information from
SELECT DISTINCT publish_year FROM CAvideos;

-- observing top 10 most viewed videos 
SELECT TOP 10 title, channel_title, publish_time, views, likes, comment_count from CAvideos ORDER BY views DESC;

-- monthly trends in video uploads
SELECT publish_year, publish_month, COUNT(*) AS video_count
FROM CAvideos
GROUP BY publish_year, publish_month
ORDER BY video_count DESC;

-- creating two new columns named likes to views ratio and comments to view ratio
ALTER TABLE CAvideos ADD likes_to_view_ratio FLOAT;
ALTER TABLE CAvideos ADD comments_to_view_ratio FLOAT;

-- adding the values of the ration of each
UPDATE CAvideos 
SET likes_to_view_ratio = ROUND(CASE WHEN views = 0 THEN 0 ELSE CAST(likes AS FLOAT) / views END, 3),
    comments_to_view_ratio = ROUND(CASE WHEN views = 0 THEN 0 ELSE CAST(comment_count AS FLOAT) / views END, 3);


SELECT TOP 10 likes, views, likes_to_view_ratio, comment_count, comments_to_view_ratio
FROM CAvideos;

-- analyzing trends over time
SELECT publish_year, AVG(likes_to_view_ratio) AS avg_likes_to_views_ratio, AVG(comments_to_view_ratio) AS avg_comments_to_views_ratio
FROM CAvideos
GROUP BY publish_year
ORDER BY publish_year;
