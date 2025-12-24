package com.itwillbs.controller;

import javax.inject.Inject;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.itwillbs.domain.MemberVO;
import com.itwillbs.service.ItemCategoryService;
import com.itwillbs.service.MemberService;
import com.itwillbs.service.SaleTradeService;
import com.itwillbs.service.TopLocationService;

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
	@Inject private SaleTradeService stService; 
	@Inject private TopLocationService tlService;
	@Inject private ItemCategoryService icService;
	
	@RequestMapping("/main/home")
	public String homeGET(HttpSession session, 
			              Model model) {

	    MemberVO loginInfo = (MemberVO) session.getAttribute("loginInfo");

	    if (loginInfo != null) {
	        // DB 최신 값으로 갱신
	        MemberVO fresh = memberService.getMemberById(loginInfo.getMember_id());
	        session.setAttribute("loginInfo", fresh);
	    }

	    // 1. 카테고리 리스트
	    model.addAttribute("topLocationList", tlService.getTopLocationList());
	    
	    // 2. 지역 리스트
	    model.addAttribute("itemCategoryList", icService.getItemCategoryList());
	    
	    // 3. 최신 중고 거래 5개
	    model.addAttribute("latestTradeList", stService.getLatestSaleTradeList(5));
	    
	    // 4. 추천순 중고 거래 5개
	    model.addAttribute("recommendTradeList", stService.getRecommendSaleTradeList(5));
	    
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
