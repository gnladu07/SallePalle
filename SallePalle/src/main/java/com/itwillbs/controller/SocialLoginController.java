package com.itwillbs.controller;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.itwillbs.component.NaverLoginComponent;
import com.itwillbs.domain.MemberVO;
import com.itwillbs.service.SocialLoginService;

@Controller
@RequestMapping("/social")
public class SocialLoginController {
	
	private static final Logger logger = LoggerFactory.getLogger(SocialLoginController.class);

	@Inject private NaverLoginComponent naverComponent;
	@Inject private SocialLoginService socialService;
	
    @GetMapping("/naver/callback")
    public String naverCallback(@RequestParam("code") String code,
					            @RequestParam("state") String state,
					            HttpServletRequest request,
					            Model model) throws Exception {

        // 1) Access Token
        String tokenJson = naverComponent.getAccessToken(code, state);
        String accessToken = tokenJson.split("\"access_token\":\"")[1].split("\"")[0];

        // 2) Profile
        String profileJson = naverComponent.getProfile(accessToken);

        // 3) 프로필 -> MemberVO
        MemberVO socialVO = socialService.parseProfile("NAVER", profileJson);

        // 4) provider_id 로 기존 확인
        MemberVO dbUser = socialService.findByProviderId(socialVO.getProvider_id());

        if (dbUser == null) {
            // 신규 가입
            socialService.socialJoin(socialVO);
            dbUser = socialVO;
        }

        // 5) 스프링 시큐리티 강제 로그인
        socialService.forceLogin(dbUser, request);

        return "redirect:/main/header";
    }
	
}
