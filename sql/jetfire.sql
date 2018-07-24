-- ----------------------------
-- 1、存储每一个已配置的 jobDetail 的详细信息
-- ----------------------------
drop table if exists QRTZ_JOB_DETAILS;
create table QRTZ_JOB_DETAILS (
    sched_name           varchar(120)    not null,
    job_name             varchar(200)    not null,
    job_group            varchar(200)    not null,
    description          varchar(250)    null,
    job_class_name       varchar(250)    not null,
    is_durable           varchar(1)      not null,
    is_nonconcurrent     varchar(1)      not null,
    is_update_data       varchar(1)      not null,
    requests_recovery    varchar(1)      not null,
    job_data             blob            null,
    primary key (sched_name,job_name,job_group)
) engine=innodb default charset=utf8;

-- ----------------------------
-- 2、 存储已配置的 Trigger 的信息
-- ----------------------------
drop table if exists QRTZ_TRIGGERS;
create table QRTZ_TRIGGERS (
    sched_name           varchar(120)    not null,
    trigger_name         varchar(200)    not null,
    trigger_group        varchar(200)    not null,
    job_name             varchar(200)    not null,
    job_group            varchar(200)    not null,
    description          varchar(250)    null,
    next_fire_time       bigint(13)      null,
    prev_fire_time       bigint(13)      null,
    priority             integer         null,
    trigger_state        varchar(16)     not null,
    trigger_type         varchar(8)      not null,
    start_time           bigint(13)      not null,
    end_time             bigint(13)      null,
    calendar_name        varchar(200)    null,
    misfire_instr        smallint(2)     null,
    job_data             blob            null,
    primary key (sched_name,trigger_name,trigger_group),
    foreign key (sched_name,job_name,job_group) references QRTZ_JOB_DETAILS(sched_name,job_name,job_group)
) engine=innodb default charset=utf8;

-- ----------------------------
-- 3、 存储简单的 Trigger，包括重复次数，间隔，以及已触发的次数
-- ----------------------------
drop table if exists QRTZ_SIMPLE_TRIGGERS;
create table QRTZ_SIMPLE_TRIGGERS (
    sched_name           varchar(120)    not null,
    trigger_name         varchar(200)    not null,
    trigger_group        varchar(200)    not null,
    repeat_count         bigint(7)       not null,
    repeat_interval      bigint(12)      not null,
    times_triggered      bigint(10)      not null,
    primary key (sched_name,trigger_name,trigger_group),
    foreign key (sched_name,trigger_name,trigger_group) references QRTZ_TRIGGERS(sched_name,trigger_name,trigger_group)
) engine=innodb default charset=utf8;

-- ----------------------------
-- 4、 存储 Cron Trigger，包括 Cron 表达式和时区信息
-- ----------------------------
drop table if exists QRTZ_CRON_TRIGGERS;
create table QRTZ_CRON_TRIGGERS (
    sched_name           varchar(120)    not null,
    trigger_name         varchar(200)    not null,
    trigger_group        varchar(200)    not null,
    cron_expression      varchar(200)    not null,
    time_zone_id         varchar(80),
    primary key (sched_name,trigger_name,trigger_group),
    foreign key (sched_name,trigger_name,trigger_group) references QRTZ_TRIGGERS(sched_name,trigger_name,trigger_group)
) engine=innodb default charset=utf8;

-- ----------------------------
-- 5、 Trigger 作为 Blob 类型存储(用于 Quartz 用户用 JDBC 创建他们自己定制的 Trigger 类型，JobStore 并不知道如何存储实例的时候)
-- ----------------------------
drop table if exists QRTZ_BLOB_TRIGGERS;
create table QRTZ_BLOB_TRIGGERS (
    sched_name           varchar(120)    not null,
    trigger_name         varchar(200)    not null,
    trigger_group        varchar(200)    not null,
    blob_data            blob            null,
    primary key (sched_name,trigger_name,trigger_group),
    foreign key (sched_name,trigger_name,trigger_group) references QRTZ_TRIGGERS(sched_name,trigger_name,trigger_group)
) engine=innodb default charset=utf8;

-- ----------------------------
-- 6、 以 Blob 类型存储存放日历信息， quartz可配置一个日历来指定一个时间范围
-- ----------------------------
drop table if exists QRTZ_CALENDARS;
create table QRTZ_CALENDARS (
    sched_name           varchar(120)    not null,
    calendar_name        varchar(200)    not null,
    calendar             blob            not null,
    primary key (sched_name,calendar_name)
) engine=innodb default charset=utf8;

-- ----------------------------
-- 7、 存储已暂停的 Trigger 组的信息
-- ----------------------------
drop table if exists QRTZ_PAUSED_TRIGGER_GRPS;
create table QRTZ_PAUSED_TRIGGER_GRPS (
    sched_name           varchar(120)    not null,
    trigger_group        varchar(200)    not null,
    primary key (sched_name,trigger_group)
) engine=innodb default charset=utf8;

-- ----------------------------
-- 8、 存储与已触发的 Trigger 相关的状态信息，以及相联 Job 的执行信息
-- ----------------------------
drop table if exists QRTZ_FIRED_TRIGGERS;
create table QRTZ_FIRED_TRIGGERS (
    sched_name           varchar(120)    not null,
    entry_id             varchar(95)     not null,
    trigger_name         varchar(200)    not null,
    trigger_group        varchar(200)    not null,
    instance_name        varchar(200)    not null,
    fired_time           bigint(13)      not null,
    sched_time           bigint(13)      not null,
    priority             integer         not null,
    state                varchar(16)     not null,
    job_name             varchar(200)    null,
    job_group            varchar(200)    null,
    is_nonconcurrent     varchar(1)      null,
    requests_recovery    varchar(1)      null,
    primary key (sched_name,entry_id)
) engine=innodb default charset=utf8;

-- ----------------------------
-- 9、 存储少量的有关 Scheduler 的状态信息，假如是用于集群中，可以看到其他的 Scheduler 实例
-- ----------------------------
drop table if exists QRTZ_SCHEDULER_STATE;
create table QRTZ_SCHEDULER_STATE (
    sched_name           varchar(120)    not null,
    instance_name        varchar(200)    not null,
    last_checkin_time    bigint(13)      not null,
    checkin_interval     bigint(13)      not null,
    primary key (sched_name,instance_name)
) engine=innodb default charset=utf8;

-- ----------------------------
-- 10、 存储程序的悲观锁的信息(假如使用了悲观锁)
-- ----------------------------
drop table if exists QRTZ_LOCKS;
create table QRTZ_LOCKS (
    sched_name           varchar(120)    not null,
    lock_name            varchar(40)     not null,
    primary key (sched_name,lock_name)
) engine=innodb default charset=utf8;

drop table if exists QRTZ_SIMPROP_TRIGGERS;
create table QRTZ_SIMPROP_TRIGGERS (
    sched_name           varchar(120)    not null,
    trigger_name         varchar(200)    not null,
    trigger_group        varchar(200)    not null,
    str_prop_1           varchar(512)    null,
    str_prop_2           varchar(512)    null,
    str_prop_3           varchar(512)    null,
    int_prop_1           int             null,
    int_prop_2           int             null,
    long_prop_1          bigint          null,
    long_prop_2          bigint          null,
    dec_prop_1           numeric(13,4)   null,
    dec_prop_2           numeric(13,4)   null,
    bool_prop_1          varchar(1)      null,
    bool_prop_2          varchar(1)      null,
    primary key (sched_name,trigger_name,trigger_group),
    foreign key (sched_name,trigger_name,trigger_group) references QRTZ_TRIGGERS(sched_name,trigger_name,trigger_group)
) engine=innodb default charset=utf8;

commit;

-- ----------------------------
-- 1、部门表
-- ----------------------------
drop table if exists sys_dept;
create table sys_dept (
  dept_id 			int(11) 		not null auto_increment    comment '部门id',
  parent_id 		int(11) 		default 0 			       comment '父部门id',
  dept_name 		varchar(30) 	default '' 				   comment '部门名称',
  order_num 		int(4) 			default 0 			       comment '显示顺序',
  leader            varchar(20)     default ''                 comment '负责人',
  phone             varchar(11)     default ''                 comment '联系电话',
  email             varchar(50)     default ''                 comment '邮箱',
  status 			char(1) 		default '0' 			   comment '部门状态（0正常 1停用）',
  create_by         varchar(64)     default ''                 comment '创建者',
  create_time 	    datetime                                   comment '创建时间',
  update_by         varchar(64)     default ''                 comment '更新者',
  update_time       datetime                                   comment '更新时间',
  primary key (dept_id)
) engine=innodb auto_increment=200 default charset=utf8 comment = '部门表';

-- ----------------------------
-- 初始化-部门表数据
-- ----------------------------
insert into sys_dept values(100,  0,   'Jetfire集团', 0, 'Jetfire', '15888888888', 'Jetfire@qq.com', '0', 'admin', '2018-03-16 11-33-00', 'Jetfire', '2018-03-16 11-33-00');
insert into sys_dept values(101,  100, '研发部门', 1, 'Jetfire', '15888888888', 'Jetfire@qq.com', '0', 'admin', '2018-03-16 11-33-00', 'Jetfire', '2018-03-16 11-33-00');
insert into sys_dept values(102,  100, '市场部门', 2, 'Jetfire', '15888888888', 'Jetfire@qq.com', '0', 'admin', '2018-03-16 11-33-00', 'Jetfire', '2018-03-16 11-33-00');
insert into sys_dept values(103,  100, '测试部门', 3, 'Jetfire', '15888888888', 'Jetfire@qq.com', '0', 'admin', '2018-03-16 11-33-00', 'Jetfire', '2018-03-16 11-33-00');
insert into sys_dept values(104,  100, '财务部门', 4, 'Jetfire', '15888888888', 'Jetfire@qq.com', '0', 'admin', '2018-03-16 11-33-00', 'Jetfire', '2018-03-16 11-33-00');
insert into sys_dept values(105,  100, '运维部门', 5, 'Jetfire', '15888888888', 'Jetfire@qq.com', '0', 'admin', '2018-03-16 11-33-00', 'Jetfire', '2018-03-16 11-33-00');
insert into sys_dept values(106,  101, '研发一部', 1, 'Jetfire', '15888888888', 'Jetfire@qq.com', '0', 'admin', '2018-03-16 11-33-00', 'Jetfire', '2018-03-16 11-33-00');
insert into sys_dept values(107,  101, '研发二部', 2, 'Jetfire', '15888888888', 'Jetfire@qq.com', '0', 'admin', '2018-03-16 11-33-00', 'Jetfire', '2018-03-16 11-33-00');
insert into sys_dept values(108,  102, '市场一部', 1, 'Jetfire', '15888888888', 'Jetfire@qq.com', '0', 'admin', '2018-03-16 11-33-00', 'Jetfire', '2018-03-16 11-33-00');
insert into sys_dept values(109,  102, '市场二部', 2, 'Jetfire', '15888888888', 'Jetfire@qq.com', '1', 'admin', '2018-03-16 11-33-00', 'Jetfire', '2018-03-16 11-33-00');


-- ----------------------------
-- 2、用户信息表
-- ----------------------------
drop table if exists sys_user;
create table sys_user (
  user_id 			int(11) 		not null auto_increment    comment '用户ID',
  dept_id 			int(11) 		default null			   comment '部门ID',
  login_name 		varchar(30) 	not null 				   comment '登录账号',
  user_name 		varchar(30) 	not null 				   comment '用户昵称',
  user_type 		varchar(2) 	    default '00' 		       comment '用户类型（00系统用户）',
  email  			varchar(50) 	default '' 				   comment '用户邮箱',
  phonenumber  		varchar(11) 	default '' 				   comment '手机号码',
  sex  		        char(1) 	    default '0' 			   comment '用户性别（0男 1女 2未知）',
  avatar            varchar(100) 	default '' 				   comment '头像路径',
  password 			varchar(50) 	default '' 				   comment '密码',
  salt 				varchar(20) 	default '' 				   comment '盐加密',
  status 			char(1) 		default '0' 			   comment '帐号状态（0正常 1停用）',
  del_flag			char(1) 		default '0' 			   comment '删除标志（0代表存在 2代表删除）',
  login_ip          varchar(20)     default ''                 comment '最后登陆IP',
  login_date        datetime                                   comment '最后登陆时间',
  create_by         varchar(64)     default ''                 comment '创建者',
  create_time 	    datetime                                   comment '创建时间',
  update_by         varchar(64)     default ''                 comment '更新者',
  update_time       datetime                                   comment '更新时间',
  remark 		    varchar(500) 	default '' 				   comment '备注',
  primary key (user_id)
) engine=innodb auto_increment=100 default charset=utf8 comment = '用户信息表';

-- ----------------------------
-- 初始化-用户信息表数据
-- ----------------------------
insert into sys_user values(1,  106, 'admin', 'Jetfire', '00', 'Jetfire@163.com', '15888888888', '1', '', '29c67a30398638269fe600f73a054934', '111111', '0', '0', '127.0.0.1', '2018-03-16 11-33-00', 'admin', '2018-03-16 11-33-00', 'Jetfire', '2018-03-16 11-33-00', '管理员');
insert into sys_user values(2,  108, 'Jetfire',    'Jetfire', '00', 'Jetfire@qq.com',  '15666666666', '1', '', '8e6d98b90472783cc73c17047ddccf36', '222222', '0', '0', '127.0.0.1', '2018-03-16 11-33-00', 'admin', '2018-03-16 11-33-00', 'Jetfire', '2018-03-16 11-33-00', '测试员');

-- ----------------------------
-- 3、岗位信息表
-- ----------------------------
drop table if exists sys_post;
create table sys_post
(
    post_id       int(11)         not null auto_increment    comment '岗位ID',
	post_code     varchar(64)     not null                   comment '岗位编码',
	post_name     varchar(50)     not null                   comment '岗位名称',
	post_sort     int(4)          not null                   comment '显示顺序',
	status        char(1)         not null                   comment '状态（0正常 1停用）',
    create_by     varchar(64)     default ''                 comment '创建者',
    create_time   datetime                                   comment '创建时间',
    update_by     varchar(64) 	  default ''			     comment '更新者',
	update_time   datetime                                   comment '更新时间',
    remark 		  varchar(500) 	  default '' 				 comment '备注',
	primary key (post_id)
) engine=innodb default charset=utf8 comment = '岗位信息表';

-- ----------------------------
-- 初始化-岗位信息表数据
-- ----------------------------
insert into sys_post values(1, 'ceo',  '董事长',    1, '0', 'admin', '2018-03-16 11-33-00', 'Jetfire', '2018-03-16 11-33-00', '');
insert into sys_post values(2, 'se',   '项目经理',  2, '0', 'admin', '2018-03-16 11-33-00', 'Jetfire', '2018-03-16 11-33-00', '');
insert into sys_post values(3, 'hr',   '人力资源',  3, '0', 'admin', '2018-03-16 11-33-00', 'Jetfire', '2018-03-16 11-33-00', '');
insert into sys_post values(4, 'user', '普通员工',  4, '0', 'admin', '2018-03-16 11-33-00', 'Jetfire', '2018-03-16 11-33-00', '');


-- ----------------------------
-- 4、角色信息表
-- ----------------------------
drop table if exists sys_role;
create table sys_role (
  role_id 			int(11) 		not null auto_increment    comment '角色ID',
  role_name 		varchar(30) 	not null 				   comment '角色名称',
  role_key 		    varchar(100) 	not null 				   comment '角色权限字符串',
  role_sort         int(4)          not null                   comment '显示顺序',
  status 			char(1) 		not null 			       comment '角色状态（0正常 1停用）',
  create_by         varchar(64)     default ''                 comment '创建者',
  create_time 		datetime                                   comment '创建时间',
  update_by 		varchar(64) 	default ''			       comment '更新者',
  update_time 		datetime                                   comment '更新时间',
  remark 			varchar(500) 	default '' 				   comment '备注',
  primary key (role_id)
) engine=innodb auto_increment=100 default charset=utf8 comment = '角色信息表';

-- ----------------------------
-- 初始化-角色信息表数据
-- ----------------------------
insert into sys_role values('1', '管理员',   'admin',  1,  '0', 'admin', '2018-03-16 11-33-00', 'Jetfire', '2018-03-16 11-33-00', '管理员');
insert into sys_role values('2', '普通角色', 'common', 2,  '0', 'admin', '2018-03-16 11-33-00', 'Jetfire', '2018-03-16 11-33-00', '普通角色');


-- ----------------------------
-- 5、菜单权限表
-- ----------------------------
drop table if exists sys_menu;
create table sys_menu (
  menu_id 			int(11) 		not null auto_increment    comment '菜单ID',
  menu_name 		varchar(50) 	not null 				   comment '菜单名称',
  parent_id 		int(11) 		default 0 			       comment '父菜单ID',
  order_num 		int(4) 			default null 			   comment '显示顺序',
  url 				varchar(200) 	default ''				   comment '请求地址',
  menu_type 		char(1) 		default '' 			       comment '菜单类型（M目录 C菜单 F按钮）',
  visible 			char(1) 		default 0 				   comment '菜单状态（0显示 1隐藏）',
  perms 			varchar(100) 	default '' 				   comment '权限标识',
  icon 				varchar(100) 	default '' 				   comment '菜单图标',
  create_by         varchar(64)     default ''                 comment '创建者',
  create_time 		datetime                                   comment '创建时间',
  update_by 		varchar(64) 	default ''			       comment '更新者',
  update_time 		datetime                                   comment '更新时间',
  remark 			varchar(500) 	default '' 				   comment '备注',
  primary key (menu_id)
) engine=innodb auto_increment=2000 default charset=utf8 comment = '菜单权限表';

-- ----------------------------
-- 初始化-菜单信息表数据
-- ----------------------------
-- 一级菜单
insert into sys_menu values('1', '系统管理', '0', '1', '#', 'M', '0', '', 'fa fa-gear',         'admin', '2018-03-16 11-33-00', 'Jetfire', '2018-03-16 11-33-00', '系统管理目录');
insert into sys_menu values('2', '系统监控', '0', '2', '#', 'M', '0', '', 'fa fa-video-camera', 'admin', '2018-03-16 11-33-00', 'Jetfire', '2018-03-16 11-33-00', '系统监控目录');
insert into sys_menu values('3', '系统工具', '0', '3', '#', 'M', '0', '', 'fa fa-bars',         'admin', '2018-03-16 11-33-00', 'Jetfire', '2018-03-16 11-33-00', '系统工具目录');
-- 二级菜单
insert into sys_menu values('100',  '用户管理', '1', '1', '/system/user',        'C', '0', 'system:user:view',         '#', 'admin', '2018-03-16 11-33-00', 'Jetfire', '2018-03-16 11-33-00', '用户管理菜单');
insert into sys_menu values('101',  '角色管理', '1', '2', '/system/role',        'C', '0', 'system:role:view',         '#', 'admin', '2018-03-16 11-33-00', 'Jetfire', '2018-03-16 11-33-00', '角色管理菜单');
insert into sys_menu values('102',  '菜单管理', '1', '3', '/system/menu',        'C', '0', 'system:menu:view',         '#', 'admin', '2018-03-16 11-33-00', 'Jetfire', '2018-03-16 11-33-00', '菜单管理菜单');
insert into sys_menu values('103',  '部门管理', '1', '4', '/system/dept',        'C', '0', 'system:dept:view',         '#', 'admin', '2018-03-16 11-33-00', 'Jetfire', '2018-03-16 11-33-00', '部门管理菜单');
insert into sys_menu values('104',  '岗位管理', '1', '5', '/system/post',        'C', '0', 'system:post:view',         '#', 'admin', '2018-03-16 11-33-00', 'Jetfire', '2018-03-16 11-33-00', '岗位管理菜单');
insert into sys_menu values('105',  '字典管理', '1', '6', '/system/dict',        'C', '0', 'system:dict:view',         '#', 'admin', '2018-03-16 11-33-00', 'Jetfire', '2018-03-16 11-33-00', '字典管理菜单');
insert into sys_menu values('106',  '参数设置', '1', '7', '/system/config',      'C', '0', 'system:config:view',       '#', 'admin', '2018-03-16 11-33-00', 'Jetfire', '2018-03-16 11-33-00', '参数设置菜单');
insert into sys_menu values('107',  '通知公告', '1', '8', '/system/notice',      'C', '0', 'system:notice:view',       '#', 'admin', '2018-03-16 11-33-00', 'Jetfire', '2018-03-16 11-33-00', '通知公告菜单');
insert into sys_menu values('108',  '日志管理', '1', '9', '#',                   'M', '0', '',                         '#', 'admin', '2018-03-16 11-33-00', 'Jetfire', '2018-03-16 11-33-00', '日志管理菜单');
insert into sys_menu values('109',  '在线用户', '2', '1', '/monitor/online',     'C', '0', 'monitor:online:view',      '#', 'admin', '2018-03-16 11-33-00', 'Jetfire', '2018-03-16 11-33-00', '在线用户菜单');
insert into sys_menu values('110',  '定时任务', '2', '2', '/monitor/job',        'C', '0', 'monitor:job:view',         '#', 'admin', '2018-03-16 11-33-00', 'Jetfire', '2018-03-16 11-33-00', '定时任务菜单');
insert into sys_menu values('111',  '数据监控', '2', '3', '/monitor/data',       'C', '0', 'monitor:data:view',        '#', 'admin', '2018-03-16 11-33-00', 'Jetfire', '2018-03-16 11-33-00', '数据监控菜单');
insert into sys_menu values('112',  '表单构建', '3', '1', '/tool/build',         'C', '0', 'tool:build:view',          '#', 'admin', '2018-03-16 11-33-00', 'Jetfire', '2018-03-16 11-33-00', '表单构建菜单');
insert into sys_menu values('113',  '代码生成', '3', '2', '/tool/gen',           'C', '0', 'tool:gen:view',            '#', 'admin', '2018-03-16 11-33-00', 'Jetfire', '2018-03-16 11-33-00', '代码生成菜单');
insert into sys_menu values('114',  '系统接口', '3', '3', '/tool/swagger',       'C', '0', 'tool:swagger:view',        '#', 'admin', '2018-03-16 11-33-00', 'Jetfire', '2018-03-16 11-33-00', '系统接口菜单');
-- 三级菜单
insert into sys_menu values('500',  '操作日志', '108', '1', '/monitor/operlog',    'C', '0', 'monitor:operlog:view',     '#', 'admin', '2018-03-16 11-33-00', 'Jetfire', '2018-03-16 11-33-00', '操作日志菜单');
insert into sys_menu values('501',  '登录日志', '108', '2', '/monitor/logininfor', 'C', '0', 'monitor:logininfor:view',  '#', 'admin', '2018-03-16 11-33-00', 'Jetfire', '2018-03-16 11-33-00', '登录日志菜单');
-- 用户管理按钮
insert into sys_menu values('1000', '用户查询', '100', '1',  '#',  'F', '0', 'system:user:list',        '#', 'admin', '2018-03-16 11-33-00', 'Jetfire', '2018-03-16 11-33-00', '');
insert into sys_menu values('1001', '用户新增', '100', '2',  '#',  'F', '0', 'system:user:add',         '#', 'admin', '2018-03-16 11-33-00', 'Jetfire', '2018-03-16 11-33-00', '');
insert into sys_menu values('1002', '用户修改', '100', '3',  '#',  'F', '0', 'system:user:edit',        '#', 'admin', '2018-03-16 11-33-00', 'Jetfire', '2018-03-16 11-33-00', '');
insert into sys_menu values('1003', '用户删除', '100', '4',  '#',  'F', '0', 'system:user:remove',      '#', 'admin', '2018-03-16 11-33-00', 'Jetfire', '2018-03-16 11-33-00', '');
insert into sys_menu values('1004', '重置密码', '100', '5',  '#',  'F', '0', 'system:user:resetPwd',    '#', 'admin', '2018-03-16 11-33-00', 'Jetfire', '2018-03-16 11-33-00', '');
-- 角色管理按钮
insert into sys_menu values('1005', '角色查询', '101', '1',  '#',  'F', '0', 'system:role:list',        '#', 'admin', '2018-03-16 11-33-00', 'Jetfire', '2018-03-16 11-33-00', '');
insert into sys_menu values('1006', '角色新增', '101', '2',  '#',  'F', '0', 'system:role:add',         '#', 'admin', '2018-03-16 11-33-00', 'Jetfire', '2018-03-16 11-33-00', '');
insert into sys_menu values('1007', '角色修改', '101', '3',  '#',  'F', '0', 'system:role:edit',        '#', 'admin', '2018-03-16 11-33-00', 'Jetfire', '2018-03-16 11-33-00', '');
insert into sys_menu values('1008', '角色删除', '101', '4',  '#',  'F', '0', 'system:role:remove',      '#', 'admin', '2018-03-16 11-33-00', 'Jetfire', '2018-03-16 11-33-00', '');
-- 菜单管理按钮
insert into sys_menu values('1009', '菜单查询', '102', '1',  '#',  'F', '0', 'system:menu:list',        '#', 'admin', '2018-03-16 11-33-00', 'Jetfire', '2018-03-16 11-33-00', '');
insert into sys_menu values('1010', '菜单新增', '102', '2',  '#',  'F', '0', 'system:menu:add',         '#', 'admin', '2018-03-16 11-33-00', 'Jetfire', '2018-03-16 11-33-00', '');
insert into sys_menu values('1011', '菜单修改', '102', '3',  '#',  'F', '0', 'system:menu:edit',        '#', 'admin', '2018-03-16 11-33-00', 'Jetfire', '2018-03-16 11-33-00', '');
insert into sys_menu values('1012', '菜单删除', '102', '4',  '#',  'F', '0', 'system:menu:remove',      '#', 'admin', '2018-03-16 11-33-00', 'Jetfire', '2018-03-16 11-33-00', '');
-- 部门管理按钮
insert into sys_menu values('1013', '部门查询', '103', '1',  '#',  'F', '0', 'system:dept:list',        '#', 'admin', '2018-03-16 11-33-00', 'Jetfire', '2018-03-16 11-33-00', '');
insert into sys_menu values('1014', '部门新增', '103', '2',  '#',  'F', '0', 'system:dept:add',         '#', 'admin', '2018-03-16 11-33-00', 'Jetfire', '2018-03-16 11-33-00', '');
insert into sys_menu values('1015', '部门修改', '103', '3',  '#',  'F', '0', 'system:dept:edit',        '#', 'admin', '2018-03-16 11-33-00', 'Jetfire', '2018-03-16 11-33-00', '');
insert into sys_menu values('1016', '部门删除', '103', '4',  '#',  'F', '0', 'system:dept:remove',      '#', 'admin', '2018-03-16 11-33-00', 'Jetfire', '2018-03-16 11-33-00', '');
-- 岗位管理按钮
insert into sys_menu values('1017', '岗位查询', '104', '1',  '#',  'F', '0', 'system:post:list',        '#', 'admin', '2018-03-16 11-33-00', 'Jetfire', '2018-03-16 11-33-00', '');
insert into sys_menu values('1018', '岗位新增', '104', '2',  '#',  'F', '0', 'system:post:add',         '#', 'admin', '2018-03-16 11-33-00', 'Jetfire', '2018-03-16 11-33-00', '');
insert into sys_menu values('1019', '岗位修改', '104', '3',  '#',  'F', '0', 'system:post:edit',        '#', 'admin', '2018-03-16 11-33-00', 'Jetfire', '2018-03-16 11-33-00', '');
insert into sys_menu values('1020', '岗位删除', '104', '4',  '#',  'F', '0', 'system:post:remove',      '#', 'admin', '2018-03-16 11-33-00', 'Jetfire', '2018-03-16 11-33-00', '');
-- 字典管理按钮
insert into sys_menu values('1021', '字典查询', '105', '1', '#',  'F', '0', 'system:dict:list',         '#', 'admin', '2018-03-16 11-33-00', 'Jetfire', '2018-03-16 11-33-00', '');
insert into sys_menu values('1022', '字典新增', '105', '2', '#',  'F', '0', 'system:dict:add',          '#', 'admin', '2018-03-16 11-33-00', 'Jetfire', '2018-03-16 11-33-00', '');
insert into sys_menu values('1023', '字典修改', '105', '3', '#',  'F', '0', 'system:dict:edit',         '#', 'admin', '2018-03-16 11-33-00', 'Jetfire', '2018-03-16 11-33-00', '');
insert into sys_menu values('1024', '字典删除', '105', '4', '#',  'F', '0', 'system:dict:remove',       '#', 'admin', '2018-03-16 11-33-00', 'Jetfire', '2018-03-16 11-33-00', '');
-- 参数设置按钮
insert into sys_menu values('1025', '参数查询', '106', '1', '#',  'F', '0', 'system:config:list',      '#', 'admin', '2018-03-16 11-33-00', 'Jetfire', '2018-03-16 11-33-00', '');
insert into sys_menu values('1026', '参数新增', '106', '2', '#',  'F', '0', 'system:config:add',       '#', 'admin', '2018-03-16 11-33-00', 'Jetfire', '2018-03-16 11-33-00', '');
insert into sys_menu values('1027', '参数修改', '106', '3', '#',  'F', '0', 'system:config:edit',      '#', 'admin', '2018-03-16 11-33-00', 'Jetfire', '2018-03-16 11-33-00', '');
insert into sys_menu values('1028', '参数删除', '106', '4', '#',  'F', '0', 'system:config:remove',    '#', 'admin', '2018-03-16 11-33-00', 'Jetfire', '2018-03-16 11-33-00', '');
-- 通知公告按钮
insert into sys_menu values('1029', '公告查询', '107', '1', '#',  'F', '0', 'system:notice:list',      '#', 'admin', '2018-03-16 11-33-00', 'Jetfire', '2018-03-16 11-33-00', '');
insert into sys_menu values('1030', '公告新增', '107', '2', '#',  'F', '0', 'system:notice:add',       '#', 'admin', '2018-03-16 11-33-00', 'Jetfire', '2018-03-16 11-33-00', '');
insert into sys_menu values('1031', '公告修改', '107', '3', '#',  'F', '0', 'system:notice:edit',      '#', 'admin', '2018-03-16 11-33-00', 'Jetfire', '2018-03-16 11-33-00', '');
insert into sys_menu values('1032', '公告删除', '107', '4', '#',  'F', '0', 'system:notice:remove',    '#', 'admin', '2018-03-16 11-33-00', 'Jetfire', '2018-03-16 11-33-00', '');
-- 操作日志按钮
insert into sys_menu values('1033', '操作查询', '500', '1', '#',  'F', '0', 'monitor:operlog:list',    '#', 'admin', '2018-03-16 11-33-00', 'Jetfire', '2018-03-16 11-33-00', '');
insert into sys_menu values('1034', '操作删除', '500', '2', '#',  'F', '0', 'monitor:operlog:remove',  '#', 'admin', '2018-03-16 11-33-00', 'Jetfire', '2018-03-16 11-33-00', '');
insert into sys_menu values('1035', '详细信息', '500', '3', '#',  'F', '0', 'monitor:operlog:detail',  '#', 'admin', '2018-03-16 11-33-00', 'Jetfire', '2018-03-16 11-33-00', '');
-- 登录日志按钮
insert into sys_menu values('1036', '登录查询', '501', '1', '#',  'F', '0', 'monitor:logininfor:list',         '#', 'admin', '2018-03-16 11-33-00', 'Jetfire', '2018-03-16 11-33-00', '');
insert into sys_menu values('1037', '登录删除', '501', '2', '#',  'F', '0', 'monitor:logininfor:remove',       '#', 'admin', '2018-03-16 11-33-00', 'Jetfire', '2018-03-16 11-33-00', '');
-- 在线用户按钮
insert into sys_menu values('1038', '在线查询', '109', '1', '#',  'F', '0', 'monitor:online:list',             '#', 'admin', '2018-03-16 11-33-00', 'Jetfire', '2018-03-16 11-33-00', '');
insert into sys_menu values('1039', '批量强退', '109', '2', '#',  'F', '0', 'monitor:online:batchForceLogout', '#', 'admin', '2018-03-16 11-33-00', 'Jetfire', '2018-03-16 11-33-00', '');
insert into sys_menu values('1040', '单条强退', '109', '3', '#',  'F', '0', 'monitor:online:forceLogout',      '#', 'admin', '2018-03-16 11-33-00', 'Jetfire', '2018-03-16 11-33-00', '');
-- 定时任务按钮
insert into sys_menu values('1041', '任务查询', '110', '1', '#',  'F', '0', 'monitor:job:list',                '#', 'admin', '2018-03-16 11-33-00', 'Jetfire', '2018-03-16 11-33-00', '');
insert into sys_menu values('1042', '任务新增', '110', '2', '#',  'F', '0', 'monitor:job:add',                 '#', 'admin', '2018-03-16 11-33-00', 'Jetfire', '2018-03-16 11-33-00', '');
insert into sys_menu values('1043', '任务修改', '110', '3', '#',  'F', '0', 'monitor:job:edit',                '#', 'admin', '2018-03-16 11-33-00', 'Jetfire', '2018-03-16 11-33-00', '');
insert into sys_menu values('1044', '任务删除', '110', '4', '#',  'F', '0', 'monitor:job:remove',              '#', 'admin', '2018-03-16 11-33-00', 'Jetfire', '2018-03-16 11-33-00', '');
insert into sys_menu values('1045', '状态修改', '110', '5', '#',  'F', '0', 'monitor:job:changeStatus',        '#', 'admin', '2018-03-16 11-33-00', 'Jetfire', '2018-03-16 11-33-00', '');
-- 代码生成按钮
insert into sys_menu values('1046', '生成查询', '113', '1', '#',  'F', '0', 'tool:gen:list',  '#', 'admin', '2018-03-16 11-33-00', 'Jetfire', '2018-03-16 11-33-00', '');
insert into sys_menu values('1047', '生成代码', '113', '2', '#',  'F', '0', 'tool:gen:code',  '#', 'admin', '2018-03-16 11-33-00', 'Jetfire', '2018-03-16 11-33-00', '');


-- ----------------------------
-- 6、用户和角色关联表  用户N-1角色
-- ----------------------------
drop table if exists sys_user_role;
create table sys_user_role (
  user_id 	int(11) not null comment '用户ID',
  role_id 	int(11) not null comment '角色ID',
  primary key(user_id, role_id)
) engine=innodb default charset=utf8 comment = '用户和角色关联表';

-- ----------------------------
-- 初始化-用户和角色关联表数据
-- ----------------------------
insert into sys_user_role values ('1', '1');
insert into sys_user_role values ('2', '2');


-- ----------------------------
-- 7、角色和菜单关联表  角色1-N菜单
-- ----------------------------
drop table if exists sys_role_menu;
create table sys_role_menu (
  role_id 	int(11) not null comment '角色ID',
  menu_id 	int(11) not null comment '菜单ID',
  primary key(role_id, menu_id)
) engine=innodb default charset=utf8 comment = '角色和菜单关联表';

-- ----------------------------
-- 初始化-角色和菜单关联表数据
-- ----------------------------
insert into sys_role_menu values ('1', '1');
insert into sys_role_menu values ('1', '2');
insert into sys_role_menu values ('1', '3');
insert into sys_role_menu values ('1', '100');
insert into sys_role_menu values ('1', '101');
insert into sys_role_menu values ('1', '102');
insert into sys_role_menu values ('1', '103');
insert into sys_role_menu values ('1', '104');
insert into sys_role_menu values ('1', '105');
insert into sys_role_menu values ('1', '106');
insert into sys_role_menu values ('1', '107');
insert into sys_role_menu values ('1', '108');
insert into sys_role_menu values ('1', '109');
insert into sys_role_menu values ('1', '110');
insert into sys_role_menu values ('1', '111');
insert into sys_role_menu values ('1', '112');
insert into sys_role_menu values ('1', '113');
insert into sys_role_menu values ('1', '114');
insert into sys_role_menu values ('1', '500');
insert into sys_role_menu values ('1', '501');
insert into sys_role_menu values ('1', '1000');
insert into sys_role_menu values ('1', '1001');
insert into sys_role_menu values ('1', '1002');
insert into sys_role_menu values ('1', '1003');
insert into sys_role_menu values ('1', '1004');
insert into sys_role_menu values ('1', '1005');
insert into sys_role_menu values ('1', '1006');
insert into sys_role_menu values ('1', '1007');
insert into sys_role_menu values ('1', '1008');
insert into sys_role_menu values ('1', '1009');
insert into sys_role_menu values ('1', '1010');
insert into sys_role_menu values ('1', '1011');
insert into sys_role_menu values ('1', '1012');
insert into sys_role_menu values ('1', '1013');
insert into sys_role_menu values ('1', '1014');
insert into sys_role_menu values ('1', '1015');
insert into sys_role_menu values ('1', '1016');
insert into sys_role_menu values ('1', '1017');
insert into sys_role_menu values ('1', '1018');
insert into sys_role_menu values ('1', '1019');
insert into sys_role_menu values ('1', '1020');
insert into sys_role_menu values ('1', '1021');
insert into sys_role_menu values ('1', '1022');
insert into sys_role_menu values ('1', '1023');
insert into sys_role_menu values ('1', '1024');
insert into sys_role_menu values ('1', '1025');
insert into sys_role_menu values ('1', '1026');
insert into sys_role_menu values ('1', '1027');
insert into sys_role_menu values ('1', '1028');
insert into sys_role_menu values ('1', '1029');
insert into sys_role_menu values ('1', '1030');
insert into sys_role_menu values ('1', '1031');
insert into sys_role_menu values ('1', '1032');
insert into sys_role_menu values ('1', '1033');
insert into sys_role_menu values ('1', '1034');
insert into sys_role_menu values ('1', '1035');
insert into sys_role_menu values ('1', '1036');
insert into sys_role_menu values ('1', '1037');
insert into sys_role_menu values ('1', '1038');
insert into sys_role_menu values ('1', '1039');
insert into sys_role_menu values ('1', '1040');
insert into sys_role_menu values ('1', '1041');
insert into sys_role_menu values ('1', '1042');
insert into sys_role_menu values ('1', '1043');
insert into sys_role_menu values ('1', '1044');
insert into sys_role_menu values ('1', '1045');
insert into sys_role_menu values ('1', '1046');
insert into sys_role_menu values ('1', '1047');

-- ----------------------------
-- 8、用户与岗位关联表  用户1-N岗位
-- ----------------------------
drop table if exists sys_user_post;
create table sys_user_post
(
	user_id varchar(64) not null comment '用户ID',
	post_id varchar(64) not null comment '岗位ID',
	primary key (user_id, post_id)
) engine=innodb default charset=utf8 comment = '用户与岗位关联表';

-- ----------------------------
-- 初始化-用户与岗位关联表数据
-- ----------------------------
insert into sys_user_post values ('1', '1');
insert into sys_user_post values ('2', '2');


-- ----------------------------
-- 9、操作日志记录
-- ----------------------------
drop table if exists sys_oper_log;
create table sys_oper_log (
  oper_id 			int(11) 		not null auto_increment    comment '日志主键',
  title             varchar(50)     default ''                 comment '模块标题',
  action            varchar(100)    default ''                 comment '功能请求',
  method            varchar(100)    default ''                 comment '方法名称',
  channel           varchar(20)     default ''                 comment '来源渠道（manage后台用户 mobile手机端用户 other其它）',
  oper_name 	    varchar(50)     default '' 		 	 	   comment '操作人员',
  dept_name 		varchar(50)     default '' 		 	 	   comment '部门名称',
  oper_url 		    varchar(255) 	default '' 				   comment '请求URL',
  oper_ip 			varchar(30) 	default '' 				   comment '主机地址',
  oper_location     varchar(255)    default ''                 comment '操作地点',
  oper_param 		varchar(255) 	default '' 				   comment '请求参数',
  status 			char(1) 		default '0'				   comment '操作状态（0正常 1异常）',
  error_msg 		varchar(2000) 	default '' 				   comment '错误消息',
  oper_time 		datetime                                   comment '操作时间',
  primary key (oper_id)
) engine=innodb auto_increment=100 default charset=utf8 comment = '操作日志记录';


-- ----------------------------
-- 10、字典类型表
-- ----------------------------
drop table if exists sys_dict_type;
create table sys_dict_type
(
	dict_id          int(11) 		 not null auto_increment    comment '字典主键',
	dict_name        varchar(100)    default ''                 comment '字典名称',
	dict_type        varchar(100)    default ''                 comment '字典类型',
    status 			 char(1) 		 default '0'			    comment '状态（0正常 1停用）',
    create_by        varchar(64)     default ''                 comment '创建者',
    create_time      datetime                                   comment '创建时间',
    update_by        varchar(64) 	 default ''			        comment '更新者',
	update_time      datetime                                   comment '更新时间',
    remark 	         varchar(500) 	 default '' 				comment '备注',
	primary key (dict_id),
	unique (dict_type)
) engine=innodb auto_increment=100 default charset=utf8 comment = '字典类型表';

insert into sys_dict_type values(1,  '用户性别', 'sys_user_sex',        '0', 'admin', '2018-03-16 11-33-00', 'Jetfire', '2018-03-16 11-33-00', '用户性别列表');
insert into sys_dict_type values(2,  '菜单状态', 'sys_show_hide',       '0', 'admin', '2018-03-16 11-33-00', 'Jetfire', '2018-03-16 11-33-00', '菜单状态列表');
insert into sys_dict_type values(3,  '系统开关', 'sys_normal_disable',  '0', 'admin', '2018-03-16 11-33-00', 'Jetfire', '2018-03-16 11-33-00', '系统开关列表');
insert into sys_dict_type values(4,  '任务状态', 'sys_job_status',      '0', 'admin', '2018-03-16 11-33-00', 'Jetfire', '2018-03-16 11-33-00', '任务状态列表');
insert into sys_dict_type values(5,  '系统是否', 'sys_yes_no',          '0', 'admin', '2018-03-16 11-33-00', 'Jetfire', '2018-03-16 11-33-00', '系统是否列表');
insert into sys_dict_type values(6,  '通知类型', 'sys_notice_type',     '0', 'admin', '2018-03-16 11-33-00', 'Jetfire', '2018-03-16 11-33-00', '通知类型列表');
insert into sys_dict_type values(7,  '通知状态', 'sys_notice_status',   '0', 'admin', '2018-03-16 11-33-00', 'Jetfire', '2018-03-16 11-33-00', '通知状态列表');
insert into sys_dict_type values(8,  '操作类型', 'sys_oper_type',       '0', 'admin', '2018-03-16 11-33-00', 'Jetfire', '2018-03-16 11-33-00', '操作类型列表');
insert into sys_dict_type values(9,  '系统状态', 'sys_common_status',   '0', 'admin', '2018-03-16 11-33-00', 'Jetfire', '2018-03-16 11-33-00', '登录状态列表');

-- ----------------------------
-- 11、字典数据表
-- ----------------------------
drop table if exists sys_dict_data;
create table sys_dict_data
(
	dict_code        int(11) 		 not null auto_increment    comment '字典编码',
	dict_sort        int(4)          default 0                  comment '字典排序',
	dict_label       varchar(100)    default ''                 comment '字典标签',
	dict_value       varchar(100)    default ''                 comment '字典键值',
	dict_type        varchar(100)    default ''                 comment '字典类型',
	css_class        varchar(500)    default ''                 comment '样式属性',
	list_class       varchar(500)    default ''                 comment '回显样式',
	is_default       char(1)         default 'N'                comment '是否默认（Y是 N否）',
    status 			 char(1) 		 default '0'			    comment '状态（0正常 1停用）',
    create_by        varchar(64)     default ''                 comment '创建者',
    create_time      datetime                                   comment '创建时间',
    update_by        varchar(64) 	 default ''			        comment '更新者',
	update_time      datetime                                   comment '更新时间',
    remark 	         varchar(500) 	 default '' 				comment '备注',
	primary key (dict_code)
) engine=innodb auto_increment=100 default charset=utf8 comment = '字典数据表';


insert into sys_dict_data values(1,  1,  '男',       '0',  'sys_user_sex',        '',                                 '',        'Y', '0', 'admin', '2018-03-16 11-33-00', 'Jetfire', '2018-03-16 11-33-00', '性别男');
insert into sys_dict_data values(2,  2,  '女',       '1',  'sys_user_sex',        '',                                 '',        'N', '0', 'admin', '2018-03-16 11-33-00', 'Jetfire', '2018-03-16 11-33-00', '性别女');
insert into sys_dict_data values(3,  3,  '未知',     '2',  'sys_user_sex',        '',                                 '',        'N', '0', 'admin', '2018-03-16 11-33-00', 'Jetfire', '2018-03-16 11-33-00', '性别未知');
insert into sys_dict_data values(4,  1,  '显示',     '0',  'sys_show_hide',       'radio radio-info radio-inline',    'primary', 'Y', '0', 'admin', '2018-03-16 11-33-00', 'Jetfire', '2018-03-16 11-33-00', '显示菜单');
insert into sys_dict_data values(5,  2,  '隐藏',     '1',  'sys_show_hide',       'radio radio-danger radio-inline',  'danger',  'N', '0', 'admin', '2018-03-16 11-33-00', 'Jetfire', '2018-03-16 11-33-00', '隐藏菜单');
insert into sys_dict_data values(6,  1,  '正常',     '0',  'sys_normal_disable',  'radio radio-info radio-inline',    'primary', 'Y', '0', 'admin', '2018-03-16 11-33-00', 'Jetfire', '2018-03-16 11-33-00', '正常状态');
insert into sys_dict_data values(7,  2,  '停用',     '1',  'sys_normal_disable',  'radio radio-danger radio-inline',  'danger',  'N', '0', 'admin', '2018-03-16 11-33-00', 'Jetfire', '2018-03-16 11-33-00', '停用状态');
insert into sys_dict_data values(8,  1,  '正常',     '0',  'sys_job_status',      'radio radio-info radio-inline',    'primary', 'Y', '0', 'admin', '2018-03-16 11-33-00', 'Jetfire', '2018-03-16 11-33-00', '正常状态');
insert into sys_dict_data values(9,  2,  '暂停',     '1',  'sys_job_status',      'radio radio-danger radio-inline',  'danger',  'N', '0', 'admin', '2018-03-16 11-33-00', 'Jetfire', '2018-03-16 11-33-00', '停用状态');
insert into sys_dict_data values(10, 1,  '是',       'Y',  'sys_yes_no',          'radio radio-info radio-inline',    'primary', 'Y', '0', 'admin', '2018-03-16 11-33-00', 'Jetfire', '2018-03-16 11-33-00', '系统默认是');
insert into sys_dict_data values(11, 2,  '否',       'N',  'sys_yes_no',          'radio radio-danger radio-inline',  'danger',  'N', '0', 'admin', '2018-03-16 11-33-00', 'Jetfire', '2018-03-16 11-33-00', '系统默认否');
insert into sys_dict_data values(12, 1,  '通知',     '1',  'sys_notice_type',     '',                                 'warning', 'Y', '0', 'admin', '2018-03-16 11-33-00', 'Jetfire', '2018-03-16 11-33-00', '通知');
insert into sys_dict_data values(13, 2,  '公告',     '2',  'sys_notice_type',     '',                                 'success', 'N', '0', 'admin', '2018-03-16 11-33-00', 'Jetfire', '2018-03-16 11-33-00', '公告');
insert into sys_dict_data values(14, 1,  '正常',     '0',  'sys_notice_status',   'radio radio-info radio-inline',    'primary', 'Y', '0', 'admin', '2018-03-16 11-33-00', 'Jetfire', '2018-03-16 11-33-00', '正常状态');
insert into sys_dict_data values(15, 2,  '关闭',     '1',  'sys_notice_status',   'radio radio-danger radio-inline',  'danger',  'N', '0', 'admin', '2018-03-16 11-33-00', 'Jetfire', '2018-03-16 11-33-00', '关闭状态');
insert into sys_dict_data values(16, 1,  '新增',     '1',  'sys_oper_type',        '',                                'info',    'N', '0', 'admin', '2018-03-16 11-33-00', 'Jetfire', '2018-03-16 11-33-00', '新增操作');
insert into sys_dict_data values(17, 2,  '修改',     '2',  'sys_oper_type',        '',                                'info',    'N', '0', 'admin', '2018-03-16 11-33-00', 'Jetfire', '2018-03-16 11-33-00', '新增操作');
insert into sys_dict_data values(18, 3,  '删除',     '3',  'sys_oper_type',        '',                                'danger',  'N', '0', 'admin', '2018-03-16 11-33-00', 'Jetfire', '2018-03-16 11-33-00', '新增操作');
insert into sys_dict_data values(19, 4,  '授权',     '4',  'sys_oper_type',        '',                                'primary', 'N', '0', 'admin', '2018-03-16 11-33-00', 'Jetfire', '2018-03-16 11-33-00', '新增操作');
insert into sys_dict_data values(20, 5,  '导出',     '5',  'sys_oper_type',        '',                                'warning', 'N', '0', 'admin', '2018-03-16 11-33-00', 'Jetfire', '2018-03-16 11-33-00', '新增操作');
insert into sys_dict_data values(21, 6,  '导入',     '6',  'sys_oper_type',        '',                                'warning', 'N', '0', 'admin', '2018-03-16 11-33-00', 'Jetfire', '2018-03-16 11-33-00', '新增操作');
insert into sys_dict_data values(22, 7,  '强退',     '7',  'sys_oper_type',        '',                                'danger',  'N', '0', 'admin', '2018-03-16 11-33-00', 'Jetfire', '2018-03-16 11-33-00', '新增操作');
insert into sys_dict_data values(23, 8,  '生成代码', '8',  'sys_oper_type',        '',                                'warning', 'N', '0', 'admin', '2018-03-16 11-33-00', 'Jetfire', '2018-03-16 11-33-00', '新增操作');
insert into sys_dict_data values(24, 1,  '成功',     '0',  'sys_common_status',    '',                                'primary', 'N', '0', 'admin', '2018-03-16 11-33-00', 'Jetfire', '2018-03-16 11-33-00', '正常状态');
insert into sys_dict_data values(25, 2,  '失败',     '1',  'sys_common_status',    '',                                'danger',  'N', '0', 'admin', '2018-03-16 11-33-00', 'Jetfire', '2018-03-16 11-33-00', '停用状态');

-- ----------------------------
-- 12、参数配置表
-- ----------------------------
drop table if exists sys_config;
create table sys_config (
	config_id 		   int(5) 	     not null auto_increment    comment '参数主键',
	config_name        varchar(100)  default ''                 comment '参数名称',
	config_key         varchar(100)  default ''                 comment '参数键名',
	config_value       varchar(100)  default ''                 comment '参数键值',
	config_type        char(1)       default 'N'                comment '系统内置（Y是 N否）',
    create_by          varchar(64)   default ''                 comment '创建者',
    create_time 	   datetime                                 comment '创建时间',
    update_by          varchar(64)   default ''                 comment '更新者',
    update_time        datetime                                 comment '更新时间',
	remark 	           varchar(500)  default '' 				comment '备注',
	primary key (config_id)
) engine=innodb auto_increment=100 default charset=utf8 comment = '参数配置表';

insert into sys_config values(1, '主框架页-默认皮肤样式名称', 'sys.index.skinName',     'skin-default',  'Y', 'admin', '2018-03-16 11-33-00', 'Jetfire', '2018-03-16 11-33-00', '默认 skin-default、蓝色 skin-blue、黄色 skin-yellow' );
insert into sys_config values(2, '用户管理-账号初始密码',     'sys.user.initPassword',  '123456',        'Y', 'admin', '2018-03-16 11-33-00', 'Jetfire', '2018-03-16 11-33-00', '初始化密码 123456' );


-- ----------------------------
-- 13、系统访问记录
-- ----------------------------
drop table if exists sys_logininfor;
create table sys_logininfor (
  info_id 		 int(11) 	   not null auto_increment   comment '访问ID',
  login_name 	 varchar(50)   default '' 			     comment '登录账号',
  ipaddr 		 varchar(50)   default '' 			     comment '登录IP地址',
  login_location varchar(255)  default ''                comment '登录地点',
  browser  		 varchar(50)   default '' 			     comment '浏览器类型',
  os      		 varchar(50)   default '' 			     comment '操作系统',
  status 		 char(1) 	   default '0' 			     comment '登录状态（0成功 1失败）',
  msg      		 varchar(255)  default '' 			     comment '提示消息',
  login_time 	 datetime                                comment '访问时间',
  primary key (info_id)
) engine=innodb auto_increment=100 default charset=utf8 comment = '系统访问记录';


-- ----------------------------
-- 14、在线用户记录
-- ----------------------------
drop table if exists sys_user_online;
create table sys_user_online (
  sessionId 	    varchar(50)  default ''              	comment '用户会话id',
  login_name 	    varchar(50)  default '' 		 	 	comment '登录账号',
  dept_name 		varchar(50)  default '' 		 	 	comment '部门名称',
  ipaddr 		    varchar(50)  default '' 			 	comment '登录IP地址',
  login_location    varchar(255) default ''                 comment '登录地点',
  browser  		    varchar(50)  default '' 			 	comment '浏览器类型',
  os      		    varchar(50)  default '' 			 	comment '操作系统',
  status      	    varchar(10)  default '' 			 	comment '在线状态on_line在线off_line离线',
  start_timestsamp 	datetime                                comment 'session创建时间',
  last_access_time  datetime                                comment 'session最后访问时间',
  expire_time 	    int(5) 		 default 0 			 	    comment '超时时间，单位为分钟',
  primary key (sessionId)
) engine=innodb default charset=utf8 comment = '在线用户记录';


-- ----------------------------
-- 15、定时任务调度表
-- ----------------------------
drop table if exists sys_job;
create table sys_job (
  job_id 		      int(11) 	    not null auto_increment    comment '任务ID',
  job_name            varchar(64)   default ''                 comment '任务名称',
  job_group           varchar(64)   default ''                 comment '任务组名',
  method_name         varchar(500)  default ''                 comment '任务方法',
  method_params       varchar(200)  default ''                 comment '方法参数',
  cron_expression     varchar(255)  default ''                 comment 'cron执行表达式',
  misfire_policy      varchar(20)   default '0'                comment '计划执行错误策略（0默认 1继续 2等待 3放弃）',
  status              char(1)       default '0'                comment '状态（0正常 1暂停）',
  create_by           varchar(64)   default ''                 comment '创建者',
  create_time         datetime                                 comment '创建时间',
  update_by           varchar(64)   default ''                 comment '更新者',
  update_time         datetime                                 comment '更新时间',
  remark              varchar(500)  default ''                 comment '备注信息',
  primary key (job_id, job_name, job_group)
) engine=innodb auto_increment=100 default charset=utf8 comment = '定时任务调度表';

insert into sys_job values(1, 'ryTask', '系统默认（无参）', 'ryNoParams',  '',   '0/10 * * * * ?', '0', '1', 'admin', '2018-03-16 11-33-00', 'Jetfire', '2018-03-16 11-33-00', '');
insert into sys_job values(2, 'ryTask', '系统默认（有参）', 'ryParams',    'Jetfire', '0/20 * * * * ?', '0', '1', 'admin', '2018-03-16 11-33-00', 'Jetfire', '2018-03-16 11-33-00', '');


-- ----------------------------
-- 16、定时任务调度日志表
-- ----------------------------
drop table if exists sys_job_log;
create table sys_job_log (
  job_log_id          int(11) 	    not null auto_increment    comment '任务日志ID',
  job_name            varchar(64)   not null                   comment '任务名称',
  job_group           varchar(64)   not null                   comment '任务组名',
  method_name         varchar(500)                             comment '任务方法',
  method_params       varchar(200)  default ''                 comment '方法参数',
  job_message         varchar(500)                             comment '日志信息',
  status              char(1)       default '0'                comment '执行状态（0正常 1失败）',
  exception_info      text                                     comment '异常信息',
  create_time         datetime                                 comment '创建时间',
  primary key (job_log_id)
) engine=innodb default charset=utf8 comment = '定时任务调度日志表';


-- ----------------------------
-- 17、通知公告表
-- ----------------------------
drop table if exists sys_notice;
create table sys_notice (
  notice_id 		int(4) 		    not null auto_increment    comment '公告ID',
  notice_title 		varchar(50) 	not null 				   comment '公告标题',
  notice_type 		char(2) 	    not null 			       comment '公告类型（1通知 2公告）',
  notice_content    varchar(500)    not null                   comment '公告内容',
  status 			char(1) 		default '0' 			   comment '公告状态（0正常 1关闭）',
  create_by         varchar(64)     default ''                 comment '创建者',
  create_time 		datetime                                   comment '创建时间',
  update_by 		varchar(64) 	default ''			       comment '更新者',
  update_time 		datetime                                   comment '更新时间',
  remark 			varchar(255) 	default '' 				   comment '备注',
  primary key (notice_id)
) engine=innodb auto_increment=10 default charset=utf8 comment = '通知公告表';


-- ----------------------------
-- 初始化-公告信息表数据
-- ----------------------------
insert into sys_notice values('1', '温馨提醒：2018-07-01 Jetfire新版本发布啦', '2', '新版本内容', '0', 'admin', '2018-03-16 11-33-00', 'Jetfire', '2018-03-16 11-33-00', '管理员');
insert into sys_notice values('2', '维护通知：2018-07-01 Jetfire系统凌晨维护', '1', '维护内容',   '0', 'admin', '2018-03-16 11-33-00', 'Jetfire', '2018-03-16 11-33-00', '管理员');