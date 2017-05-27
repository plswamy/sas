package sas;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.jdbc.datasource.DriverManagerDataSource;
import org.springframework.web.servlet.config.annotation.ViewControllerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurerAdapter;
import org.springframework.web.servlet.view.InternalResourceViewResolver;

@Configuration
public class MvcConfig extends WebMvcConfigurerAdapter {

    @Override
    public void addViewControllers(ViewControllerRegistry registry) {
        registry.addViewController("/home").setViewName("index");
        registry.addViewController("/").setViewName("index");
        registry.addViewController("/survey").setViewName("survey");
        registry.addViewController("/report").setViewName("report");
        //registry.addViewController("/").setViewName("login");
        registry.addViewController("/403").setViewName("403");
    }

    @Bean(name = "dataSource")
  	public DriverManagerDataSource dataSource() {
  	    DriverManagerDataSource driverManagerDataSource = new DriverManagerDataSource();
  	    driverManagerDataSource.setDriverClassName("com.mysql.jdbc.Driver");
  	    driverManagerDataSource.setUrl("jdbc:mysql://localhost:3306/mysql");
  	    driverManagerDataSource.setUsername("root");
  	    driverManagerDataSource.setPassword("root");
  	    return driverManagerDataSource;
  	}

    @Bean
  	public InternalResourceViewResolver viewResolver() {
  		InternalResourceViewResolver resolver = new InternalResourceViewResolver();
  		resolver.setPrefix("/WEB-INF/jsp/");
  		resolver.setSuffix(".jsp");
  		return resolver;
  	}





}
