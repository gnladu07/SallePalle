package com.itwillbs.security;

import java.io.IOException;
import java.net.URLEncoder;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.DisabledException;
import org.springframework.security.authentication.LockedException;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.web.authentication.AuthenticationFailureHandler;

public class CustomLoginFailureHandler implements AuthenticationFailureHandler {
	
	private static final Logger logger 
		= LoggerFactory.getLogger(CustomLoginFailureHandler.class);

	@Override
	public void onAuthenticationFailure(HttpServletRequest request, 
										HttpServletResponse response,
										AuthenticationException exception) throws IOException, ServletException {
		logger.info(" onAuthenticationFailure() 실행! ");
		
		String msg = "로그인에 실패했습니다.";

		// 탈퇴한 계정
	    if (exception.getCause() instanceof DisabledException) {
	        msg = "탈퇴한 계정입니다. 신규 회원가입 후 이용해주세요.";
	    }
	    // 정지된 계정
	    else if (exception.getCause() instanceof LockedException) {
	        msg = "이용사항 위반으로 일시정지 상태입니다. 고객센터에 문의하세요.";
	    }
	    // 아이디 없음
	    else if (exception instanceof UsernameNotFoundException) {
	        msg = "입력하신 사용자 정보가 없습니다! 재확인 부탁드립니다.";
	    }
	    // 비밀번호 불일치
	    else if (exception instanceof BadCredentialsException) {
	        msg = "아이디 또는 비밀번호가 일치하지 않습니다.";
	    }

	    response.sendRedirect("/member/login?errorMsg=" + URLEncoder.encode(msg, "UTF-8"));
	}

}
