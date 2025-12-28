package com.itwillbs.controller;

import java.net.URLEncoder;
import java.security.SecureRandom;
import java.util.Base64;
import java.util.UUID;

import javax.inject.Inject;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.itwillbs.domain.MemberVO;
import com.itwillbs.domain.MileageWalletVO;
import com.itwillbs.domain.PayWalletVO;
import com.itwillbs.domain.RequestTokenVO;
import com.itwillbs.domain.ResponseTokenVO;
import com.itwillbs.persistence.MileageWalletDAO;
import com.itwillbs.persistence.PayWalletDAO;
import com.itwillbs.service.FintechService;
import com.itwillbs.service.MemberService;
import com.itwillbs.service.OpenBankingService;

@Controller
@RequestMapping("/fintech/*")
public class FintechController {
		
	private static final Logger log 
		= LoggerFactory.getLogger(FintechController.class);
	
	@Value("${client_id}")
    private String clientId;

    @Value("${client_secret}")
    private String clientSecret;
	
	@Inject private PayWalletDAO payWalletDAO;
	@Inject private MileageWalletDAO mileageWalletDAO;
	
	@Inject private OpenBankingService bankingService;
	@Inject private FintechService fService; 
	@Inject private MemberService mService;
	
//	private final String clientId = "b41453f5-4099-4020-a1b3-8200b48abf95";
//	private final String clientSecret = "60c7ad2e-5722-49bb-a5da-08f43a2af68e";
    
    @GetMapping("/chargePoint")
    public String chargePointGET() {
        return "/fintech/chargePoint";
    }

    @PostMapping("/chargeRequest")
    public String chargeRequestPOST(@RequestParam("amount") int amount,
                                    HttpSession session) throws Exception {
        log.info("충전 요청 금액: {}", amount);
       
    	log.info(" clientId: {}",clientId);

        log.info(" clientSecret: {}", clientSecret);
        
        
        // 이미 인증된 사용자 확인 로직 
        MemberVO loginInfo = (MemberVO) session.getAttribute("loginInfo");

        if (loginInfo.getOb_access_token() != null &&
            loginInfo.getOb_refresh_token() != null &&
            loginInfo.getOb_user_seq_no() != null) {

            log.info("이미 오픈뱅킹 인증된 회원 → 인증 절차 생략 후 충전 처리 진행");

	        // 충전 금액 세션에 저장
	        session.setAttribute("chargeAmount", amount);
	        
	        // 바로 충전 처리
	        fService.processCharge(loginInfo.getMember_id(), amount);
	
	        // 세션 최신화
	        MemberVO freshMember = mService.getMemberById(loginInfo.getMember_id());
	        
	        PayWalletVO pay = payWalletDAO.getWallet(loginInfo.getMember_id());
	        MileageWalletVO mileage = mileageWalletDAO.getWallet(loginInfo.getMember_id());
	        
	        freshMember.setWallet_balance(pay.getBalance());
	        freshMember.setWallet_mileage(mileage.getMileage());
	        
	        // 세션 갱신
	        session.setAttribute("loginInfo", freshMember);
	
	        // 완료 페이지로 이동
	        session.setAttribute("msg", "포인트 충전이 완료되었습니다.");
	        return "/fintech/callback";
	    }
        
        // 최초 인증 사용자
        session.setAttribute("chargeAmount", amount);

        String state = UUID.randomUUID().toString().replace("-", "");
        session.setAttribute("fintech_state", state);

        String redirectUri = "http://c6d2507t3p2.itwillbs.com/fintech/callback";

        String authUrl =
                "https://testapi.openbanking.or.kr/oauth/2.0/authorize"
                        + "?response_type=code"
                        + "&client_id=" + URLEncoder.encode(clientId, "UTF-8")
                        + "&redirect_uri=" + URLEncoder.encode(redirectUri, "UTF-8")
                        + "&scope=login inquiry transfer"
                        + "&state=" + URLEncoder.encode(state, "UTF-8");

        log.info("오픈뱅킹 인증 요청 URL: {}", authUrl);

        return "redirect:" + authUrl;
    }

    @GetMapping("/callback")
    public String callbackGET(@RequestParam("code") String code,
            				  @RequestParam("state") String state,
				              HttpSession session,
				              Model model) throws Exception {
    	
        log.info("오픈뱅킹 callback 도착 code={}, state={}", code, state);

        String savedState = (String) session.getAttribute("fintech_state");
        if (savedState == null || !savedState.equals(state)) {
            model.addAttribute("msg", "비정상적인 접근입니다.");
            return "/error";
        }

        RequestTokenVO tokenVO = new RequestTokenVO();
        tokenVO.setCode(code);
        tokenVO.setClient_id(clientId);
        tokenVO.setClient_secret(clientSecret);
        tokenVO.setRedirect_uri("http://c6d2507t3p2.itwillbs.com/fintech/callback");
        tokenVO.setGrant_type("authorization_code");

        ResponseTokenVO tokenResponse = bankingService.requestToken(tokenVO);
        log.info("Access Token 발급 완료: {}", tokenResponse);

        // 로그인 회원 정보
        MemberVO loginInfo = (MemberVO) session.getAttribute("loginInfo");
        tokenResponse.setMember_id(loginInfo.getMember_id());
        
        // 최초 인증 토큰
        loginInfo.setOb_access_token(tokenResponse.getAccess_token());
        loginInfo.setOb_refresh_token(tokenResponse.getRefresh_token());
        loginInfo.setOb_user_seq_no(tokenResponse.getUser_seq_no());
        
        mService.updateOpenBankingToken(loginInfo);
        
        Integer amount = (Integer) session.getAttribute("chargeAmount");
        fService.processCharge(loginInfo.getMember_id(), amount);
        
        MemberVO freshMember = mService.getMemberById(loginInfo.getMember_id());
        
        PayWalletVO pay = payWalletDAO.getWallet(loginInfo.getMember_id());
        MileageWalletVO mileage = mileageWalletDAO.getWallet(loginInfo.getMember_id());

        freshMember.setWallet_balance(pay.getBalance());
        freshMember.setWallet_mileage(mileage.getMileage());
        
        session.setAttribute("loginInfo", freshMember);

        session.removeAttribute("chargeAmount");
        session.removeAttribute("fintech_state");

        model.addAttribute("msg", "포인트 충전이 완료되었습니다.");
        return "/fintech/callback";
    }
}
