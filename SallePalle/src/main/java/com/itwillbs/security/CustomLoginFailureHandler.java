package com.itwillbs.security;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.authentication.AuthenticationFailureHandler;

public class CustomLoginFailureHandler implements AuthenticationFailureHandler {
	
	private static final Logger logger 
		= LoggerFactory.getLogger(CustomLoginFailureHandler.class);

	@Override
	public void onAuthenticationFailure(HttpServletRequest request, 
										HttpServletResponse response,
										AuthenticationException exception) throws IOException, ServletException {
		logger.info(" onAuthenticationFailure() 실행! ");
		// 실패 메시지 전달 
		response.sendRedirect("/member/login?error=fail");
	}

}
