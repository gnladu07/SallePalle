package com.itwillbs.security;

import java.io.IOException;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.List;
import java.util.function.Consumer;
import java.util.stream.Collectors;

import javax.inject.Inject;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;

import com.itwillbs.domain.MemberVO;
import com.itwillbs.service.MemberService;

/**
 * 로그인 성공 시 실행되는 핸들러
 * 
 * 1) authentication.getPrincipal() 에 저장된 CustomUserDetails 꺼냄
 * 2) CustomUserDetails.getMember() 로 MemberVO 가져옴
 * 3) 세션(loginInfo)에 MemberVO 저장
 * 4) 권한(role) 체크 후 페이지 이동
 */
public class CustomLoginSuccessHandler implements AuthenticationSuccessHandler{
	
	private static final Logger logger 
		= LoggerFactory.getLogger(CustomLoginSuccessHandler.class);
	
	@Inject private MemberService mService;
	
	@Override
	public void onAuthenticationSuccess(HttpServletRequest request, 
										HttpServletResponse response,
										Authentication authentication) throws IOException, ServletException {
		logger.info(" onAuthenticationSuccess() 실행! ");
		logger.info(" 사용자 로그인 성공시 실행! ");
		
		// 로그인 사용자 아이디 가져오기
		CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
		int memberId = userDetails.getMember().getMember_id();
		
		// VO 객체 생성 후 DB에서 정보 가져오기
		MemberVO loginInfo = mService.getMemberById(memberId);
		logger.info(" CustomLoginSuccessHandler: "+loginInfo);
		
		// 세션 저장 -> 모든 JSP, 컨트롤러에서 사용 가능
		request.getSession().setAttribute("loginInfo", loginInfo);
		
        //로그인 성공 메시지 만들기
		String username = loginInfo.getUsername();  
		String welcomeMsg = URLEncoder.encode(username + "님 환영합니다!", "UTF-8");
		
		logger.info(" 회원 정보 확인: {} ", loginInfo);
		
		// 권한 리스트 조회
		List<String> roleNames = authentication.getAuthorities()
											   .stream()
											   .map(GrantedAuthority::getAuthority)
										       .collect(Collectors.toList());
		logger.info(" roleNames: {} ", roleNames);
		
		// 권한에 따른 사용자 페이지 접근 제어
		if(roleNames.contains("ROLE_ADMIN")) {
			logger.info(" 관리자 권한을 포함한 사용자가 로그인 성공! ");
			
			// 관리자 페이지로 이동
			response.sendRedirect("/admin/home?msg=" + welcomeMsg);
			
			return;
		}
		
		if(roleNames.contains("ROLE_MEMBER")) {
			logger.info(" 멤버 권한을 포함한 사용자가 로그인 성공! ");
			
			// 멤버 페이지로 이동
			response.sendRedirect("/main/home?msg=" + welcomeMsg);
			
			return;
		}
		
		if(loginInfo.getNotify_flag().equals("Y")) {
		    request.getSession().setAttribute("notifyMsg", "관리자 메일이 도착했습니다.");
		    mService.setNotifyFlag(loginInfo.getMember_id(), "N");
		}
		
		// 그 외 권한
		response.sendRedirect("/?msg=" + welcomeMsg);
		
	}

}
