mysql 事务
mysql中，事务其实是一个最小的不可分割的工作单元,
事务能够保证一个业务的完整性

比如银行转账:
a -> -100
update user set money = money - 100 where name = 'a';

b -> +100
update user set money = money + 100 where name = 'b';

-- 实际程序中，如果只有一条语句执行成功了，
-- 而另外一条没有执行成功？
-- 出现数据前后不一致

-- 多条sql语句，可能会有同时成功的要求，要么就同时失败

-- mysql 中，如何控制事务？

1.mysql 默认是开启事务的(自动提交)
select @@autocommit;
+--------------+
| @@autocommit |
+--------------+
|            1 |
+--------------+
1 row in set (0.01 sec)

-- 默认事务开启的作用？
-- 当我们去执行一个sql 语句的时候，效果会立即体现出来，且不能回滚

create database bank;
use bank;
create table user(
	id int primary key,
	name varchar(20),
	money int
);
insert into user values(1,'a',1000);
-- 事务回滚：撤销sql语句执行效果
rollback;
+----+------+-------+
| id | name | money |
+----+------+-------+
|  1 | a    |  1000 |
+----+------+-------+
1 row in set (0.00 sec)
-- 此时不能回滚
-- 那该怎么办？

-- 设置 mysql 自动提交为 false
set autocommit = 0;
+--------------+
| @@autocommit |
+--------------+
|            0 |
+--------------+
1 row in set (0.00 sec)
-- 上面的操作，关闭了 mysql 的自动提交 (commit)
insert into user values(2,'b',1000);
+----+------+-------+
| id | name | money |
+----+------+-------+
|  1 | a    |  1000 |
|  2 | b    |  1000 |
+----+------+-------+
2 rows in set (0.00 sec)

rollback;
+----+------+-------+
| id | name | money |
+----+------+-------+
|  1 | a    |  1000 |
+----+------+-------+
1 row in set (0.00 sec)

-- 再一次插入数据
insert into user values(2,'b',1000);
-- 手动提交数据
commit;
-- 再撤销，是不可以撤销的 (持久性)
rollback;
select * from user;
+----+------+-------+
| id | name | money |
+----+------+-------+
|  1 | a    |  1000 |
|  2 | b    |  1000 |
+----+------+-------+
2 rows in set (0.00 sec)

-- 自动提交？@@autocommit = 1
-- 手动提交？commit;
-- 事务回滚？rollback;
-- 如果这个时候转账:
update user set money = money - 100 where name = 'a';
update user set money = money + 100 where name = 'b';
select * from user;
+----+------+-------+
| id | name | money |
+----+------+-------+
|  1 | a    |   900 |
|  2 | b    |  1100 |
+----+------+-------+
2 rows in set (0.00 sec)
rollback;
select * from user;
+----+------+-------+
| id | name | money |
+----+------+-------+
|  1 | a    |  1000 |
|  2 | b    |  1000 |
+----+------+-------+
2 rows in set (0.00 sec)
-- 事务给我们提供了一个返回的机会，可以使某一个语句失败时，
-- 让两个都失败
-- 返回正常模式:
set autocommit = 1;
+--------------+
| @@autocommit |
+--------------+
|            1 |
+--------------+
1 row in set (0.00 sec)

begin 或者 start transaction 都可以帮我们手动开启一个事务
select * from user;
+----+------+-------+
| id | name | money |
+----+------+-------+
|  1 | a    |  1000 |
|  2 | b    |  1000 |
+----+------+-------+
2 rows in set (0.00 sec)
update user set money = money - 100 where name = 'a';
update user set money = money + 100 where name = 'b';
select * from user;
+----+------+-------+
| id | name | money |
+----+------+-------+
|  1 | a    |   900 |
|  2 | b    |  1100 |
+----+------+-------+
2 rows in set (0.01 sec)
-- 事务回滚
rollback;
select * from user;
-- 没有被撤销
+----+------+-------+
| id | name | money |
+----+------+-------+
|  1 | a    |   900 |
|  2 | b    |  1100 |
+----+------+-------+
2 rows in set (0.00 sec)

-- 手动开启事务(1)
begin;
update user set money = money - 100 where name = 'a';
update user set money = money + 100 where name = 'b';
select * from user;
+----+------+-------+
| id | name | money |
+----+------+-------+
|  1 | a    |   800 |
|  2 | b    |  1200 |
+----+------+-------+
2 rows in set (0.00 sec)
rollback;
select * from user;
+----+------+-------+
| id | name | money |
+----+------+-------+
|  1 | a    |   900 |
|  2 | b    |  1100 |
+----+------+-------+
2 rows in set (0.00 sec)

-- 手动开启事务(2)
-- 事务开启之后，一旦 commit 提交，就不可以回滚 
-- (也就是当前的这个事务在提交的时候就结束了)
start transaction;
update user set money = money - 100 where name = 'a';
update user set money = money + 100 where name = 'b';
select * from user;
+----+------+-------+
| id | name | money |
+----+------+-------+
|  1 | a    |   700 |
|  2 | b    |  1300 |
+----+------+-------+
2 rows in set (0.00 sec)
rollback;
select * from user;
+----+------+-------+
| id | name | money |
+----+------+-------+
|  1 | a    |   800 |
|  2 | b    |  1200 |
+----+------+-------+
2 rows in set (0.00 sec)

总结：
事务的四大特征:
A 原子性：事务是最小的单位，不可再分割
C 一致性：事务要求，同一事务中的sql语句，必须保证同时成功或失败
I 隔离性：事务1和事务2之间是具有隔离性的
D 持久性：事务一旦结束(commit, rollback)，就不可以返回

事务开启：
1.修改默认提交 set autocommit = 0;
2.begin;
3.start transaction;

事务手动提交：commit;
事务手动回滚：rollback;




-- 事务的隔离性：
1.read uncommited; 读未提交的
2.read committed;  读已经提交的
3.repeatable read; 可以重复读
4.serializable;    串行化

1.read uncommited; 读未提交的
如果有事务a和事务b
a事务对数据进行操作，在操作过程中，事务没有被提交，但是
b可以看见a操作的结果
bank数据库user表
insert into user values(3,'小明',1000);
insert into user values(4,'淘宝店',1000);
select * from user;
+----+-----------+-------+
| id | name      | money |
+----+-----------+-------+
|  1 | a         |   800 |
|  2 | b         |  1200 |
|  3 | 小明      |  1000 |
|  4 | 淘宝店    |  1000 |
+----+-----------+-------+
4 rows in set (0.00 sec)
-- 如何查看数据库的隔离级别？
mysql 8.0:
-- 系统级别
select @@global.transaction_isolation;
-- 会话级别
select @@transaction_isolation;

-- mysql默认级别 REPEATABLE-READ 
+--------------------------------+
| @@global.transaction_isolation |
+--------------------------------+
| REPEATABLE-READ                |
+--------------------------------+
1 row in set (0.00 sec)

mysql 5.x
select @@global.tx_isolation;
select @@tx_isolation;

--如何修改隔离级别？
set global transaction isolation level read uncommitted;
select @@global.transaction_isolation;
+--------------------------------+
| @@global.transaction_isolation |
+--------------------------------+
| READ-UNCOMMITTED               |
+--------------------------------+
1 row in set (0.00 sec)

-- 转账：小明在淘宝店买鞋子，800块
-- 小明在成都ATM, 淘宝店在广州ATM
start transaction;
update user set money = money - 800 where name = '小明';
update user set money = money + 800 where name = '淘宝店';
select * from user;
+----+-----------+-------+
| id | name      | money |
+----+-----------+-------+
|  1 | a         |   800 |
|  2 | b         |  1200 |
|  3 | 小明      |   200 |
|  4 | 淘宝店    |  1800 |
+----+-----------+-------+
4 rows in set (0.00 sec)
-- 给淘宝店打电话，说你去查一下，是不是到账了
-- 淘宝店在广州查账
+----+-----------+-------+
| id | name      | money |
+----+-----------+-------+
|  1 | a         |   800 |
|  2 | b         |  1200 |
|  3 | 小明      |   200 |
|  4 | 淘宝店    |  1800 |
+----+-----------+-------+
4 rows in set (0.00 sec)
-- 发货
-- 晚上请女朋友吃好吃的，花了1800
-- 结账的时候发现钱不够
-- 小明，成都
rollback;
select * from user;
+----+-----------+-------+
| id | name      | money |
+----+-----------+-------+
|  1 | a         |   800 |
|  2 | b         |  1200 |
|  3 | 小明      |  1000 |
|  4 | 淘宝店    |  1000 |
+----+-----------+-------+
-- 钱不够？！

-- 如果两个不同的地方，都在进行操作，如果事务a开启之后，它的
-- 数据可以被其他事务读到。这样就会出现(脏读)
-- 一个事务读到了另外一个事务没有提交的数据——脏读
-- 在 uncommitted 情况下会出现 脏读


2.read committed; 读已经提交的
set global transaction isolation level read committed;
select @@global.transaction_isolation;
-- 修改隔离级别为 READ-COMMITTED
+--------------------------------+
| @@global.transaction_isolation |
+--------------------------------+
| READ-COMMITTED                 |
+--------------------------------+
1 row in set (0.00 sec)

bank数据库user表
小张:银行的会计
start transaction;
select * from user;
select * from user;
+----+-----------+-------+
| id | name      | money |
+----+-----------+-------+
|  1 | a         |   800 |
|  2 | b         |  1200 |
|  3 | 小明      |   200 |
|  4 | 淘宝店    |  1800 |
+----+-----------+-------+
4 rows in set (0.00 sec)
小张出去上厕所去了。。。抽烟

小王:
start transaction;
insert into user values(5,'c',100);
commit;
select * from user;
+----+-----------+-------+
| id | name      | money |
+----+-----------+-------+
|  1 | a         |   800 |
|  2 | b         |  1200 |
|  3 | 小明      |   200 |
|  4 | 淘宝店    |  1800 |
|  5 | c         |   100 |
+----+-----------+-------+
5 rows in set (0.00 sec)

小张上完厕所抽完烟回来了，要算平均数
select avg(money) from user;
+------------+
| avg(money) |
+------------+
|   820.0000 |
+------------+
1 row in set (0.00 sec)
-- money 平均值不是1000，变少了？
-- 虽然我能读到另外一个事务提交的数据，但是还会出现问题，就是
-- 读取同一个表的数据，发现前后不一致
-- 不可重复读现象: read committed


3.repeatable read; 可以重复读
-- 修改隔离级别
set global transaction isolation level repeatable read;
select @@global.transaction_isolation;
+--------------------------------+
| @@global.transaction_isolation |
+--------------------------------+
| REPEATABLE-READ                |
+--------------------------------+
1 row in set (0.00 sec)

-- 在REPEATABLE-READ 隔离级别下又会出现什么问题？
select * from user;
+----+-----------+-------+
| id | name      | money |
+----+-----------+-------+
|  1 | a         |   800 |
|  2 | b         |  1200 |
|  3 | 小明      |   200 |
|  4 | 淘宝店    |  1800 |
|  5 | c         |   100 |
+----+-----------+-------+
5 rows in set (0.00 sec)

-- 张全蛋-成都
start transaction;

-- 王尼玛-北京
start transaction;

-- 张全蛋-成都
insert into user values(6,'d',1000);

-- 王尼玛-北京
insert into user values(6,'d',1000);
select * from user;
+----+-----------+-------+
| id | name      | money |
+----+-----------+-------+
|  1 | a         |   800 |
|  2 | b         |  1200 |
|  3 | 小明      |   200 |
|  4 | 淘宝店    |  1800 |
|  5 | c         |   100 |
+----+-----------+-------+
5 rows in set (0.00 sec)
insert into user values(6,'d',1000);
ERROR 1062 (23000): Duplicate entry '6' for key 'user.PRIMARY'
-- 这种现象叫做 幻读！！
-- 事务a和事务b同时操作一张表，事务a提交的数据，
-- 也不能被事务b读到，就可以造成幻读


4.serializable;    串行化
set global transaction isolation level serializable;
select @@global.transaction_isolation;
-- 修改隔离级别
+--------------------------------+
| @@global.transaction_isolation |
+--------------------------------+
| SERIALIZABLE                   |
+--------------------------------+
1 row in set (0.00 sec)

select * from user;
+----+-----------+-------+
| id | name      | money |
+----+-----------+-------+
|  1 | a         |   800 |
|  2 | b         |  1200 |
|  3 | 小明      |   200 |
|  4 | 淘宝店    |  1800 |
|  5 | c         |   100 |
|  6 | d         |  1000 |
+----+-----------+-------+
6 rows in set (0.00 sec)

-- 张全蛋-成都
start transaction;

-- 王尼玛-北京
start transaction;

-- 张全蛋-成都
insert into user values(7,'赵铁柱',1000);
commit;
select * from user;
+----+-----------+-------+
| id | name      | money |
+----+-----------+-------+
|  1 | a         |   800 |
|  2 | b         |  1200 |
|  3 | 小明      |   200 |
|  4 | 淘宝店    |  1800 |
|  5 | c         |   100 |
|  6 | d         |  1000 |
|  7 | 赵铁柱    |  1000 |
+----+-----------+-------+
7 rows in set (0.00 sec)

-- 王尼玛-北京
select * from user;
+----+-----------+-------+
| id | name      | money |
+----+-----------+-------+
|  1 | a         |   800 |
|  2 | b         |  1200 |
|  3 | 小明      |   200 |
|  4 | 淘宝店    |  1800 |
|  5 | c         |   100 |
|  6 | d         |  1000 |
|  7 | 赵铁柱    |  1000 |
+----+-----------+-------+
7 rows in set (0.00 sec)

-- 张全蛋-成都
start transaction;
insert into user values(8,'王小花',1000);
-- sql语句被卡住了？
-- 当user表被另外一个事务操作的时候，其他食物里面的写操作，是不可以进行的
-- 进入排队状态(串行化)，直到王尼玛那边事务结束之后，张全蛋这个的写入操作才执行
-- 在没有等待超时的情况下
-- 王尼玛一旦commit，张全蛋这边李可执行成功

-- 串行化问题是：性能特差！！！
-- 性能：
READ-UNCOMMITTED > READ-COMMITTED > REPEATABLE-READ > SERIALIZABLE
-- 隔离级别越高，性能越差
mysql 默认级别是 REPEATABLE-READ


