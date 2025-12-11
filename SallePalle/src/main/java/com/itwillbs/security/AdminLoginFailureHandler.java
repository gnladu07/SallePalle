package com.itwillbs.security;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.authentication.AuthenticationFailureHandler;

public class AdminLoginFailureHandler implements AuthenticationFailureHandler {
	
	private static final Logger log 
		= LoggerFactory.getLogger(AdminLoginFailureHandler.class);

	@Override
	public void onAuthenticationFailure(HttpServletRequest request, 
			                            HttpServletResponse response,
			                            AuthenticationException exception) throws IOException, ServletException {
		log.info(" onAuthenticationFailure() 실행! ");
		
		response.sendRedirect("/admin/login?error=fail");
		
	}

}
