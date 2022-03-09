-- 1. ������ Ž��
select * from online_order oo 

select * from item i 

select * from category c 

select * from user_info ui 

select * from gmv_trend gt 


-- Join
-- 1. ��ǰ ������� 'online_order', ��ǰ���� 'item' ���̺� �ִ�
-- �� �� ���̺��� �����Ͽ� ��� ����
-- ��ǰ�� ����� ���� ��, ����� ���� ������ ����
select itemid, sum(gmv) as gmv
from online_order oo 
group by 1

-- �̷��� �ϸ� ������ID�� �հ踸 ���´�. ���⿡ ī�װ��� �߰��Ͽ� ITEMID�� ���� ī�װ��� ����
select i.item_name, oo.itemid, sum(gmv) as gmv
from online_order oo 
join item i on oo.itemid = i.id 
group by 1,2
order by 3 desc


-- ī�װ��� �����
select c.cate1, c.cate2, c.cate3, sum(gmv) as gmv
from online_order oo 
join item i on oo.itemid = i.id 
join category c on i.category_id  = c.id 
group by 1,2,3
order by 4 desc


-- ���Ű��� ������ �м�
select ui.gender, ui.age_band, sum(gmv) as gmv
from user_info ui
join online_order oo on oo.userid = ui.userid 
group by 1,2
order by 1,2

-- where/join �Բ� ����
select i.item_name, sum(gmv) as gmv
from online_order oo 
join item i on oo.itemid = i.id 
join user_info ui on oo.userid = ui.userid 
where gender = 'M'
group by 1
order by 2 desc


-- INNER/LEFT JOIN ����
-- INNER JOIN�� NULL���� ������
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

-- WHERE�� ��� AND/OR�� ���� �ȵ�
select * from online_order oo 
join item i on oo.itemid = i.id 
left join category c on i.category_id = c.id 
WHERE cate1 = '����'












