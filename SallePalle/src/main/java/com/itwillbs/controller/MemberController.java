package com.itwillbs.controller;

import javax.inject.Inject;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

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
	@Inject private FileComponent fileComponent;
	
	@GetMapping("/join")
	public String joinGET(Model model) {
		logger.info(" joinGET실행! ");
		model.addAttribute("topList", tLService.getTopLocationList());
		return "member/join";
	}
	
	// 아이디 중복 체크
	@PostMapping("/checkUserid")
	@ResponseBody
	public String checkUseridPOST(@RequestParam("userid") String userid) {
		logger.info(" checkUseridPOST()실행! ");
		userid = userid.trim();
		
	    boolean exists = mService.isUseridExists(userid);
	    return exists ? "exists" : "ok";
	}
	
	@PostMapping("/emailCode")
	@ResponseBody
	public int emailCodePOST(@RequestParam("email") String email) {
		return mService.emailSendCode(email);
	}
	
	@PostMapping("/join")
	public String joinPOST(MemberVO vo,
			               RedirectAttributes rttr) {
	    try {
	        mService.memberJoin(vo); // 중복 이메일일 경우 여기서 DuplicateKeyException 발생
	        return "redirect:/member/login";

	    } catch (DuplicateKeyException e) {
	        rttr.addFlashAttribute("msg", "이미 사용중인 이메일입니다!");
	        return "redirect:/member/join";
	    }
	}
	
	@GetMapping("/login")
	public void loginGET() {
		logger.info(" loginGET()실행! ");
	}
	
	// 개인정보 상세보기
	@GetMapping("/read")
	public void readGET() {
		logger.info(" readGET() 실행! ");
	}
	
	// 프로필 이미지 수정
	@GetMapping("/profileEdit")
	public void profileEditGET(Model model,
			                   HttpSession session) {
		logger.info(" profileEditGET() 실행! ");
		
		model.addAttribute("loginInfo", session.getAttribute("loginInfo"));
	}
	
	@PostMapping("/profileEdit")
	public String profileEditPOST(@RequestParam("uploadFile") MultipartFile file,
			                      HttpSession session,
			                      RedirectAttributes rttr,
			                      MemberVO vo) throws Exception {
		logger.info(" profileEditPOST() 실행! ");
		
		// 로그인 정보 가져오기
		MemberVO loginInfo = (MemberVO) session.getAttribute("loginInfo");
		String userid = loginInfo.getUserid();
		
		// DB 업데이트
		mService.changeProfileImage(userid, file);
		
		// 세션 최신화
		session.setAttribute("loginInfo", mService.selectOne(userid));
		rttr.addFlashAttribute("imageMsg", "프로필 이미지가 변경되었습니다.");
		
		return "redirect:/member/read";
	}
	
	// 기본 이미지로 초기화 (AJAX)
	@PostMapping("/profileReset")
	@ResponseBody
	public String profileResetPOST(HttpSession session) {

	    logger.info(" profileResetPOST() 실행! ");

	    MemberVO loginInfo = (MemberVO) session.getAttribute("loginInfo");
	    String userid = loginInfo.getUserid();

	    mService.resetProfileImage(userid);

	    // 세션 최신화
	    session.setAttribute("loginInfo", mService.selectOne(userid));

	    return "success";
	}
	
	// 개인정보 수정
	@GetMapping("/update")
	public void updateGET(HttpSession session, Model model) {
		logger.info(" updateGET() 실행! ");
		
		MemberVO loginInfo = (MemberVO) session.getAttribute("loginInfo");
		
	    model.addAttribute("loginInfo", loginInfo);
	    model.addAttribute("topList", tLService.getTopLocationList());
	}
	
	@PostMapping("/update")
	public String updatePOST(MemberVO vo,
							 @RequestParam("emailVerified") boolean emailVerified,
	                         HttpSession session,
	                         RedirectAttributes rttr) {

	    MemberVO loginInfo = (MemberVO) session.getAttribute("loginInfo");
	    vo.setUserid(loginInfo.getUserid());
	    
	    // 이메일 변경했는데 인증 안했으면 → DB update 금지
	    if(!loginInfo.getEmail().equals(vo.getEmail()) && !emailVerified){
	        rttr.addFlashAttribute("msg", "메일 인증을 진행해주세요!");
	        return "redirect:/member/update";
	    }

	    try {
	    	// 서비스 호출 (정보 변경 + 히스토리 기록)
	    	mService.updateMemberWithHistory(vo);
	    	
	    	// 세션 최신화
	    	session.setAttribute("loginInfo", mService.selectOne(vo.getUserid()));
	    	rttr.addFlashAttribute("msg", "회원 정보가 수정되었습니다.");
	    	
	    	return "redirect:/member/read";
		} catch (DuplicateKeyException e) {
			rttr.addFlashAttribute("mailMsg", "이미 사용중인 이메일입니다!");
	        return "redirect:/member/update";
		}
	}
	
	@PostMapping("/update/reset")
	@ResponseBody
	public String updateResetPOST(HttpSession session) {

	    MemberVO loginInfo = (MemberVO) session.getAttribute("loginInfo");

	    mService.rollbackMemberInfo(loginInfo.getUserid());

	    // 세션 최신화
	    session.setAttribute("loginInfo", mService.selectOne(loginInfo.getUserid()));

	    return "success";
	}
	
	// 회원탈퇴 - 비밀번호 검증
	@PostMapping("/checkPw")
	@ResponseBody
	public String checkPwPOST(@RequestParam("userpw") String userpw,
	                          HttpSession session) {

	    MemberVO loginInfo = (MemberVO) session.getAttribute("loginInfo");
	    String userid = loginInfo.getUserid();

	    boolean match = mService.checkPassword(userid, userpw);

	    return match ? "ok" : "fail";
	}

	// 회원탈퇴
	@PostMapping("/delete")
	@ResponseBody
	public String deletePOST(HttpSession session) {

	    MemberVO loginInfo = (MemberVO) session.getAttribute("loginInfo");
	    String userid = loginInfo.getUserid();

	    mService.deactivateMember(userid);

	    session.invalidate();

	    return "success";
	}
	
}
