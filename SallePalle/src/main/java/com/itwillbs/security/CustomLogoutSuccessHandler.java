package com.itwillbs.security;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.logout.LogoutSuccessHandler;

public class CustomLogoutSuccessHandler implements LogoutSuccessHandler {

	@Override
	public void onLogoutSuccess(HttpServletRequest request, 
			                    HttpServletResponse response, 
			                    Authentication authentication)
			throws IOException, ServletException {
		// 어떤 상황에서든 로그아웃 요청이 오면 여기로 오게 됨
        response.sendRedirect("/main/header");  // 원하는 페이지로 강제 이동
		
	}

}
