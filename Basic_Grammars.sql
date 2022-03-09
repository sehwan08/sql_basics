-- 거래액 데이터를 통한 기본 문법

-- 1) 데이터 탐색
-- 1. 모든 컬럼 추출하기 ('*' -> 모두)
select * from gmv_trend 

-- 2. 특정 컬럼 추출하기 (원하는 컬럼'명'을 적으면 됨)
select category, yyyy, mm from gmv_trend

-- 3. 중복값 없이 특정 컬럼 추출 ('distinct' -> 중복값 없앰)
select distinct category from gmv_trend 

select distinct yyyy, mm from gmv_trend

-- 2) 특정 연도의 매출 탐색
-- 1-1. 조건이 하나일 때
----- 숫자열 : 'between /  대소비교', 연산자 써서 조건식 맞춤
-- 조건절은 일단 'where'로 시작, 그리고 컬럼 + 조건
select * from gmv_trend gt 
where yyyy = 2021

select * from gmv_trend gt 
where yyyy >= 2019

-- between + and 로 특정 조건들 사이의 값만 들고 올 수 있음
select * from gmv_trend gt 
where yyyy between 2018 and 2020

select * from gmv_trend gt 
where yyyy != 2019

----- 문자열 : 연산자 / like, in, not in 
-- 하나의 조건은 연산자, 두개 이상의 조건은 in
select * from gmv_trend gt 
where category = '화장품'

select * from gmv_trend gt
where category in ('화장품', '가방')

select * from gmv_trend gt
where category not in ('화장품', '가방')

-- like : 특정 단어가 들어간 컬럼을 거를 수 있음
-- '%--%' : %%사이의 특정 단어가 들어간것 다 들고 옴
-- '--%, %--' 특정단어로 시작하는것들, 뒤에가 특정단어로 끝나는것들 다 들고 옴
select * from gmv_trend gt 
where category like '%패션%'


-- 1-2. 조건이 여러개 일때
-- and(모든 조건 성립시) / or(하나만이라도 성립시) / and+or : 괄호가 필요
select * from gmv_trend gt 
where category = '화장품'
and yyyy = 2021

select * from gmv_trend gt 
where gmv > 1000000 or gmv < 10000

select * from gmv_trend gt 
where (gmv > 1000000 or gmv < 10000)
and yyyy = 2021


-- 3) 카테고리별 매출 분석 (groupby, 집계함수)
-- 1. 카테고리별, 연도별 매출
--> gmv 테이블에서 카테고리/연도별을 뽑는데 gmv는 sum을 하고
--> group by 를 하고자하는 컬럼을 그대로 넣는다 
select category, yyyy, sum(gmv) as total_gmv
from gmv_trend gt 
group by category, yyyy 

select category, yyyy, sum(gmv) as total_gmv
from gmv_trend gt 
group by 1, 2

-- 카테고리별 총 합계
select category, sum(gmv) as total
from gmv_trend gt 
group by 1

-- 화장품 2017년 총합
select category, yyyy, sum(gmv) as total 
from gmv_trend gt where category = '화장품' and yyyy = 2017
group by 1, 2

-- 카테고리별 플래폼 모바일의 2019년 총합
select category, yyyy, platform_type, sum(gmv) as total 
from gmv_trend gt  where platform_type = 'mobile' and yyyy = 2019
group by 1,2,3

-- 2018년 카테고리별 평균 금액
select category, yyyy, round(avg(gmv), 0) as average
from gmv_trend gt where yyyy = 2018
group by 1, 2

-- 전체 총합
select sum(gmv) as gmv from gmv_trend gt 


-- HAVING - 집계 결과에 필터를 걸 수 있음
select category, sum(gmv) as gmv
from gmv_trend gt
where yyyy = 2020
group by 1
having sum(gmv) >= 10000000

-- ORDER BY - 정렬, DESC - 내림차순, 
select * from gmv_trend gt order by yyyy

select * from gmv_trend gt order by category, yyyy, mm

-- 매출액이 높은순으로 카레고리 정렬
select category, sum(gmv) as total
from gmv_trend gt 
group by 1 order by total DESC

-- 두번째 컬럼의 정렬 방법 설정
select category , yyyy , sum(gmv) as gmv 
from gmv_trend gt group by 1,2
order by 1, 2 DESC


