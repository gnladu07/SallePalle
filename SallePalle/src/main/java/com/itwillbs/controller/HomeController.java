package com.itwillbs.controller;

import javax.inject.Inject;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.itwillbs.domain.MemberVO;
import com.itwillbs.service.MemberService;

/**
 * Handles requests for the application home page.
 */
@Controller
public class HomeController {
	
	private static final Logger logger = LoggerFactory.getLogger(HomeController.class);
	// http://localhost:8088/controller/
	/**
	 * Simply selects the home view to render by returning its name.
	 */
	
	@Inject private MemberService memberService; 
	
	@RequestMapping("/main/home")
	public String homeGET(HttpSession session) {

	    MemberVO loginInfo = (MemberVO) session.getAttribute("loginInfo");

	    if (loginInfo != null) {
	        // DB 최신 값으로 갱신
	        MemberVO fresh = memberService.getMemberById(loginInfo.getMember_id());
	        session.setAttribute("loginInfo", fresh);
	    }

	    return "/main/home";
	}
	@GetMapping("/include/header")
	public void headerGET() {
		logger.info(" headerGET() 실행! ");
	}
	@GetMapping("/include/footer")
	public void footerGET() {
		logger.info(" footerGET() 실행! ");
	}
	
}
