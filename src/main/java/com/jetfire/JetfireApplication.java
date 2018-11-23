package com.jetfire;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.transaction.annotation.EnableTransactionManagement;

/**
 * 启动程序
 * 
 * @author jetfire
 */
@SpringBootApplication
@EnableTransactionManagement
@MapperScan("com.jetfire.project.*.*.mapper")
public class JetfireApplication
{
    public static void main(String[] args)
    {
        // System.setProperty("spring.devtools.restart.enabled", "false");
        SpringApplication.run(JetfireApplication.class, args);
        System.out.println("(♥◠‿◠)ﾉﾞ  Jetfire启动成功   ლ(´ڡ`ლ)ﾞ ");
            
    }
}
