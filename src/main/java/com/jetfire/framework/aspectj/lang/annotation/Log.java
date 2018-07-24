package com.jetfire.framework.aspectj.lang.annotation;

import java.lang.annotation.Documented;
import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;
import com.jetfire.framework.aspectj.lang.constant.OperatorType;

/**
 * 自定义操作日志记录注解
 * 
 * @author jetfire
 *
 */
@Target({ ElementType.PARAMETER, ElementType.METHOD })
@Retention(RetentionPolicy.RUNTIME)
@Documented
public @interface Log
{
    /** 模块 */
    String title() default "";

    /** 功能 */
    String action() default "";

    /** 渠道 */
    String channel() default OperatorType.MANAGE;

    /** 是否保存请求的参数 */
    boolean isSaveRequestData() default true;

}
