-- USE yes24;

/* 기본 조회 및 필터링 */

-- 모든 책의 제목과 저자 조회
SELECT title, author FROM Books;

-- 평점이 4 이상인 책 목록 조회
SELECT * FROM Books WHERE rating >= 4.0;

-- 리뷰 수가 100개 이상인 책들의 제목과 리뷰 수 조회
SELECT title, review FROM Books WHERE review >= 100;

-- 가격이 20,000원 미만인 책들의 제목과 가격 조회
SELECT title, price FROM Books WHERE price < 20000;

-- 국내도서 TOP100에 4주 이상 머문 책들 조회
SELECT * FROM Books WHERE ranking <= 100 AND ranking_weeks >= 4 ORDER BY ranking_weeks DESC;

-- 특정 저자의 모든 책 조회
SELECT * FROM Books WHERE author = 'ETS 저';

-- 특정 출판사가 출판한 책 조회
SELECT * FROM Books WHERE publisher = '이투스북';

/* 조인 및 관계 */

-- 저자별 출판한 책의 수 조회
SELECT author, COUNT(*) AS books_count FROM Books GROUP BY author ORDER BY books_count ASC;

-- 가장 많은 책을 출판한 출판사
SELECT publisher, COUNT(*) AS publishing_count FROM Books GROUP BY publisher
ORDER BY publishing_count DESC
LIMIT 1;

-- 가장 높은 명균 평점을 가진 저자
-- AVG : 평균값을 내주는 함수
SELECT author, AVG(rating) AS rating_avg FROM Books GROUP BY author 
ORDER BY rating_avg DESC 
LIMIT 1;

-- 국내도서랭킹이 1위인 책의 제목과 저자 조회
SELECT title, author FROM Books WHERE ranking = 1;

-- 판매지수와 리뷰 수가 모두 높은 상위 10개의 책 조회
SELECT title, sales, review FROM Books ORDER BY sales DESC, review DESC LIMIT 10; 

-- 가장 최근 출판된 5권의 책 조회
SELECT * FROM Books ORDER BY publishing DESC LIMIT 5;

/* 집계 및 그룹화 */

-- 저자별 평균 평점 계산
SELECT author, AVG(rating) AS rating_avg FROM Books GROUP BY author ORDER BY rating_avg DESC;

-- 출판일별 출간된 책의 수 계산
SELECT publishing, COUNT(*) FROM Books GROUP BY publishing ORDER BY publishing DESC;

-- 책 제목별 평균 가격 조회
SELECT title, AVG(price) FROM Books GROUP BY title;

-- 리뷰 수가 가장 많은 상위 5권의 책
SELECT * FROM Books ORDER BY review DESC LIMIT 5;

-- 국내도서랭킹 별 평균 리뷰 수 계산
SELECT ranking, AVG(review) FROM Books GROUP BY ranking;

/* 서브쿼리 및 고급 기능 */

-- 평균 평점보다 높은 평점을 받은 책들 조회
SELECT * FROM Books 
WHERE rating > (SELECT AVG(rating) FROM Books)
ORDER BY rating DESC;

-- 평균 가격보다 비싼 책들의 제목과 저자 조회
SELECT title, author, price FROM Books 
WHERE price > (SELECT AVG(price) FROM Books)
ORDER BY price DESC;

-- 가장 많은 리뷰(max)를 받은 책보다 많은 리뷰를 받은 다른 책들 조회
-- Box Plot (통계학에서의 이상치)
-- SELECT title, review FROM Books 
-- WHERE review > (SELECT MAX(review) FROM Books);

-- 평균 판매지수보다 낮은 판매지수를 가진 책들 조회
SELECT title, sales FROM Books
WHERE sales < (SELECT AVG(sales) FROM Books);

-- 가장 많이 출판된 저자의 책들 중 최근에 출판된 책 조회
SELECT author, title FROM Books 
WHERE author = (SELECT author FROM Books GROUP BY author ORDER BY COUNT(*) DESC LIMIT 1);

/* 데이터 수정 및 관리 */
SELECT * FROM Books;
-- 특정 책의 가격 업데이트
UPDATE Books SET price = 99999 WHERE bookID = 1;
-- SELECT * FROM Books WHERE bookID = 1;

-- 특정 저자의 책 제목 변경
SET sql_safe_updates = 0; -- Safe UPDATE 일시적 해제
UPDATE Books SET title = '제목업데이트' WHERE author = '박여름 저';
-- SELECT * FROM Books WHERE author = '박여름 저';

-- 판매지수가 가장 낮은 책을 데이터베이스에서 삭제
-- Error Code : 1093 -> 데이터 변경 쿼리에서 동일한 테이블을 참조할 수 없기에 (SELECT * FROM Books)로 서브쿼리 중첩
-- Error Code : 1248 -> 서브쿼리 사용 시, AS를 사용해 서브쿼리 별칭 할당해서 해결
DELETE FROM Books WHERE sales = (SELECT MIN(sales) FROM (SELECT * FROM Books) AS subquery);
-- SELECT MIN(sales) FROM Books;

-- 특정 출판사가 출판한 모든 책의 평점을 1점 증가
UPDATE Books SET rating = rating + 1 WHERE publisher = '유노북스';
-- SELECT publisher, rating FROM Books WHERE publisher = '유노북스'

/* 데이터 분석 예제 */

-- 저자별 평균 평점 및 판매지수를 분석하여 인기 있는 저자 확인
SELECT author, AVG(rating), AVG(sales) FROM Books GROUP BY author 
ORDER BY AVG(rating) DESC, AVG(sales) DESC;

-- 출판일에 따른 책 가격의 변동 추세 분석
SELECT publishing, AVG(price) FROM Books GROUP BY publishing
ORDER BY publishing ASC;

-- 출판사별 출간된 책의 수와 평균 리뷰 수를 비교 분석
SELECT publisher, COUNT(*) AS book_count, SUM(review) AS review_sum 
FROM Books GROUP BY publisher ORDER BY book_count DESC;

-- 국내도서랭킹과 판매지수의 상관관계 분석
SELECT ranking, AVG(sales) FROM Books GROUP BY ranking;

-- 가격 대비 리뷰 수와 평점의 관계를 분석하여 가성비 좋은 책 찾기
SELECT price, AVG(review), AVG(rating) FROM Books GROUP BY price;

/* 난이도 있는 문제 */

-- 출판사별 평균 판매지수가 가장 높은 저자 찾기
SELECT publisher, author, AVG(sales) AS sales_avg FROM Books
GROUP BY publisher, author
ORDER BY publisher, sales_avg DESC;

-- 리뷰 수가 평균보다 높으면서 가격이 평균보다 낮은 책 조회
SELECT title, review, price FROM Books
WHERE review > (SELECT AVG(review) FROM Books) AND price < (SELECT AVG(price) FROM Books); 

-- 가장 많은 종류의 책을 출판한 저자 찾기
SELECT author, COUNT(DISTINCT title) AS num_books FROM Books
GROUP BY author ORDER BY num_books DESC
LIMIT 1;

-- 각 저자별로 가장 높은 판매지수를 기록한 책 조회
SELECT author, title, sales FROM Books
WHERE (author, sales) IN (
	SELECT author, MAX(sales) AS sales_max 
    FROM Books
	GROUP BY author
)
ORDER BY sales DESC;

-- 연도별 출판된 책 수와 평균 가격 비교
SELECT YEAR(publishing) AS year, COUNT(*) AS num_books, AVG(price) AS price_avg
FROM Books
GROUP BY year
ORDER BY year ASC;
-- 월별
SELECT MONTH(publishing) AS month, COUNT(*) AS num_books, AVG(price) AS price_avg
FROM Books
GROUP BY month
ORDER BY month ASC;

-- 출판사가 같은 책들 중 평점 편차가 가장 큰 출판사 찾기
SELECT publisher, MAX(rating) - MIN(rating) AS rating_difference
FROM Books
GROUP BY publisher
HAVING COUNT(*) >= 2
ORDER BY rating_difference DESC
LIMIT 1;

-- 특정 저자의 책들 중 판매지수 대비 평점이 가장 높은 책 찾기
SELECT title, sales, rating / sales AS ratio
FROM Books
WHERE author = '최태성 저'
ORDER BY ratio DESC
LIMIT 1;