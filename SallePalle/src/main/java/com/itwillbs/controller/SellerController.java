package com.itwillbs.controller;

import javax.inject.Inject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.itwillbs.domain.MemberVO;
import com.itwillbs.service.MemberService;
import com.itwillbs.service.SellerService;

@Controller
@RequestMapping("/seller")
public class SellerController {
		
	private static final Logger log 
		= LoggerFactory.getLogger(SellerController.class);
	
	@Inject private MemberService mService;
	@Inject private SellerService sService;
	
	@PostMapping("/request")
	public String requestSellerAuthority(Authentication auth, RedirectAttributes rttr) {
		log.info(" requestSellerAuthority() 실행! ");
		
	    if(auth == null) {
	        rttr.addFlashAttribute("msg", "로그인 후 이용 가능합니다.");
	        return "redirect:/member/login";
	    }

	    String userid = auth.getName();

	    MemberVO member = mService.selectOne(userid);
	    

	    if(member == null) {
	        rttr.addFlashAttribute("msg", "회원 정보를 찾을 수 없습니다.");
	        return "redirect:/member/login";
	    }

	    if(member.getMember_id() == 0) {
	        rttr.addFlashAttribute("msg", "회원 데이터 오류 발생(회원 ID=0).");
	        return "redirect:/main/home";
	    }
	    
	    log.info("seller_status 원본값 = [" + member.getSeller_status() + "]");
	    log.info("문자열 길이 = " + member.getSeller_status().length());

	    if("N".equals(member.getSeller_status())) {

	        sService.createRequest(member.getMember_id());

	        mService.updateSellerStatus(member.getMember_id(), "W");

	        rttr.addFlashAttribute("msg", "판매 권한 신청이 정상적으로 접수되었습니다.");
	    }
	   
	    log.info(" requestSellerAuthority() 끝! ");
        return "redirect:/main/home";
	}


}
