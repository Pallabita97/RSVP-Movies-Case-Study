USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/

-- Segment 1:

-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:

-- Query Explanation - Used count function for getting total number of rows in Genre, Ratings, Director_Mapping, Name, Role_Mapping and Movie table.


Select count(*)
From Genre;

-- Total row in Genre is 14662.

Select count(*)
From Ratings;

-- Total row in Ratings is 7997.

Select count(*)
From Director_Mapping;

-- Total row in Director_Mapping is 3897.

Select count(*)
From Names;

-- Total row in Names is 25735.

Select count(*)
From Role_Mapping;

-- Total row in Names is 15615.

Select count(*)
From Movie;

-- Total row in Names is 7997.

-- Q2. Which columns in the movie table have null values?
-- Type your code below:


-- Query Explanation - Used case statement for finding null values for each column.


Select
sum(Case when ID is null then 1
    Else 0
End) as ID_Null_Count,
sum(Case when Title is null then 1
    Else 0
End) as Title_Null_Count,
sum(Case when Year is null then 1
    Else 0
End) as Year_Null_Count,
sum(Case when Date_Published is null then 1
    Else 0
End) as Date_Published_Null_Count,
sum(Case when Duration is null then 1
    Else 0
End) as Duration_Null_Count,
sum(Case when Country is null then 1
    Else 0
End) as Country_Null_Count,
sum(Case when Worlwide_Gross_Income is null then 1
    Else 0
End) as Worlwide_Gross_Income_Null_Count,
sum(Case when Languages is null then 1
    Else 0
End) as Languages_Null_Count,
sum(Case when Production_Company is null then 1
    Else 0
End) as Production_Company_Null_Count
From Movie;


-- Country column has 20 null values, 
-- Worlwide_Gross_Income column has 3724 null values, 
-- Languages column has 194 null values, 
-- Production_Company column has 528 null vales.

-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

-- Query Explanation - Counted and Sorted number of movies on a yearly basis. 

Select Year,
       Count(Title) as Number_of_movies
From Movie
group by Year
order by Count(Title) desc;

-- Year 2017 - 3052 movies produced.
-- Year 2018 - 2944 movies produced.
-- Year 2019 - 2001 movies produced.

-- Query Explanation - Counted number of movies on a monthly basis and sorted highest no of movie as per month.


Select Month(Date_Published) as Month_Num,
       Count(Title) as Number_of_movies
From Movie
Group by Month_Num
Order by Number_of_movies desc;

-- March month produced highest no of movies.

/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

-- Query Explanation - Counted number of movies produced in India and USA in the year 2019.


Select Year,
       Count(Title) as Number_of_movies
From Movie
Where Year=2019 and
      (Country like "%INDIA%" or
      Country like "%USA%");

-- 1059 movies realesed in USA or India in 2019.

/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

-- Query Explanation - Used distinct for getting unique list of genres.

Select distinct Genre
From Genre;

-- 13 genres of movies are present in dataset

/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

-- Query Explanation - Counted and sorted highest number of movies produced under genre and used join for merging two tables.

Select Genre,
       count(Title) as Number_of_movies
From movie as m
inner join Genre as g
on m.id=g.movie_id
group by Genre
order by count(Title) desc
limit 1;

-- 4285 is the highest no of movies produced under Drama Genre.


/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

-- Query Explanation - selected number of movies as per only one genre.

with movie_genre as(
     Select movie_id,
            count(Distinct genre) as num_of_genre_movie
	From genre
    group by movie_id
    having num_of_genre_movie=1)
Select count(movie_id) as num_of_movie_one_genre
From movie_genre;

-- 3289 movies were produced under one genre.

    
/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

-- Query Explanation - Calculated average duration per genre.

Select genre,
       round(avg(Duration),2) as Avg_Duration
From Genre as g
Inner Join Movie as m
on g.movie_id=m.id
group by genre
order by Avg_Duration desc;

-- Action genre has highest duration 112.88 and Horror genre has lowest duration 92.72.


/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)

/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

-- Query Explanation - Number of movies produced based on Genre rank.

with Genre_ranking as (
Select Genre,
       count(Movie_ID) as Movie_Count,
       Rank() Over(order by count(Movie_ID) desc) as Genre_Rank
From Genre
group by Genre)
Select * 
From Genre_ranking
where Genre="Thriller";
 
-- Thriller genre is in 3rd position as per genre rank and produced 1484 number of movies.


/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/


-- Segment 2:

-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:

-- Query Explanation - Calculed maximun and minimun values from Rating table.

Select
Round(Min(Avg_Rating)) as Min_Avg_Rating,
Round(Max(Avg_Rating)) as Max_Avg_Rating,
Min(Total_Votes) as Min_Total_Votes,
Max(Total_Votes) as Max_Total_Votes,
Min(Median_Rating) as Min_Median_Rating,
Max(Median_Rating) as Max_Median_Rating
From Ratings;

-- Min Avg Rating is 1
-- Max Avg Rating is 10
-- Min Total Votes is 100
-- Max Total Votes is 725138
-- Min Median Rating is 1
-- Max Median Rating is 10 
    

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too

-- Query Explanation - Top 10 movies based on average rating.

Select Title,
	   Avg_Rating,
	   Rank()Over(order by Avg_Rating desc) as Movie_Rank
From Ratings as r
Inner Join Movie as m
on r.movie_id = m.id
limit 10;

-- Kirket and Love in Kilnerry has the highest averge rate 10 and in first position as per movie rank.

/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have

-- Query Explanation - Number of movies based on median rating

Select Median_Rating,
       count(Movie_Id) as Movie_Count
From Ratings
Group by Median_Rating
Order by Movie_Count desc;

-- 2257 movies produced under median rating 7 which is the highest number of movies.

/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:

-- Query Explanation - Highest Number of movies produced by production company as per rank.

Select Production_Company,
       Count(Title) as Movie_Count,
       Rank() Over (Order by Count(Title) desc) as Prod_Company_Rank
From Movie as m
Inner join Ratings as r
on m.id = r.movie_id
where Avg_Rating > 8 and
      Production_Company is not null
Group by Production_Company;

-- Dream Warrior Pictures and National Theature Live produced highest number of hit movies as per production company rank.

-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

-- Query Explanation - Number of movies produced based on genre in USA in March 2017 where total votes are greater than 1000.

Select g.Genre,
       Count(g.Movie_Id) as Movie_Count
From Genre as g
Inner Join Movie as m
on g.movie_id=m.id
Inner Join Ratings as r
on m.id=r.movie_id
where Year = 2017 and
      Month(m.Date_Published)=3 and
      Country like "%USA%" and
      Total_votes > 1000
group by g.Genre
order by Movie_Count desc;

-- 24 movies were produced under "Drama" in March 2017 in USA where votes are more than 1000.


-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

-- Query Explanation - Movies as per Genre when avg rating is more than 8 and movie name starts with "The".


Select Title,
       Avg_Rating,
       genre
From Movie as m
Inner Join Ratings as r
on m.Id = r.Movie_id
Inner Join Genre as g
on g.Movie_id=r.Movie_id
where Title like "THE%" 
and Avg_Rating > 8
order by Avg_Rating desc;

-- "The Brighton Miracle"  has highest avg rating 9.5 Under genre "Drama".


-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

-- Query Explanation - Number of movies realeased between 1st Apr,18 to 1st Apr, 19 with median rating 8.

Select count(Title) as Movie_Count,
       Median_Rating
From Movie as m
Inner Join Ratings as r
on m.id=r.movie_id
where date_published between "2018-04-01" and "2019-04-01"
and   median_rating = 8
group by median_rating;

-- 361 movies realeased under median rating 8.


-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

-- Query Explanation - Total number of votes for both German and Italian movie

Select Country,
       sum(Total_Votes) as Total_Num_of_Votes
From Movie as m,
 Ratings as r
where m.id=r.movie_id
and Languages like "%German%"
and Languages like "%Italian%"
and Country in ("Germany","Italy")
group by Country;

-- German movies get 1978 votes compared to Italian movie.

-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/

-- Segment 3:

-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

-- Query Explanation - Null values for each column from Name table except ID.


Select
sum(Case when Name is null then 1
    Else 0
End) as Name_Null_Count,
sum(Case when Height is null then 1
    Else 0
End) as Height_Null_Count,
sum(Case when Date_of_Birth is null then 1
    Else 0
End) as Date_of_Birth_Null_Count,
sum(Case when Known_for_Movies is null then 1
    Else 0
End) as Known_for_Movies_Null_Count
From Names;

-- Height, Date of Birth and Known for Movies columns has null values.



/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

-- Query Explanation - First, need to create table for top_3 genre based on number of movies and then identified top 3 directors based on average rating which is greater than 8 

with Top_3_Genre as (
Select Genre,
       Count(m.id) as Movie_Count,
       Rank() Over(Order by Count(m.id) desc) as Genre_Rank
From Movie as m
Inner Join Genre as g
on m.id = g.movie_id
Inner Join Ratings as r
on m.id=r.movie_id
where Avg_Rating > 8
group by Genre
limit 3
)
Select n.name as Director_Name,
	   count(dm.movie_id) as Movie_Count
From Director_Mapping as dm
Inner Join Genre as g
on g.movie_id=dm.movie_id
Inner Join Names as n
on n.id=dm.Name_id
Inner Join Top_3_Genre as tg
on g.genre=tg.genre
Inner Join ratings as r
on r.movie_id=g.movie_id
where Avg_Rating > 8
group by Name
order by Movie_Count desc
limit 3;


-- James Mamgold is the top most director as per number of movies along with Anthony Russo and Soubin Shahir.

/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

-- Query Explanation - Top Actors based on number of movies where avg rating is greater than equal to 8.

Select n.name as Actor_Name,
       count(Title) as Movie_Count
From Role_Mapping as rm
Inner Join Movie as m
on rm.movie_id=m.id
Inner Join Ratings as r
on m.id=r.movie_id
Inner Join Names as n
on n.id=rm.name_id
where r.median_rating >=8
and Category="Actor"
group by Actor_Name
Order by Movie_Count desc
limit 2;

-- Mammootty and Mohanlal has acted in most number of movies.


/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:


-- Query Explanation - Highest Vote received production houses as per Rank.

Select Production_Company,
       sum(Total_Votes) as Vote_Count,
       Rank()over(Order by sum(Total_Votes) desc) as Prod_Comp_Rank
From Movie as m
Inner Join Ratings as r
on m.id=r.movie_id
group by Production_Company
order by Vote_Count desc
limit 3;

-- Marvel Studio has highest Number of votes as per production Company Rank.
-- Twentieth Century Fox has 2nd highest Number of votes as per production Company Rank.
-- Warner Bros.has 3rd highest Number of votes as per production Company Rank.

/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Query Explantion - Top most actors based on their number of realesed movies and ratings in India.


Select n.name as Actor_Name,
	sum(Total_Votes) as Total_Votes,
    count(distinct rm.movie_id) as Movie_Count,
    Round(sum(r.avg_rating*r.total_Votes)/sum(r.total_votes),2) as Actor_Avg_Rating,
    Rank() Over(Order by Round(sum(r.avg_rating*r.total_Votes)/sum(r.total_votes),2) desc) as Actor_Rank
From movie as m, ratings as r, role_mapping as rm, names as n
where m.id=r.movie_id
and rm.movie_id=m.id
and rm.name_id=n.id
and m.country like "%India%"
and rm.category="actor"
Group by n.name,
		rm.name_id
Having count(distinct rm.movie_id) >=5
Limit 3;

-- Top actor is Vijay Sethupathi as per average rating
-- 2nd highest actor is Fahadh Faasil as average rating
-- 3rd highest actor is Yogi Babu as per average rating


-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Query Explanation - Top actressess from hindi movie industry as their number of movies and average rating.

Select n.name as Actress_Name,
	sum(Total_Votes) as Total_Votes,
    count(distinct rm.Movie_Id) as Movie_Count,
    Round(sum(r.avg_rating*r.total_Votes)/sum(r.total_votes),2) as Actress_Avg_Rating,
    Rank() Over(Order by Round(sum(r.avg_rating*r.total_Votes)/sum(r.total_votes),2) desc) as Actress_Rank
From movie as m, ratings as r, role_mapping as rm, names as n
where m.id=r.movie_id
and rm.movie_id=m.id
and rm.name_id=n.id
and m.country like "%India%"
and rm.category="actress"
and m.languages like "%Hindi%"
Group by n.name, rm.name_id
having count(distinct rm.Movie_Id) >=3
limit 5;

-- Taapsee Pannu is the highest actress as per avg rating 7.74
-- Kriti Sanon is the 2nd highest actress as per avg rating 7.05
-- Divya Dutta is the 3rd highest actress as per avg rating 6.88
-- Sraddha Kapoor is the 4th highest actress as per avg rating 6.63
-- Kriti Kharbanda is the 5th highest actress as per avg rating 4.80


/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:

-- Query Explanation - Name of Thriller movies as per average rating category

select Title,
	Genre,
	 Avg_Rating,
Case
     when Avg_Rating > 8 then "Superhit Movies"
     when Avg_Rating between 7 and 8 then "Hit Movies"
     when Avg_Rating between 5 and 7 then "One Time Watch Movies"
     else "Flop Movies"
End as Avg_Rating_Category
From Genre as g
Inner Join Movie as m
on g.movie_id=m.id
Inner Join Ratings as r
on m.id=r.movie_id
where genre="Thriller"
order by Avg_Rating desc;

-- Classified as per average rating category

/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

-- Query Explanation - Genre wise running total and moving average as per average duration.


Select g.Genre,
       Round(Avg(m.duration),2) as Avg_Duration,
       Sum(Round(Avg(m.duration),2)) Over (Order by Genre Rows Unbounded Preceding) as Running_Total_Duration,
       Avg(Round(Avg(m.duration),2)) Over (Order by Genre Rows 10 Preceding) as Moving_Avg_Duration
From   Movie as m
Inner Join
Genre as g
on m.id=g.movie_id
group by g.Genre
order by g.Genre;


-- 13 genre of movies has different running total duration and moving average duration from average duration


-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Query Explanation - Top 3 Genres based on most number of movies. Secondly, top 5 movies  income from each year where movie rank is less than 5 which belongs to top 3 genre.

With Top_3_Genre as (
Select Genre,
       Count(ID) as Movie_Count
From Movie as m
Inner Join Genre as g
on m.id=g.movie_id
group by Genre
Order by count(ID) desc
Limit 3
),

Top_5_Movies as
(Select Genre,
        Year,
        Title as Movie_Name,
        Worlwide_Gross_Income,
        Dense_Rank() Over(Partition by Year Order by Worlwide_Gross_Income desc) as Movie_Rank
From movie as m
Inner Join genre as g
on m.id=g.movie_id
where Genre in (Select Genre 
                From Top_3_Genre) )

Select Genre,
        Year,
        Movie_Name,
        Worlwide_Gross_Income,
        Movie_Rank
From Top_5_Movies
where movie_rank <=5;

       
-- "Shatamanam Bhavati" is the highest earning movie as per worldwide gross income which belongs under "Drama"


-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

-- Query Explanation - Top production company produced hit multilingual movies as per avg rating which is greater than equal to 8.

Select Production_Company,
       Count(Title) as Movie_Count,
       Rank() Over (Order by Count(Title) Desc) as Prod_Comp_Rank
From Movie as m
Inner Join Ratings as r
on m.id=r.movie_id
where median_rating > 8
and Production_Company is not null
and Position(',' in Languages) > 0
group by Production_Company
order by Count(Title) desc
Limit 2;


-- Star Cinema has produced highest number of multilingual movies as per average rating
-- Ave Fenix Pictures has produced 2nd highest number of multilingual movies as per average rating

-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Query Explanation - Top most actressess based on number of superhit moving based on average rating from "Drama" genre.


Select n.name as Actress_Name,
	sum(Total_Votes) as Total_Votes,
    count(distinct rm.Movie_Id) as Movie_Count,
    Round(sum(r.avg_rating*r.total_Votes)/sum(r.total_votes),2) as Actress_Avg_Rating,
    Rank() Over(Order by Round(sum(r.avg_rating*r.total_Votes)/sum(r.total_votes),2) desc) as Actress_Rank
From movie as m, ratings as r, role_mapping as rm, names as n, genre as g
where m.id=r.movie_id
and rm.movie_id=m.id
and rm.name_id=n.id
and m.id=g.movie_id
and r.Avg_Rating > 8
and rm.category="actress"
and g.Genre = "Drama"
Group by n.name, rm.name_id
limit 3;


-- Sangeetha Bhat is the highest Average rated actress
-- Adriana Matoshi is the 2nd highest Average rated actress
-- Fatmire Sahiti is the 3rd highest Average rated actress


/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:

-- Query Explanation - Top 9 directors based on number of movies, total votes, avg rating and duration of movie.

With Next_Movie_Date_Published_Summary as (
select dm.name_id,
       name,
       dm.movie_id,
       duration,
       avg_rating,
       total_votes,
       date_published,
       lead(date_published,1) Over(partition by name_id Order by date_published, movie_id) as Next_Movie_Date
From Director_Mapping as dm
Inner Join Names as n
on dm.name_id=n.id
Inner Join Movie as m
on dm.movie_id=m.id
Inner Join Ratings as r
on r.movie_id=m.id
),
Date_Diff as (
Select *,
       Datediff(Next_Movie_Date,date_published) as Difference
From Next_Movie_Date_Published_Summary
)
Select name_id as Director_id,
       name as Director_Name,
       Count(movie_ID) as Number_of_Movies,
       Round(Avg(Difference),2) as Avg_Inter_Movie_Days,
       Round(Avg(Avg_Rating),2) as Avg_Rating,
       Sum(Total_Votes) as Total_Votes,
       Min(Avg_Rating) as Min_Rating,
       Max(Avg_Rating) as Max_Rating,
       Sum(Duration) as Total_Duration
From Date_Diff
Group by Name_id
Order by Count(movie_id) desc
Limit 9;


-- Andrew Jones is highest as per avg inter movie days along with A.L. Vijay and Sion Sono.
