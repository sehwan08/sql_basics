-- �ֹ� �����ͷ� ������ �����ϱ�


-- 1. ���ϴ� �������� �÷� �����ϱ�
-- 1) ���ڸ� ���ڿ��� �ٲ��ֱ�
select dt, cast(dt as varchar) as date
from online_order oo 

-- 2) ���ڿ� �÷����� �Ϻθ� �߶󳻱�
-- �տ��� �ܾ� �ϳ������� 1�� ����, left, substring, right�� ��ġ�κ��� ���� ��ȣ�� ������ �ȴ�
select dt, left(cast(dt as varchar),4) as yyyy,
substring(cast(dt as varchar), 5, 2) as mm,
right(cast(dt as varchar), 2) as dd
from online_order oo 

-- 3) yyyy-mm-dd �������� �̾��ֱ�
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


-- 4) null���� ��� ���ǰ����� �ٲ� �ֱ�
-- coalesce -> ������ �����͸� �ٲ���
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


--5) ���ϴ� �������� �÷� �߰�
select distinct case 
when gender = 'M' then '����' when gender = 'F' then '����' 
else 'NA' end as gender 
from user_info ui 

--6) ���ɴ� �׷� ������ (20��, 30��, 40��)
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

-- 7) TOP3 ī�װ��� �� �� ��ǰ�� ����� ��
-- ���� ������ �Ͽ� ī�װ��� ������� �̰� �ű⼭ ž 3���� �Ÿ���
-- ���� �÷��� �����. 
select
case when c.cate1 in ('��ĿƮ','Ƽ����','���ǽ�') then 'TOP 3'
else '��Ÿ' end as item_type
,sum(gmv) as gmv 
from online_order oo 
join item i on oo.itemid = i.id 
join category c on i.category_id = c.id 
group by 1
order by 2 desc


-- 8) Ư�� Ű���尡 ��� ��ǰ�� �׷��� ���� ��ǰ�� ���� ���ϱ� (+item ������ ���� Ȯ��)
select i.item_name,
case when i.item_name like '%����%' then '���� ����'
when i.item_name like '%��ũ%' then '��ũ ����'
when i.item_name like '%û��%' then 'û�� ����'
when i.item_name like '%�⺻%' then '�⺻ ����'
else '�̺з�'
end as item_concept
from item i 

select 
case when i.item_name like '%����%' then '���� ����'
when i.item_name like '%��ũ%' then '��ũ ����'
when i.item_name like '%û��%' then 'û�� ����'
when i.item_name like '%�⺻%' then '�⺻ ����'
else '�̺з�'
end as item_concept,
sum(gmv) as gmv
from online_order oo 
join item i on oo.itemid = i.id 
group by 1
order by 2 desc


-- ��¥ ���� �Լ�
-- 1) ������ ��Ÿ���� �Լ�
select now()

select current_date 

select current_timestamp 

-- 2) ��¥ ���Ŀ��� ���� �������� ��ȯ
select to_char(now(), 'yyyymmdd')

-- 3) ��¥ ���ϱ� ����
-- day, week, month, year �� ���� ����
select now() + interval '1 month'
select now() - interval '1 month'

-- 4) Ư�� ��¥�κ��� ����, ��, �� Ȯ��
-- day, week, month, year �� ���� ����
select date_part('month', now()) 

-- 5) Ư�� ��¥�κ��� 1�� ������ ����� Ȯ��
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


-- ���η�, �ǸŰ�, ���ͷ� ���
-- ��ο� ���� ���η� �̹Ƿ� '*' ��� ����, ���η� �� as discount_rate�� ����
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

-- ��ǰ ���̺�� �����Ͽ� Ȯ��
-- �ᱹ select�� ���°��� �� �տ� � ����� �ð��̳���
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



-- �δ� ���� ����, ���� �ݾ� ���
-- �δ� ��� ���� ���� = �� �Ǹ� ���� / �� �� ��
-- �δ� ��� ���� �ݾ� = �� ���� �ݾ� / �� �� ��

-- unitsold - �Ǹ� ����
-- userid �� ���µ� �ߺ��� ���ֱ� ���ؼ� 'distinct'�� ó��
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


-- �δ� ���űݾ��� ���� ��, ���ɴ��?
select ui.gender, ui.age_band, 
sum(gmv)  as gmv,
count(distinct oo.userid) as user_count,
sum(gmv) / count(distinct oo.userid)  as avg_gmv_per_customer 
from online_order oo 
join user_info ui on oo.userid = ui.userid 
group by 1,2
order by 5 desc












