SELECT *
from survey
LIMIT 10;

SELECT question, COUNT (DISTINCT user_id)
FROM survey
GROUP BY question;

-- COMPLETION RATES
--Q1: 100%
--Q2: 95%
--Q3: 80%
--Q4: 95%
--Q5: 74%

/**The 5th question has the lowest completion rate with 74%. I think this is because the 'Not Sure. Let's Skip It' option is not really visible, hence users who have never done eye exams/forgot when they last did the test abandoned the survey altogether. Try to make the 'Not Sure' option more visible.**/


-- TRY-ON FUNNEL --

SELECT DISTINCT q.user_id, 
    CASE WHEN h.user_id IS NOT NULL THEN 'TRUE' ELSE 'FALSE' END AS 'is_home_try_on', 
    h.number_of_pairs AS 'number_of_pairs', 
    CASE WHEN p.user_id IS NOT NULL THEN 'TRUE' ELSE 'FALSE' END AS 'is_purchase'
FROM quiz q
LEFT JOIN home_try_on AS 'h' 
ON q.user_id = h.user_id
LEFT JOIN purchase AS 'p' 
ON q.user_id = p.user_id
LIMIT 10;

-- ANALYSIS --

--1. ARE USERS MORE LIKELY TO PURCHASE IF THEY GET MORE PAIRS TO TRY AT HOME?--

SELECT h. number_of_pairs, COUNT (DISTINCT p.user_id) AS 'num_of_users'

FROM quiz AS 'q'
LEFT JOIN home_try_on AS 'h' 
ON q.user_id = h.user_id
LEFT JOIN purchase AS 'p' 
ON q.user_id = p.user_id

GROUP BY number_of_pairs;

/** The data shows that the more pairs that users get to try at home, the more likely they make the purchase. The number of users who got 5 pairs to try is 46% higher than those who only got 3 pairs to try.**/

--2. CONVERSION RATE OF EACH FUNNEL--

SELECT COUNT (DISTINCT q.user_id) AS '# filled out quiz', COUNT (DISTINCT h.user_id) AS '# home try on', COUNT (DISTINCT p.user_id) AS '# purchase'

FROM quiz q
LEFT JOIN home_try_on h ON q.user_id = h.user_id
LEFT JOIN purchase p ON q.user_id = p.user_id;

/** CONVERSION RATE
Quiz to Home Try On: 75%
Home Try On to Purchase: 66%

More than half of the people who got to try the glassess at home didn't proceed to purchase. This might be due to the quality of suggesstions.**/

--3. MOST LIKED SHAPE OF GLASSESS--

SELECT response, COUNT (DISTINCT user_id) AS '# of responses'
FROM survey
WHERE question = '3. Which shapes do you like?'
GROUP BY response
ORDER BY 2 DESC ;

/** The most liked shape of glassess is rectangular, which make up of 37% of the responses. The runner up is square-shaped glasses with 31%.**/

--4. MOST COMMON FIT--

SELECT response, COUNT (DISTINCT user_id) AS '# of responses'
FROM survey
WHERE question LIKE '%2%'
GROUP BY response
ORDER BY 2 DESC ;

/**  43% of users have narrow face shape. Warby Parker could use this data to better serve this segment of users by providing more choices for narrow-fit users or by adjusting the marketing campaigns to target them. **/

--5. LAST EYE EXAM--

SELECT response, COUNT (DISTINCT user_id) AS '# of responses'
FROM survey
WHERE question LIKE '%5%'
GROUP BY response
ORDER BY 2 DESC ;

/**  Majority users had their last eye exam in the previous one year. This could mean that the users are (1) new glasses-wearer or (2) they need to adjust their glassess based on the recent eye exam result. This data also shows that majority of users who filled out the survey have recently visited optometrist. Warby Parker could consider going into partnership with optometrists as their marketing strategy.  **/
