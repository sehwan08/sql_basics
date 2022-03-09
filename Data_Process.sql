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
