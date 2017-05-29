package sas;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.config.annotation.web.servlet.configuration.EnableWebMvcSecurity;

@Configuration
@EnableWebMvcSecurity
public class WebSecurityConfig extends WebSecurityConfigurerAdapter {

	@Autowired
	DataSource dataSource;

	@Autowired
	public void configAuthentication(AuthenticationManagerBuilder auth) throws Exception {

	  auth.jdbcAuthentication().dataSource(dataSource)
		.usersByUsernameQuery(
			"select user_name,password_hash,1 from users where user_name=?")
		.authoritiesByUsernameQuery(
			"select u.user_name, r.role_name from users u join user_roles ur on (ur.user_id=u.id) join roles r on (r.id=ur.role_id) where u.user_name=?");
	}

	@Override
	protected void configure(HttpSecurity http) throws Exception {

	  http.authorizeRequests()
		.antMatchers("/hello").access("hasRole('ROLE_ADMIN')")
		.antMatchers("/admin").access("hasRole('ROLE_ADMIN')")
		.antMatchers("/normal-user").access("hasAnyRole('ROLE_USER','ROLE_ADMIN')")
		//.anyRequest().permitAll()
		.and()
		  .formLogin().loginPage("/login")
		  .usernameParameter("username").passwordParameter("password")
		.and()
		  .logout().logoutSuccessUrl("/login?logout")
		 .and()
		 .exceptionHandling().accessDeniedPage("/403")
		.and()
		  .csrf().disable();
	}

}
