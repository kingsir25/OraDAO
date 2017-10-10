package com.db.oradao;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.boot.web.support.SpringBootServletInitializer;
//import org.springframework.transaction.annotation.EnableTransactionManagement;

@SpringBootApplication
//0926 加入
//@EnableTransactionManagement
/**
 * 修改启动类，继承 SpringBootServletInitializer 并重写 configure 方法
 */
public class OraDaoApplication extends SpringBootServletInitializer {

	public static void main(String[] args) {
		SpringApplication.run(OraDaoApplication.class, args);
	}

    @Override
    protected SpringApplicationBuilder configure(SpringApplicationBuilder builder) {
        // 注意这里要指向原先用main方法执行的Application启动类
        return builder.sources(OraDaoApplication.class);
    }
}