package com.itwillbs.controller;

import javax.inject.Inject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.itwillbs.component.FileComponent;
import com.itwillbs.domain.MemberVO;
import com.itwillbs.service.MemberService;
import com.itwillbs.service.TopLocationService;

@Controller
@RequestMapping("/member/*")
public class MemberController {
	
	private static final Logger logger 
		= LoggerFactory.getLogger(MemberController.class);
	
	@Inject private MemberService mService;
	@Inject private TopLocationService tLService;
	
	@GetMapping("/join")
	public String joinGET(Model model) {
		logger.info(" joinGET실행! ");
		model.addAttribute("topList", tLService.getTopLocationList());
		return "member/join";
	}
	
	@PostMapping("/emailCode")
	@ResponseBody
	public int emailCodePOST(@RequestParam("email") String email) {
		return mService.emailSendCode(email);
	}
	
	@PostMapping("/join")
	public String joinPOST(MemberVO vo) {
		mService.memberJoin(vo);
		return "redirect:/member/login";
	}
	
	
	
	

	
}
