package com.itwillbs.controller;

import java.net.URLEncoder;
import java.security.SecureRandom;
import java.util.Base64;

import javax.inject.Inject;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.itwillbs.domain.MemberVO;
import com.itwillbs.domain.RequestTokenVO;
import com.itwillbs.domain.ResponseTokenVO;
import com.itwillbs.service.FintechService;
import com.itwillbs.service.MemberService;

@Controller
@RequestMapping("/fintech/*")
public class FintechController {
		
	private static final Logger log 
		= LoggerFactory.getLogger(FintechController.class);
	
	@Inject private FintechService fService; 
	@Inject private MemberService mService;
	
	private final String clientId = "b41453f5-4099-4020-a1b3-8200b48abf95";
    private final String clientSecret = "60c7ad2e-5722-49bb-a5da-08f43a2af68e";
    
    /** 랜덤 state 생성 */
    private String generateState() {
        SecureRandom random = new SecureRandom();
        byte[] bytes = new byte[24];
        random.nextBytes(bytes);
        return Base64.getUrlEncoder().withoutPadding().encodeToString(bytes);
    }
	
	// 포인트 충전 화면
	@GetMapping("/chargePoint")
    public String chargePointGET() {
        return "/fintech/chargePoint";
    }
	
	// 금액 선택 -> 인증화면으로 이동
    @PostMapping("/chargeRequest")
    public String chargeRequestPOST(@RequestParam("amount") int amount,
                                    HttpSession session) throws Exception {

        log.info("chargeRequestPOST 실행, 금액: {}", amount);

        // 금액 세션 저장
        session.setAttribute("chargeAmount", amount);

        // 랜덤 state 생성 후 세션에 저장
        String state = generateState();
        session.setAttribute("fintech_state", state);

        // redirect_uri 설정
        String redirectUri = "http://localhost:8088/fintech/callback";

        // 인증 URL 생성
        String url =
                "https://testapi.openbanking.or.kr/oauth/2.0/authorize?"
                + "response_type=code"
                + "&client_id=" + URLEncoder.encode(clientId, "UTF-8")
                + "&redirect_uri=" + URLEncoder.encode(redirectUri, "UTF-8")
                + "&scope=login inquiry transfer"
                + "&state=" + URLEncoder.encode(state, "UTF-8");

        log.info("생성된 인증 URL: {}", url);
        return "redirect:" + url;
    }
    
	// 인증 후 돌아오는 callback
    @GetMapping("/callback")
    public String callbackGET(@RequestParam("code") String code,
				              @RequestParam("state") String state,
				              HttpSession session,
				              Model model) throws Exception {

    	log.info("callback 수신: code={}, state={}", code, state);

        // state 검증
        String savedState = (String) session.getAttribute("fintech_state");
        if (savedState == null || !savedState.equals(state)) {
        	log.error("State 불일치 – 보안 위험");
            model.addAttribute("msg", "비정상적인 접근입니다.");
            return "/fintech/error";
        }

        // 토큰 요청 VO 구성
        RequestTokenVO vo = new RequestTokenVO();
        vo.setCode(code);
        vo.setClient_id(clientId);
        vo.setClient_secret(clientSecret);
        vo.setRedirect_uri("http://localhost:8088/fintech/callback");
        vo.setGrant_type("authorization_code");

        // 토큰 요청
        ResponseTokenVO token = fService.requestToken(vo);

        log.info("토큰 발급 완료: {}", token.getAccess_token());

        // 금액 가져오기
        Integer amount = (Integer) session.getAttribute("chargeAmount");
        if (amount == null) {
            model.addAttribute("msg", "충전 금액 정보가 없습니다.");
            return "/fintech/error";
        }
        
        // 현재 로그인 회원 ID 전달 (DB 업데이트 위해 필요)
        MemberVO loginInfo = (MemberVO) session.getAttribute("loginInfo");
        if (loginInfo == null) {
            log.error("[Fintech] loginInfo 없음 → 재로그인 요구");
            model.addAttribute("msg", "로그인이 필요합니다.");
            return "/member/login";
        }

        token.setMember_id(loginInfo.getMember_id());

        // 포인트 + 마일리지 충전 처리
        fService.processCharge(amount, token);
        
        MemberVO freshInfo = mService.getMemberById(loginInfo.getMember_id());
        session.setAttribute("loginInfo", freshInfo);
        log.info("충전 후 최신 회원정보 세션 갱신 완료");

        session.removeAttribute("chargeAmount");
        session.removeAttribute("fintech_state");

        // 6) 홈으로 이동 + 메시지
        model.addAttribute("msg", amount + " 포인트가 충전되었습니다.");
        return "/fintech/callback";
    }

}
