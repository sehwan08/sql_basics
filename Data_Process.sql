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
