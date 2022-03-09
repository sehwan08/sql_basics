-- 1. 데이터 탐색
select * from online_order oo 

select * from item i 

select * from category c 

select * from user_info ui 

select * from gmv_trend gt 


-- Join
-- 1. 상품 매출액은 'online_order', 상품명은 'item' 테이블에 있다
-- 이 두 테이블을 조인하여 결과 도출
-- 상품별 매출액 집계 후, 매출액 높은 순으로 정렬
select itemid, sum(gmv) as gmv
from online_order oo 
group by 1

-- 이렇게 하면 아이템ID와 합계만 나온다. 여기에 카테고리를 추가하여 ITEMID에 따른 카테고리를 넣자
select i.item_name, oo.itemid, sum(gmv) as gmv
from online_order oo 
join item i on oo.itemid = i.id 
group by 1,2
order by 3 desc


-- 카테고리별 매출액
select c.cate1, c.cate2, c.cate3, sum(gmv) as gmv
from online_order oo 
join item i on oo.itemid = i.id 
join category c on i.category_id  = c.id 
group by 1,2,3
order by 4 desc


-- 구매고객의 성연령 분석
select ui.gender, ui.age_band, sum(gmv) as gmv
from user_info ui
join online_order oo on oo.userid = ui.userid 
group by 1,2
order by 1,2

-- where/join 함께 쓰기
select i.item_name, sum(gmv) as gmv
from online_order oo 
join item i on oo.itemid = i.id 
join user_info ui on oo.userid = ui.userid 
where gender = 'M'
group by 1
order by 2 desc


-- INNER/LEFT JOIN 차이
-- INNER JOIN시 NULL값이 누락됨
select ui.gender, ui.age_band, sum(gmv) as gmv
from online_order oo 
join user_info ui on oo.userid = ui.userid 
group by 1,2
order by 1,2

select ui.gender, ui.age_band, sum(gmv) as gmv
from online_order oo 
LEFT join user_info ui on oo.userid = ui.userid 
group by 1,2
order by 1,2

-- WHERE절 대신 AND/OR를 쓰면 안됨
select * from online_order oo 
join item i on oo.itemid = i.id 
left join category c on i.category_id = c.id 
WHERE cate1 = '셔츠'












