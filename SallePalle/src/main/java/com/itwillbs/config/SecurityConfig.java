package com.itwillbs.config;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

import com.itwillbs.security.CustomAccessDeniedHandler;
import com.itwillbs.security.CustomLoginFailureHandler;
import com.itwillbs.security.CustomLoginSuccessHandler;
import com.itwillbs.security.CustomLogoutSuccessHandler;
import com.itwillbs.security.CustomUserDetailsService;

@Configuration
@EnableWebSecurity
public class SecurityConfig extends WebSecurityConfigurerAdapter {
	
	private static final Logger logger 
		= LoggerFactory.getLogger(SecurityConfig.class);

	// 비밀번호 암호화 핸들러 등록
	@Bean
	public BCryptPasswordEncoder passwordEncoder() {
		logger.info(" 비밀번호 암호화 핸들러 실행! ");
		return new BCryptPasswordEncoder();
	}
	
	// CustomUserDetailsService 등록
	@Bean
	public CustomUserDetailsService customUserDetailsService() {
		logger.info(" customUserDetailsService메서드 실행! ");
		return new CustomUserDetailsService();
	}
	
	// 로그인 성공 핸들러 등록
	@Bean
	public CustomLoginSuccessHandler customLoginSuccessHandler() {
		logger.info(" 로그인 성공 핸들러 실행! ");
		return new CustomLoginSuccessHandler();
	}
	
	// 로그인 실패 핸들러 등록
	@Bean
	public CustomLoginFailureHandler customLoginFailureHandler() {
		logger.info(" 로그인 실패 핸들러 실행! ");
		return new CustomLoginFailureHandler();
	}
	
	// 로그아웃 핸들러 등록
	@Bean
	public CustomLogoutSuccessHandler customLogoutSuccessHandler() {
		logger.info(" 로그아웃 핸들러 실행! ");
		return new CustomLogoutSuccessHandler();
	}
	
	// 미 권한 유저 제어 핸들어 등록
	@Bean
	public CustomAccessDeniedHandler accessDeniedHandler() {
		logger.info(" 미 권한 유저 제어 핸들어 실행! ");
		return new CustomAccessDeniedHandler();
	}
	
	// AuthenticationManager 설정 (로그인 인증 핵심 로직)
	@Override
	protected void configure(AuthenticationManagerBuilder auth) throws Exception {
		auth.userDetailsService(customUserDetailsService())
			.passwordEncoder(passwordEncoder());
	}
	
	// HTTP 요청에 대한 Security 설정
	@Override
	protected void configure(HttpSecurity http) throws Exception {
		
		http.csrf().disable(); // ← 현재 CSRF 전체 끄는 설정 (AJAX 때문에 OK)
		http.authorizeRequests()
			// 공용 URL
			.antMatchers("/main/header", "/member/emailCode", "/member/checkUserid", "/member/findId").permitAll()
			.antMatchers("/member/login", "/member/login", "/member/join", "/member/joinChoice", "/member/findPw", "/member/resetPw").permitAll()
			.antMatchers("/member/naverCallback", "/member/naverLogin").permitAll()
			.antMatchers("/resources/**").permitAll()
			
			// ADMIN 권한
			.antMatchers("/admin/**", "/security/**").hasRole("ADMIN")
			
			// MEMBER 권한
			.antMatchers("/member/**").hasRole("MEMBER")
			.anyRequest().authenticated()
			.and()
			
			// 로그인 설정
			.formLogin()
				.loginPage("/member/login")
				.loginProcessingUrl("/member/loginProcess")
				.usernameParameter("userid")
				.passwordParameter("userpw")
				.successHandler(customLoginSuccessHandler())
				.failureHandler(customLoginFailureHandler())
				.permitAll()
			.and()
			
			// 로그아웃 설정
			.logout()
				.logoutUrl("/member/logout")
				.invalidateHttpSession(true)
				.deleteCookies("JSESSIONID")
				.logoutSuccessHandler(customLogoutSuccessHandler())
			.and()
			
			// 403 제어
			.exceptionHandling()
			.accessDeniedHandler(accessDeniedHandler());
	}
	
	// AuthenticationManager Bean 객체 등록
	@Bean
	@Override
	public AuthenticationManager authenticationManagerBean() throws Exception {
	    return super.authenticationManagerBean();
	}
	
}
