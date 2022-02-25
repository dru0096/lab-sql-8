USE sakila

/* 1. Write a query to display for each store its store ID, city, and country. */

SELECT s.store_id, c.city, co.country FROM store AS s
LEFT JOIN address AS a
ON s.address_id = a.address_id
LEFT JOIN city AS c
ON a.city_id = c.city_id
LEFT JOIN country AS co
ON c.country_id = co.country_id;

/* 2. Write a query to display how much business, in dollars, each store brought in. */

SELECT s.store_id, sum(p.amount) as "Store Revenue in $"
FROM payment AS p
LEFT JOIN staff AS s
ON p.staff_id = s.staff_id
GROUP BY s.store_id;


/* 3. Which film categories are the longest? Foreign film category contains longest movies, on average. */

SELECT fc.category_id, c.name, f.length, 
avg(f.length) over (partition by c.name) as "Average-length-category"
FROM sakila.film_category as fc
LEFT JOIN sakila.film AS f
ON fc.film_id=f.film_id
JOIN sakila.category as c
ON fc.category_id = c.category_id
GROUP BY c.name
ORDER BY avg(f.length) over (partition by c.name) DESC;

/* 4. Display the most frequently rented movies in descending order. */

SELECT count(r.rental_id), f.title, i.inventory_id, i.film_id
FROM sakila.inventory as i
JOIN sakila.rental as r
ON i.inventory_id = r.inventory_id
RIGHT JOIN sakila.film as f
ON i.film_id = f.film_id
GROUP BY f.title
ORDER BY count(r.rental_id) DESC, f.title;

/* No need to use window here for count?
count(r.rental_id) over (f.title) as "No. of Rentals per Movie"
count(r.rental_id) over (f.title) as "No. of Rentals per Movie" DESC */ 

/* 5. List the top five genres in gross revenue in descending order. */

SELECT round(sum(amount),2) as "Revenue", c.name
FROM sakila.payment as p
RIGHT JOIN sakila.rental as r
ON p.rental_id = r.rental_id
JOIN sakila.inventory as i
ON r.inventory_id = i.inventory_id
LEFT JOIN sakila.film_category as fc
ON i.film_id = fc.film_id
LEFT JOIN sakila.category as c
ON fc.category_id = c.category_id
GROUP BY c.name
ORDER BY revenue DESC
LIMIT 5;


/* 6. Is "Academy Dinosaur" available for rent from Store 1? Answer: Yes */

SELECT f.title, s.store_id
FROM sakila.film as f
JOIN sakila.inventory as i
ON f.film_id = i.film_id
JOIN sakila.store as s
ON i.store_id= s.store_id
WHERE f.title= "Academy Dinosaur" and s.store_id = 1
GROUP BY f.title, s.store_id;



/* Can skip 7,8. 
9. For each film, list actor that has acted in more films.

 
!! Struggled to complete this with window function. Come back to it later. */

SELECT f.title,a.first_name, a.last_name, (concat(a.first_name,' ',a.last_name)) as "Actor Name", 
fa.actor_id
FROM sakila.film as f
JOIN sakila.film_actor as fa
ON f.film_id = fa.film_id
JOIN sakila.actor as a
ON fa.actor_id = a.actor_id;



SELECT f.title, concat(a.first_name,' ',a.last_name) as "Actor Name", 
fa.actor_id, 
count(f.title) over (partition by (concat(a.first_name,' ',a.last_name)=concat(a.first_name,' ',a.last_name))) as "Number of films played" 
FROM sakila.film as f 
JOIN sakila.film_actor as fa 
ON f.film_id = fa.film_id 
JOIN sakila.actor as a 
ON fa.actor_id = a.actor_id;


/*f.title) over (partition by (concat(a.first_name,' ',a.last_name)=concat(a.first_name,' ',a.last_name))) as "Number of films played" */