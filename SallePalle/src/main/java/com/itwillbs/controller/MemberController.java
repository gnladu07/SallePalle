package com.itwillbs.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.context.HttpSessionSecurityContextRepository;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.itwillbs.component.NaverLoginComponent;
import com.itwillbs.domain.Criteria;
import com.itwillbs.domain.MemberAuthVO;
import com.itwillbs.domain.MemberVO;
import com.itwillbs.domain.PaymentHistoryVO;
import com.itwillbs.domain.SaleTradeVO;
import com.itwillbs.security.CustomUserDetails;
import com.itwillbs.service.MemberService;
import com.itwillbs.service.SaleTradeService;
import com.itwillbs.service.TopLocationService;

@Controller
@RequestMapping("/member/*")
public class MemberController {
	
	private static final Logger logger 
		= LoggerFactory.getLogger(MemberController.class);
	
	@Inject private MemberService mService;
	@Inject private TopLocationService tLService;
	@Inject private SaleTradeService stService;
	@Inject private NaverLoginComponent nLComponent;
	
	private ObjectMapper objectMapper = new ObjectMapper();
	
	@GetMapping("/joinChoice")
	public String joinChoicGET(Model model) {
		logger.info(" joinChoicGET() 실행! ");
		String naverLoginURL = nLComponent.getAuthorizationUrl();
		model.addAttribute("naverLoginURL", naverLoginURL);
		return "member/joinChoice";
	}
	
	@GetMapping("/join")
	public String joinGET(Model model) {
		logger.info(" joinGET실행! ");
		String naverLoginURL = nLComponent.getAuthorizationUrl();
		model.addAttribute("naverLoginURL", naverLoginURL);
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
	        mService.memberJoin(vo);
	        rttr.addFlashAttribute("joinMsg", "정상적으로 회원가입되었습니다!");
	        return "redirect:/member/login";

	    } catch (DuplicateKeyException e) {
	        rttr.addFlashAttribute("msg", "이미 사용중인 아이디 입니다! 중복확인을 해주세요!");
	        return "redirect:/member/join";
	    }
	}
	
	@GetMapping("/login")
	public void loginGET(Model model) {
		logger.info(" loginGET()실행! ");
		String naverLoginURL = nLComponent.getAuthorizationUrl();
		model.addAttribute("naverLoginURL", naverLoginURL);
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
	
	// 기본 이미지로 초기화
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
	    
	    if(!loginInfo.getEmail().equals(vo.getEmail()) && !emailVerified){
	        rttr.addFlashAttribute("msg", "메일 인증을 진행해주세요!");
	        return "redirect:/member/update";
	    }

	    try {
	    	mService.updateMemberWithHistory(vo);
	    	
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
	
	// 아이디 찾기
	@GetMapping("/findId")
	public void findIdGET() {
		logger.info(" findIdGET()실행! ");
	}
	
	// 아이디 찾기 처리
	@PostMapping("/findId")
    public String findIdPOST(@RequestParam("userpw") String inputPw,
                             RedirectAttributes rttr,
                             Model model) {
		logger.info(" findIdPOST()실행! ");
        String userid = mService.findUseridByPassword(inputPw);

        if(userid == null) {
            model.addAttribute("msg", "입력한 비밀번호로 조회되는 아이디가 없습니다.");
            return "/member/findId";
        }

        rttr.addFlashAttribute("foundId", userid);

        logger.info(" findIdPOST()끝! ");
        return "redirect:/member/login"; 
    }
	
    // 비밀번호 찾기 페이지
    @GetMapping("/findPw")
    public String findPwGET() {
    	logger.info(" findPwGET() 실행! ");
    	return "/member/findPw";
    }
	
	// 링크 발송 요청
	@PostMapping("/findPw")
	public String findPwPOST(@RequestParam("userid") String userid,
	                         @RequestParam("email") String email,
	                         RedirectAttributes rttr,
	                         Model model) {
		logger.info(" findPwPOST()실행! ");
	    boolean result = mService.sendResetLink(userid, email);

	    if(!result) {
	        model.addAttribute("msg", "입력한 정보와 일치하는 회원이 없습니다.");
	        return "/member/findPw";
	    }

	    rttr.addFlashAttribute("pwMsg", "비밀번호 재설정 링크를 이메일로 보냈습니다!");
	    logger.info(" findPwPOST()끝! ");
	    return "redirect:/member/login";
	}
	
	// 링크 클릭 시 비밀번호 재설정 페이지로 이동
    @GetMapping("/resetPw")
    public String resetPwGET(@RequestParam("token") String token,
                             Model model,
                             RedirectAttributes rttr) {

        if(!mService.validateToken(token)) {
            rttr.addFlashAttribute("pwMsg", "유효하지 않거나 만료된 링크입니다.");
            return "redirect:/member/login";
        }

        model.addAttribute("token", token);
        return "/member/resetPw";
    }

    // 비밀번호 실제 변경
    @PostMapping("/resetPw")
    public String resetPwPOST(@RequestParam("token") String token,
                              @RequestParam("newPw") String newPw,
                              RedirectAttributes rttr) {

    	mService.resetPassword(token, newPw);

        rttr.addFlashAttribute("rePwMsg", "비밀번호가 성공적으로 변경되었습니다!");
        return "redirect:/member/login";
    }
    
    // 네아로 콜백
    @GetMapping("/naverCallback")
    public void naverCallback(String code, String state,
    		                  Model model) throws Exception {
    	logger.info(" naverCallback() 실행! ");
    	
    	// 액세스 토큰 가져오기(JSON 형태)
    	String tokenJson  = nLComponent.getAccessToken(code, state);
    	logger.info(" code: "+ code);
    	logger.info(" state: "+ state);
    	
    	// JSON 객체에서 값만 문자열로 꺼내오기
    	 JsonNode tokenNode = objectMapper.readTree(tokenJson);
    	 String accessToken = tokenNode.get("access_token").asText();
    	 
    	 logger.info(" accessToken : " + accessToken);
    	
    	// 유저 프로필 (네이버) 가져오기
    	String profileJson = nLComponent.getProfile(accessToken);
    	
    	JsonNode profileNode = objectMapper.readTree(profileJson);
        String safeProfileJson = profileNode.toString();
    	
    	// 팝업창의 callback.jsp 에게 보내기
    	model.addAttribute("userProfile", safeProfileJson);
    	
    	logger.info(" naverCallback() 끝! ");
    }
    
	@PostMapping("/naverLogin")
	@ResponseBody
	public String naverLogin(String provider_id, HttpSession session) {
		MemberVO member = mService.selectNaverLogin(provider_id);
		
	    if (member == null) {
	        return "{\"success\": false}";
	    }
	    
	    if (member.getDeleted_at() != null) {
	        return "{\"success\": false, \"reason\":\"deleted\"}";
	    }

	    if ("0".equals(member.getEnable_flag())) {
	        return "{\"success\": false, \"reason\":\"disabled\"}";
	    }
	    
	    if (member.getAuthList() == null || member.getAuthList().isEmpty()) {

	        MemberAuthVO defaultAuth = new MemberAuthVO();
	        defaultAuth.setUserid(member.getUserid());
	        defaultAuth.setAuth("ROLE_MEMBER");

	        List<MemberAuthVO> list = new ArrayList<>();
	        list.add(defaultAuth);

	        member.setAuthList(list);
	    }
	    
	    // 강제 로그인 처리
	    CustomUserDetails userDetails = new CustomUserDetails(member);

	    UsernamePasswordAuthenticationToken authToken = 
	    		new UsernamePasswordAuthenticationToken(userDetails, null, userDetails.getAuthorities());
	    
	    SecurityContextHolder.getContext().setAuthentication(authToken);
	    session.setAttribute(HttpSessionSecurityContextRepository.SPRING_SECURITY_CONTEXT_KEY,
	            			 SecurityContextHolder.getContext());
	    
	    session.setAttribute("loginInfo", member);
	    
		return "{\"success\": true}";
	}
	
	@PostMapping("/member/readNotification")
	@ResponseBody
	public Map<String, Object> readNotification(HttpSession session) {
	    Map<String, Object> result = new HashMap<>();
	    try {
	        // 세션에서 사용자 정보 가져오기
	        MemberVO loginInfo = (MemberVO) session.getAttribute("loginInfo"); 
	        if (loginInfo == null) {
	            result.put("success", false);
	            return result;
	        }
	        
	        // notify_flag를 'N'으로 업데이트
	        mService.updateNotifyFlag(loginInfo.getUserid(), "N");
	        
	        // 세션 정보도 업데이트
	        loginInfo.setNotify_flag("N");
	        session.setAttribute("loginInfo", loginInfo);
	        
	        result.put("success", true);
	    } catch (Exception e) {
	        result.put("success", false);
	    }
	    return result;
	}
	
	@GetMapping("/paymentHistory")
	public String paymentGET(HttpSession session, Model model) {

	    MemberVO loginInfo = (MemberVO) session.getAttribute("loginInfo");
	    if (loginInfo == null) {
	        return "redirect:/member/login";
	    }

	    boolean isSeller = "Y".equals(loginInfo.getSeller_status());

	    Map<String, Object> listData =
	            mService.getPaymentHistory(loginInfo.getMember_id(), isSeller);


	    model.addAttribute("walletList", listData.get("walletList"));
	    model.addAttribute("sellList", listData.get("sellList"));

	    return "/member/paymentHistory";
	}
	
	@GetMapping("/traList")
    public String myTradeList(HttpSession session, Model model) {
		logger.info(" myTradeList()실행! ");
        MemberVO loginInfo =
            (MemberVO) session.getAttribute("loginInfo");

        if (loginInfo == null) {
            return "redirect:/member/login";
        }

        List<SaleTradeVO> list =
            stService.getSaleTradeBySeller(loginInfo.getMember_id());

        model.addAttribute("myTradeList", list);

        logger.info(" myTradeList()끝! ");
        return "/member/traList";
    }

    @PostMapping("/deleteTrade")
    @ResponseBody
    public String deleteTrade(@RequestParam int trade_id,
                              HttpSession session) {
    	logger.info(" myTradeList()실행! ");
        MemberVO loginInfo =
            (MemberVO) session.getAttribute("loginInfo");

        if (loginInfo == null) {
            return "NO_LOGIN";
        }

        stService.deleteSaleTrade(trade_id, loginInfo.getMember_id());
        logger.info(" myTradeList()끝! ");
        return "OK";
    }
    
    // 마이페이지 - 최근 본 글 목록
    @GetMapping("/member/recentView")
    public String recentViewList(HttpSession session, Model model) throws Exception {
        MemberVO loginInfo = (MemberVO) session.getAttribute("loginInfo");
        
        // 비로그인 접근 차단
        if (loginInfo == null) {
            return "redirect:/member/login";
        }
        
        List<Map<String, Object>> recentList = stService.getRecentViewList(loginInfo.getMember_id());
        model.addAttribute("recentList", recentList);
        
        return "/member/recentView";
    }

	
}
