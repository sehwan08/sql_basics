-- 주문 데이터로 데이터 가공하기


-- 1. 원하는 형식으로 컬럼 가공하기
-- 1) 숫자를 문자열로 바꿔주기
select dt, cast(dt as varchar) as date
from online_order oo 

-- 2) 문자열 컬럼에서 일부만 잘라내기
-- 앞에서 단어 하나씩부터 1로 시작, left, substring, right의 위치로부터 문자 번호를 찍으면 된다
select dt, left(cast(dt as varchar),4) as yyyy,
substring(cast(dt as varchar), 5, 2) as mm,
right(cast(dt as varchar), 2) as dd
from online_order oo 

-- 3) yyyy-mm-dd 형식으로 이어주기
select dt,
concat(
left(cast(dt as varchar),4), '-',
substring(cast(dt as varchar), 5, 2), '-',
right(cast(dt as varchar), 2)) as yyyymmdd
from online_order oo 

select dt,
left(cast(dt as varchar),4) || '-' ||
substring(cast(dt as varchar), 5, 2) || '-' ||
right(cast(dt as varchar), 2) as yyyymmdd
from online_order oo 


-- 4) null값인 경우 임의값으로 바꿔 주기
-- coalesce -> 유형이 같은것만 바꿔줌
select oo.userid, coalesce (oo.userid, 0)
from online_order oo 
left join user_info ui on oo.userid = ui.userid 

select coalesce (ui.gender, 'NA') as gender, 
coalesce (ui.age_band, 'NA') as age_band,
sum(oo.gmv) as gmv
from online_order oo 
left join user_info ui on oo.userid = ui.userid 
group by 1,2
order by 1,2


--5) 원하는 형식으로 컬럼 추가
select distinct case 
when gender = 'M' then '남성' when gender = 'F' then '여성' 
else 'NA' end as gender 
from user_info ui 

--6) 연령대 그룹 만들어보기 (20대, 30대, 40대)
select  
case when ui.age_band ='20~24' then '20s'
when ui.age_band ='25~29' then '20s'
when ui.age_band ='30~34' then '30s'
when ui.age_band ='35~39' then '30s'
when ui.age_band ='40~44' then '40s'
when ui.age_band ='45~49' then '40s'
else 'NA' end as age_group,
sum(gmv) as gmv
from online_order oo 
left join user_info ui on oo.userid = ui.userid 
group by 1
order by 1

--select * from category c 

-- 7) TOP3 카테고리와 그 외 상품의 매출액 비교
-- 먼저 조인을 하여 카테고리별 매출액을 뽑고 거기서 탑 3개를 거른후
-- 직접 컬럼을 만든다. 
select
case when c.cate1 in ('스커트','티셔츠','원피스') then 'TOP 3'
else '기타' end as item_type
,sum(gmv) as gmv 
from online_order oo 
join item i on oo.itemid = i.id 
join category c on i.category_id = c.id 
group by 1
order by 2 desc


-- 8) 특정 키워드가 담긴 상품과 그렇지 않은 상품의 매출 비교하기 (+item 개수도 같이 확인)
select i.item_name,
case when i.item_name like '%깜찍%' then '깜찍 컨셉'
when i.item_name like '%시크%' then '시크 컨셉'
when i.item_name like '%청순%' then '청순 컨셉'
when i.item_name like '%기본%' then '기본 컨셉'
else '미분류'
end as item_concept
from item i 

select 
case when i.item_name like '%깜찍%' then '깜찍 컨셉'
when i.item_name like '%시크%' then '시크 컨셉'
when i.item_name like '%청순%' then '청순 컨셉'
when i.item_name like '%기본%' then '기본 컨셉'
else '미분류'
end as item_concept,
sum(gmv) as gmv
from online_order oo 
join item i on oo.itemid = i.id 
group by 1
order by 2 desc


-- 날짜 관련 함수
-- 1) 오늘을 나타내는 함수
select now()

select current_date 

select current_timestamp 

-- 2) 날짜 형식에서 문자 형식으로 변환
select to_char(now(), 'yyyymmdd')

-- 3) 날짜 더하기 빼기
-- day, week, month, year 로 조절 가능
select now() + interval '1 month'
select now() - interval '1 month'

-- 4) 특정 날짜로부터 연도, 월, 주 확인
-- day, week, month, year 로 조절 가능
select date_part('month', now()) 

-- 5) 특정 날짜로부터 1년 동안의 매출액 확인
select * from gmv_trend gt 
where cast(yyyy as varchar) || cast(mm as varchar)
>= cast(date_part('year', now() - interval '1 year') as varchar) || cast(date_part('month', now() - interval '1 year' ) as varchar)
order by 2, 3

select * from gmv_trend gt 

select category, yyyy, sum(gmv) as gmv from gmv_trend gt 
where cast(yyyy as varchar) || cast(mm as varchar)
>= cast(date_part('year', now() - interval '1 year') as varchar) || cast(date_part('month', now() - interval '1 year' ) as varchar)
group by 1, 2
order by 3 desc


-- 할인률, 판매가, 이익률 계산
-- 모두에 대한 할인률 이므로 '*' 모두 선택, 할인률 값 as discount_rate로 만듬
select *, cast(discount as numeric) / gmv as discount_rate
from online_order oo 

select *, gmv - discount as paid_amount
from online_order oo 

select *, cast(product_profit as numeric) / gmv as product_margin 
from online_order oo 

select *, cast(total_profit  as numeric) / gmv as total_margin 
from online_order oo 

select *,
cast(discount as numeric) / gmv as discount_rate,
gmv - discount as paid_amount,
cast(product_profit as numeric) / gmv as product_margin,
cast(total_profit  as numeric) / gmv as total_margin
from online_order oo 

-- 상품 테이블과 조인하여 확인
-- 결국 select에 오는것은 맨 앞에 어떤 목록이 올것이냐임
select c.cate1,
round(sum(cast(discount as numeric)) / sum(gmv), 2) * 100 as discount_rate,
round(sum(gmv - discount), 2) * 100 as paid_amount,
round(sum(cast(product_profit as numeric)) / sum(gmv), 2) * 100 as product_margin,
round(sum(cast(total_profit  as numeric)) / sum(gmv) * 100) || '%' as total_margin
from online_order oo
join item i on oo.itemid = i.id 
join category c on i.category_id = c.id 
group by 1
order by 3 desc



-- 인당 구매 수량, 구매 금액 계산
-- 인당 평균 구매 수량 = 총 판매 수량 / 총 고객 수
-- 인당 평균 구매 금액 = 총 구매 금액 / 총 고객 수

-- unitsold - 판매 수량
-- userid 를 세는데 중복을 없애기 위해서 'distinct'로 처리
select i.item_name,
sum(unitsold) as unitsold,
count(distinct userid) as user_count,
round(sum(cast(unitsold as numeric)) /  count(distinct userid), 2) as avg_unitsold_per_customer
from online_order oo 
join item i on oo.itemid = i.id 
group by 1
order by 4 desc


select i.item_name,
sum(unitsold) as unitsold,
count(distinct userid) as user_count,
round(sum(cast(unitsold as numeric)) /  count(distinct userid), 2) as avg_unitsold_per_customer,
round(sum(cast(gmv as numeric)) /  count(distinct userid)) as avg_gmv_per_customer
from online_order oo 
join item i on oo.itemid = i.id 
group by 1
order by 4 desc


-- 인당 구매금액이 높은 성, 연령대는?
select ui.gender, ui.age_band, 
sum(gmv)  as gmv,
count(distinct oo.userid) as user_count,
sum(gmv) / count(distinct oo.userid)  as avg_gmv_per_customer 
from online_order oo 
join user_info ui on oo.userid = ui.userid 
group by 1,2
order by 5 desc












