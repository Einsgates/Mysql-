mysql建表约束

一、主键约束
它能够唯一确定一张表中的一条记录，也就是我们通过给某个字段添加约束，

就可以使得该字段不重复且不为空。
create table user(
	id int primary key,
	name varchar(20)
);
show tables;
+----------------+
| Tables_in_test |
+----------------+
| pet            |
| testtype       |
| user           |
+----------------+
3 rows in set (0.01 sec)

describe user;
+-------+-------------+------+-----+---------+-------+
| Field | Type        | Null | Key | Default | Extra |
+-------+-------------+------+-----+---------+-------+
| id    | int         | NO   | PRI | NULL    |       |
| name  | varchar(20) | YES  |     | NULL    |       |
+-------+-------------+------+-----+---------+-------+
2 rows in set (0.01 sec)

insert into user values(1,'张三');
insert into user values(1,'张三');
会报错，因为主键id唯一，可以将第二个id改成2
insert into user values(2,'张三');
并且，id不能为 NULL, 必须唯一确定

接下来在id和name两个上面添加约束
--联合主键
--只要联合的主键值加起来不重复即可
--联合主键任何一个字段都不能为空
create table user2(
	id int ,
	name varchar(20),
	password varchar(20),
	primary key(id, name)
);
Query OK, 0 rows affected (0.09 sec)

查看表属性:
desc user2; #desc为describe的简写
+----------+-------------+------+-----+---------+-------+
| Field    | Type        | Null | Key | Default | Extra |
+----------+-------------+------+-----+---------+-------+
| id       | int         | NO   | PRI | NULL    |       |
| name     | varchar(20) | NO   | PRI | NULL    |       |
| password | varchar(20) | YES  |     | NULL    |       |
+----------+-------------+------+-----+---------+-------+
3 rows in set (0.00 sec)

往里面添加数据:
insert into user2 values(1,'张三','123');
insert into user2 values(2,'张三','123');
insert into user2 values(1,'李四','123');
select * from user2;


二、自增约束
create table user3(
	id int primary key auto_increment,
	name varchar(20)
);
insert into user3 (name) values('张三');
select * from user3;
+----+--------+
| id | name   |
+----+--------+
|  1 | 张三   |
+----+--------+
1 row in set (0.00 sec)
会自动将id加一
insert into user3 (name) values('张三');
select * from user3;
+----+--------+
| id | name   |
+----+--------+
|  1 | 张三   |
|  2 | 张三   |
+----+--------+
2 rows in set (0.00 sec)

--如果创建表的时候，忘记创建主键约束，怎么办？
create table user4(
	id int,
	name varchar(20)
);

此时表并没有主键约束,长这个样子:
desc user4;
+-------+-------------+------+-----+---------+-------+
| Field | Type        | Null | Key | Default | Extra |
+-------+-------------+------+-----+---------+-------+
| id    | int         | YES  |     | NULL    |       |
| name  | varchar(20) | YES  |     | NULL    |       |
+-------+-------------+------+-----+---------+-------+

此时需添加主键:
alter table user4 add primary key(id);
desc user4;
+-------+-------------+------+-----+---------+-------+
| Field | Type        | Null | Key | Default | Extra |
+-------+-------------+------+-----+---------+-------+
| id    | int         | NO   | PRI | NULL    |       |
| name  | varchar(20) | YES  |     | NULL    |       |
+-------+-------------+------+-----+---------+-------+
2 rows in set (0.01 sec)

若要删除主键约束:
alter table user4 drop primary key;
desc user4;
+-------+-------------+------+-----+---------+-------+
| Field | Type        | Null | Key | Default | Extra |
+-------+-------------+------+-----+---------+-------+
| id    | int         | NO   |     | NULL    |       |
| name  | varchar(20) | YES  |     | NULL    |       |
+-------+-------------+------+-----+---------+-------+
2 rows in set (0.00 sec)

也可修改主键约束,使用modeify修改字段，添加约束:
alter table user4 modify id int primary key;
desc user4;
+-------+-------------+------+-----+---------+-------+
| Field | Type        | Null | Key | Default | Extra |
+-------+-------------+------+-----+---------+-------+
| id    | int         | NO   | PRI | NULL    |       |
| name  | varchar(20) | YES  |     | NULL    |       |
+-------+-------------+------+-----+---------+-------+
2 rows in set (0.01 sec)

三、唯一约束
--约束修饰的字段的值不可以重复
create table user5(
	id int,
	name varchar(20)
);
alter table user5 add unique(name);
desc user5;
+-------+-------------+------+-----+---------+-------+
| Field | Type        | Null | Key | Default | Extra |
+-------+-------------+------+-----+---------+-------+
| id    | int         | YES  |     | NULL    |       |
| name  | varchar(20) | YES  | UNI | NULL    |       |
+-------+-------------+------+-----+---------+-------+
2 rows in set (0.01 sec)

insert into user5 values(1,'张三');
insert into user5 values(1,'张三');
ERROR 1062 (23000): Duplicate entry '张三' for key 'user5.name'
上面唯一约束不是在建表时，而是在建表完成后才添加了一条alter语句来约束
当然，也可以在创建表直接添加:
create table user6(
	id int,
	name varchar(20),
	unique(name)
);
desc user6;
+-------+-------------+------+-----+---------+-------+
| Field | Type        | Null | Key | Default | Extra |
+-------+-------------+------+-----+---------+-------+
| id    | int         | YES  |     | NULL    |       |
| name  | varchar(20) | YES  | UNI | NULL    |       |
+-------+-------------+------+-----+---------+-------+
2 rows in set (0.01 sec)

当然，也可以这么写:
create table usern(
	id int,
	name varchar(20) unique
);

但是，把unique写在后面的好处在于可以便于添加多个唯一约束:
create table user7(
	id int,
	name varchar(20),
	unique(name,id)
);
desc user7;
+-------+-------------+------+-----+---------+-------+
| Field | Type        | Null | Key | Default | Extra |
+-------+-------------+------+-----+---------+-------+
| id    | int         | YES  |     | NULL    |       |
| name  | varchar(20) | YES  | MUL | NULL    |       |
+-------+-------------+------+-----+---------+-------+
2 rows in set (0.00 sec)
那么，id和name加起来重复即可，比如:
insert into user7 values(1,'zhangsan');
insert into user7 values(2,'zhangsan');
insert into user7 values(1,'lisi');
select * from user7;
+------+----------+
| id   | name     |
+------+----------+
|    1 | lisi     |
|    1 | zhangsan |
|    2 | zhangsan |
+------+----------+
3 rows in set (0.00 sec)

删除唯一约束:
alter table user7 drop index name;
desc user7;
+-------+-------------+------+-----+---------+-------+
| Field | Type        | Null | Key | Default | Extra |
+-------+-------------+------+-----+---------+-------+
| id    | int         | YES  |     | NULL    |       |
| name  | varchar(20) | YES  |     | NULL    |       |
+-------+-------------+------+-----+---------+-------+
2 rows in set (0.00 sec)

通过modify添加:
alter table user7 modify name varchar(20) unique;
desc user7;
+-------+-------------+------+-----+---------+-------+
| Field | Type        | Null | Key | Default | Extra |
+-------+-------------+------+-----+---------+-------+
| id    | int         | YES  |     | NULL    |       |
| name  | varchar(20) | YES  | UNI | NULL    |       |
+-------+-------------+------+-----+---------+-------+
2 rows in set (0.01 sec)

--总结:
--建表时就添加约束
--可以使用alter... add...
--alter...modify...

--删除 alter...drop...


四、非空约束
修饰的字段不能为空NULL
create table user9(
	id int,
	name varchar(20) not null
);
desc user9;
+-------+-------------+------+-----+---------+-------+
| Field | Type        | Null | Key | Default | Extra |
+-------+-------------+------+-----+---------+-------+
| id    | int         | YES  |     | NULL    |       |
| name  | varchar(20) | NO   |     | NULL    |       |
+-------+-------------+------+-----+---------+-------+
2 rows in set (0.00 sec)
表示name字段不能为空
比如这样写就不行，会报错:
insert into user9 (id) values(1);
--ERROR 1364 (HY000): Field 'name' doesn't have a default value
应该传name且不为空:
insert into user9 values(1,'张三');
Query OK, 1 row affected (0.01 sec)
select * from user9;
+------+--------+
| id   | name   |
+------+--------+
|    1 | 张三   |
+------+--------+
1 row in set (0.00 sec)

再添加一项，name不为空但id为空，也是可以哒:
insert into user9 (name) values('李四'); 
/*必须写(name) ，否则会报错*/
select * from user9;
+------+--------+
| id   | name   |
+------+--------+
|    1 | 张三   |
| NULL | 李四   |
+------+--------+
2 rows in set (0.00 sec)


五、默认约束
当我们插入字段值的时候，如果没有传值，就会使用默认值
create table user10(
	id int,
	name varchar(20),
	age int default 10
);
desc user10;
+-------+-------------+------+-----+---------+-------+
| Field | Type        | Null | Key | Default | Extra |
+-------+-------------+------+-----+---------+-------+
| id    | int         | YES  |     | NULL    |       |
| name  | varchar(20) | YES  |     | NULL    |       |
| age   | int         | YES  |     | 10      |       |
+-------+-------------+------+-----+---------+-------+
3 rows in set (0.01 sec)
age这里将默认为10，其他为NULL

insert into user10 (id,name) values(1,'张三');
insert into user10 values(1,'张三','19');
select * from user10;
+------+--------+------+
| id   | name   | age  |
+------+--------+------+
|    1 | 张三   |   10 |
|    1 | 张三   |   19 |
+------+--------+------+
2 rows in set (0.00 sec)
传了值就不会使用默认值了


六、外键约束
涉及到两个表：父表、子表
--主表、副表

--班级
create table classes(
	id int primary key,
	name varchar(20)
);
--学生表
create table students(
	id int primary key,
	name varchar(20),
	class_id int,
	foreign key(class_id) references classes(id)
);
desc classes;
+-------+-------------+------+-----+---------+-------+
| Field | Type        | Null | Key | Default | Extra |
+-------+-------------+------+-----+---------+-------+
| id    | int         | NO   | PRI | NULL    |       |
| name  | varchar(20) | YES  |     | NULL    |       |
+-------+-------------+------+-----+---------+-------+
2 rows in set (0.01 sec)
desc students;
+----------+-------------+------+-----+---------+-------+
| Field    | Type        | Null | Key | Default | Extra |
+----------+-------------+------+-----+---------+-------+
| id       | int         | NO   | PRI | NULL    |       |
| name     | varchar(20) | YES  |     | NULL    |       |
| class_id | int         | YES  | MUL | NULL    |       |
+----------+-------------+------+-----+---------+-------+
3 rows in set (0.01 sec)

往classes里面添加数据:
insert into classes values(1,'一班');
insert into classes values(2,'二班');
insert into classes values(3,'三班');
insert into classes values(4,'四班');
select * from classes;
+----+--------+
| id | name   |
+----+--------+
|  1 | 一班   |
|  2 | 二班   |
|  3 | 三班   |
|  4 | 四班   |
+----+--------+
4 rows in set (0.00 sec)

往students里面添加数据:
insert into students values(1001,'张三',1);
insert into students values(1002,'张三',2);
insert into students values(1003,'张三',3);
insert into students values(1004,'张三',4);
select * from students;
+------+--------+----------+
| id   | name   | class_id |
+------+--------+----------+
| 1001 | 张三   |        1 |
| 1002 | 张三   |        2 |
| 1003 | 张三   |        3 |
| 1004 | 张三   |        4 |
+------+--------+----------+
4 rows in set (0.00 sec)
不能添加之外的

--主表classes中没有的数据值，在副表中，是不可以使用的
--主表中的记录被副表(子表)引用，是不可以删除的
比如这样写就不行，会报错:
delete from classes where id=4;
ERROR 1451 (23000): Cannot delete or update a parent row:
a foreign key constraint fails (`test`.`students`, 
CONSTRAINT `students_ibfk_1` FOREIGN KEY (`class_id`)
REFERENCES `classes` (`id`))


