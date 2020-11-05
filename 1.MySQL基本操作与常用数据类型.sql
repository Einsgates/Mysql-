MySQL基本操作与常用数据类型


一、基本操作

1.展示数据库：
show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| performance_schema |
| sakila             |
| sys                |
| testdb             |
| world              |
+--------------------+

2.创建数据库：
create database test;
Query OK, 1 row affected (0.04 sec)

3.使用该数据库：
use test;
Database changed

4.创建数据表：
create table pet (
	name varchar(20),
	owner varchar(20),
	species varchar(20),
	sex char(1),
	birth date,
	death date);
Query OK, 0 rows affected (0.10 sec)

5.查看数据表是否创建成功
show tables;
+----------------+
| Tables_in_test |
+----------------+
| pet            |
+----------------+
1 row in set (0.01 sec)

6.查看数据表详情
describe pet;
+---------+-------------+------+-----+---------+-------+
| Field   | Type        | Null | Key | Default | Extra |
+---------+-------------+------+-----+---------+-------+
| name    | varchar(20) | YES  |     | NULL    |       |
| owner   | varchar(20) | YES  |     | NULL    |       |
| species | varchar(20) | YES  |     | NULL    |       |
| sex     | char(1)     | YES  |     | NULL    |       |
| birth   | date        | YES  |     | NULL    |       |
| death   | date        | YES  |     | NULL    |       |
+---------+-------------+------+-----+---------+-------+
6 rows in set (0.02 sec)

7.查看表中记录
select * from pet;
Empty set (0.01 sec)

8.往表中添加数据
insert into pet
values('Puffball','Diane','hamster','f','1999-03-30',NULL);
Query OK, 1 row affected (0.01 sec)
再一次查询:
select * from pet;
+----------+-------+---------+------+------------+-------+
| name     | owner | species | sex  | birth      | death |
+----------+-------+---------+------+------------+-------+
| Puffball | Diane | hamster | f    | 1999-03-30 | NULL  |
+----------+-------+---------+------+------------+-------+
1 row in set (0.01 sec)
再一次操作:
insert into pet
values('旺财','周星驰','狗','公','1990-01-01',NULL);
Query OK, 1 row affected (0.01 sec)
查询:
select * from pet;
+----------+-----------+---------+------+------------+-------+
| name     | owner     | species | sex  | birth      | death |
+----------+-----------+---------+------+------------+-------+
| Puffball | Diane     | hamster | f    | 1999-03-30 | NULL  |
| 旺财     | 周星驰    | 狗      | 公   | 1990-01-01 | NULL  |
+----------+-----------+---------+------+------------+-------+
2 rows in set (0.00 sec)


二、常用数据类型

1.数值类型
类型					大小			范围（有符号）						范围（无符号）							用途
TINYINT			1 byte			(-128，127)							(0，255)	小整数值
SMALLINT		2 bytes			(-32 768，32 767)					(0，65 535)	大整数值
MEDIUMINT		3 bytes			(-8 388 608，8 388 607)				(0，16 777 215)	大整数值
INT或INTEGER		4 bytes			(-2 147 483 648，2 147 483 647)		(0，4 294 967 295)	大整数值
BIGINT			8 bytes			(-9,223,372,036,854,775,808，9 223 372 036 854 775 807)	(0，18 446 744 073 709 551 615)	极大整数值
FLOAT			4 bytes			(-3.402 823 466 E+38，-1.175 494 351 E-38)，0，(1.175 494 351 E-38，3.402 823 466 351 E+38)	0，(1.175 494 351 E-38，3.402 823 466 E+38)	单精度
浮点数值
DOUBLE			8 bytes	(-1.797 693 134 862 315 7 E+308，-2.225 073 858 507 201 4 E-308)，0，(2.225 073 858 507 201 4 E-308，1.797 693 134 862 315 7 E+308)	0，(2.225 073 858 507 201 4 E-308，1.797 693 134 862 315 7 E+308)	双精度
浮点数值
DECIMAL	对DECIMAL(M,D) ，如果M>D，为M+2否则为D+2	依赖于M和D的值	依赖于M和D的值	小数值

进行操作:
create table testType(  /*-128~127*/
	number TINYINT
);
Query OK, 0 rows affected (0.15 sec)
查看表：
show tables;
+----------------+
| Tables_in_test |
+----------------+
| pet            |
| testtype       |
+----------------+
2 rows in set (0.01 sec)
查看testType具体详情:
describe testtype;
+--------+---------+------+-----+---------+-------+
| Field  | Type    | Null | Key | Default | Extra |
+--------+---------+------+-----+---------+-------+
| number | tinyint | YES  |     | NULL    |       |
+--------+---------+------+-----+---------+-------+
1 row in set (0.01 sec)
往testType中添加数据:
insert into testtype values(127);
Query OK, 1 row affected (0.01 sec)
select * from testtype;
+--------+
| number |
+--------+
|    127 |
+--------+
1 row in set (0.00 sec)

2.日期和时间类型
类型		大小
( bytes)	范围						格式				用途
DATE	3	1000-01-01/9999-12-31	YYYY-MM-DD		日期值
TIME	3	'-838:59:59'/'838:59:59'	HH:MM:SS	时间值或持续时间
YEAR	1	1901/2155	YYYY	年份值
DATETIME	8	1000-01-01 00:00:00/9999-12-31 23:59:59	YYYY-MM-DD HH:MM:SS	混合日期和时间值
TIMESTAMP	4	
1970-01-01 00:00:00/2038

结束时间是第 2147483647 秒，北京时间 2038-1-19 11:14:07，格林尼治时间 2038年1月19日 凌晨 03:14:07

YYYYMMDD HHMMSS	混合日期和时间值，时间戳

3.字符串类型
类型				大小					用途
CHAR		0-255 bytes				定长字符串
VARCHAR		0-65535 bytes			变长字符串
TINYBLOB	0-255 bytes				不超过 255 个字符的二进制字符串
TINYTEXT	0-255 bytes				短文本字符串
BLOB		0-65 535 bytes			二进制形式的长文本数据
TEXT		0-65 535 bytes			长文本数据
MEDIUMBLOB	0-16 777 215 bytes		二进制形式的中等长度文本数据
MEDIUMTEXT	0-16 777 215 bytes		中等长度文本数据
LONGBLOB	0-4 294 967 295 bytes	二进制形式的极大文本数据
LONGTEXT	0-4 294 967 295 bytes	极大文本数据


三、数据类型如何选择
日期 选择按照格式
数值和字符串按照大小


四、增删改查

1.插入数据
insert into pet values('Fluffy','Harold','cat','f','1993-02-04',NULL);
insert into pet values('Claws','Gwen','cat','m','1994-03-17',NULL);
insert into pet values('Buffy','Harold','dog','f','1989-05-13',NULL);
insert into pet values('Fang','Benny','dog','m','1990-08-27',NULL);
insert into pet values('Bowser','Diane','dog','m','1979-08-31','1995-07-29');
insert into pet values('Chirpy','Gwen','bird','f','1998-09-11',NULL);
insert into pet values('Whistler','Gwen','bird',NULL,'1997-12-09',NULL);
insert into pet values('Slim','Benny','snake','m','1996-04-29',NULL);
insert into pet values('Puffball','Diane','hamster','f','1999-03-30',NULL);

select * from pet;
+----------+-----------+---------+------+------------+------------+
| name     | owner     | species | sex  | birth      | death      |
+----------+-----------+---------+------+------------+------------+
| Puffball | Diane     | hamster | f    | 1999-03-30 | NULL       |
| 旺财     | 周星驰    | 狗      | 公   | 1990-01-01 | NULL       |
| Fluffy   | Harold    | cat     | f    | 1993-02-04 | NULL       |
| Claws    | Gwen      | cat     | m    | 1994-03-17 | NULL       |
| Buffy    | Harold    | dog     | f    | 1989-05-13 | NULL       |
| Fang     | Benny     | dog     | m    | 1990-08-27 | NULL       |
| Bowser   | Diane     | dog     | m    | 1979-08-31 | 1995-07-29 |
| Chirpy   | Gwen      | bird    | f    | 1998-09-11 | NULL       |
| Slim     | Benny     | snake   | m    | 1996-04-29 | NULL       |
| Whistler | Gwen      | bird    | NULL | 1997-12-09 | NULL       |
+----------+-----------+---------+------+------------+------------+
10 rows in set (0.00 sec)

2.删除数据
删除Fluffy:
delete from pet where name='Fluffy';
Query OK, 2 rows affected (0.01 sec)
再查看:
select * from pet;
+----------+-----------+---------+------+------------+------------+
| name     | owner     | species | sex  | birth      | death      |
+----------+-----------+---------+------+------------+------------+
| Puffball | Diane     | hamster | f    | 1999-03-30 | NULL       |
| 旺财     | 周星驰    | 狗      | 公   | 1990-01-01 | NULL       |
| Claws    | Gwen      | cat     | m    | 1994-03-17 | NULL       |
| Buffy    | Harold    | dog     | f    | 1989-05-13 | NULL       |
| Fang     | Benny     | dog     | m    | 1990-08-27 | NULL       |
| Bowser   | Diane     | dog     | m    | 1979-08-31 | 1995-07-29 |
| Chirpy   | Gwen      | bird    | f    | 1998-09-11 | NULL       |
| Slim     | Benny     | snake   | m    | 1996-04-29 | NULL       |
| Whistler | Gwen      | bird    | NULL | 1997-12-09 | NULL       |
+----------+-----------+---------+------+------------+------------+
9 rows in set (0.00 sec)

3.修改数据
update pet set name = '旺旺财' where owner = "周星驰";
Query OK, 1 row affected (0.01 sec)
Rows matched: 1  Changed: 1  Warnings: 0
查看修改后的pet表:
select * from pet;
+-----------+-----------+---------+------+------------+------------+
| name      | owner     | species | sex  | birth      | death      |
+-----------+-----------+---------+------+------------+------------+
| 旺旺财    | 周星驰    | 狗      | 公   | 1990-01-01 | NULL       |
| Fluffy    | Harold    | cat     | f    | 1993-02-04 | NULL       |
| Claws     | Gwen      | cat     | m    | 1994-03-17 | NULL       |
| Buffy     | Harold    | dog     | f    | 1989-05-13 | NULL       |
| Fang      | Benny     | dog     | m    | 1990-08-27 | NULL       |
| Bowser    | Diane     | dog     | m    | 1979-08-31 | 1995-07-29 |
| Chirpy    | Gwen      | bird    | f    | 1998-09-11 | NULL       |
| Whistler  | Gwen      | bird    | NULL | 1997-12-09 | NULL       |
| Slim      | Benny     | snake   | m    | 1996-04-29 | NULL       |
| Puffball  | Diane     | hamster | f    | 1999-03-30 | NULL       |
+-----------+-----------+---------+------+------------+------------+
10 rows in set (0.00 sec)


总结：数据记录常见操作
增加：insert
删除：delete 
修改：update
查询：select