-- �ŷ��� �����͸� ���� �⺻ ����

-- 1) ������ Ž��
-- 1. ��� �÷� �����ϱ� ('*' -> ���)
select * from gmv_trend 

-- 2. Ư�� �÷� �����ϱ� (���ϴ� �÷�'��'�� ������ ��)
select category, yyyy, mm from gmv_trend

-- 3. �ߺ��� ���� Ư�� �÷� ���� ('distinct' -> �ߺ��� ����)
select distinct category from gmv_trend 

select distinct yyyy, mm from gmv_trend

-- 2) Ư�� ������ ���� Ž��
-- 1-1. ������ �ϳ��� ��
----- ���ڿ� : 'between /  ��Һ�', ������ �Ἥ ���ǽ� ����
-- �������� �ϴ� 'where'�� ����, �׸��� �÷� + ����
select * from gmv_trend gt 
where yyyy = 2021

select * from gmv_trend gt 
where yyyy >= 2019

-- between + and �� Ư�� ���ǵ� ������ ���� ��� �� �� ����
select * from gmv_trend gt 
where yyyy between 2018 and 2020

select * from gmv_trend gt 
where yyyy != 2019

----- ���ڿ� : ������ / like, in, not in 
-- �ϳ��� ������ ������, �ΰ� �̻��� ������ in
select * from gmv_trend gt 
where category = 'ȭ��ǰ'

select * from gmv_trend gt
where category in ('ȭ��ǰ', '����')

select * from gmv_trend gt
where category not in ('ȭ��ǰ', '����')

-- like : Ư�� �ܾ �� �÷��� �Ÿ� �� ����
-- '%--%' : %%������ Ư�� �ܾ ���� �� ��� ��
-- '--%, %--' Ư���ܾ�� �����ϴ°͵�, �ڿ��� Ư���ܾ�� �����°͵� �� ��� ��
select * from gmv_trend gt 
where category like '%�м�%'


-- 1-2. ������ ������ �϶�
-- and(��� ���� ������) / or(�ϳ����̶� ������) / and+or : ��ȣ�� �ʿ�
select * from gmv_trend gt 
where category = 'ȭ��ǰ'
and yyyy = 2021

select * from gmv_trend gt 
where gmv > 1000000 or gmv < 10000

select * from gmv_trend gt 
where (gmv > 1000000 or gmv < 10000)
and yyyy = 2021


-- 3) ī�װ��� ���� �м� (groupby, �����Լ�)
-- 1. ī�װ���, ������ ����
--> gmv ���̺��� ī�װ�/�������� �̴µ� gmv�� sum�� �ϰ�
--> group by �� �ϰ����ϴ� �÷��� �״�� �ִ´� 
select category, yyyy, sum(gmv) as total_gmv
from gmv_trend gt 
group by category, yyyy 

select category, yyyy, sum(gmv) as total_gmv
from gmv_trend gt 
group by 1, 2

-- ī�װ��� �� �հ�
select category, sum(gmv) as total
from gmv_trend gt 
group by 1

-- ȭ��ǰ 2017�� ����
select category, yyyy, sum(gmv) as total 
from gmv_trend gt where category = 'ȭ��ǰ' and yyyy = 2017
group by 1, 2

-- ī�װ��� �÷��� ������� 2019�� ����
select category, yyyy, platform_type, sum(gmv) as total 
from gmv_trend gt  where platform_type = 'mobile' and yyyy = 2019
group by 1,2,3

-- 2018�� ī�װ��� ��� �ݾ�
select category, yyyy, round(avg(gmv), 0) as average
from gmv_trend gt where yyyy = 2018
group by 1, 2

-- ��ü ����
select sum(gmv) as gmv from gmv_trend gt 


-- HAVING - ���� ����� ���͸� �� �� ����
select category, sum(gmv) as gmv
from gmv_trend gt
where yyyy = 2020
group by 1
having sum(gmv) >= 10000000

-- ORDER BY - ����, DESC - ��������, 
select * from gmv_trend gt order by yyyy

select * from gmv_trend gt order by category, yyyy, mm

-- ������� ���������� ī���� ����
select category, sum(gmv) as total
from gmv_trend gt 
group by 1 order by total DESC

-- �ι�° �÷��� ���� ��� ����
select category , yyyy , sum(gmv) as gmv 
from gmv_trend gt group by 1,2
order by 1, 2 DESC


