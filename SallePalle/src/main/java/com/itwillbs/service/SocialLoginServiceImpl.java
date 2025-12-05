package com.itwillbs.service;

import java.util.UUID;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;


import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.itwillbs.domain.MemberVO;
import com.itwillbs.persistence.MemberDAO;
import com.itwillbs.security.CustomUserDetails;
import com.itwillbs.security.CustomUserDetailsService;

@Service
public class SocialLoginServiceImpl implements SocialLoginService {
	
	private static final Logger logger 
		= LoggerFactory.getLogger(SocialLoginServiceImpl.class);
	
	@Inject private MemberDAO memberDAO;
	@Inject private PasswordEncoder pwEncoder;
	@Inject private CustomUserDetailsService userDetailsService;

	@Override
	public MemberVO parseProfile(String provider, String profileJson) {
		logger.info(" ServiceImpl: parseProfile() 실행! ");
		
		JsonObject obj = JsonParser.parseString(profileJson).getAsJsonObject();
		JsonObject res = obj.getAsJsonObject("response");
		
		MemberVO vo = new MemberVO();
		vo.setProvider(provider.toUpperCase());	//  NAVER, KAKAO, GOOGLE
		
		switch(provider.toUpperCase()) {
		
			case "NAVER":
	            vo.setProvider_id(res.get("id").getAsString());
	            vo.setUsername(res.get("name").getAsString());
	            vo.setNickname(res.get("nickname").getAsString());
	            vo.setEmail(res.get("email").getAsString());
	            vo.setGender(res.has("gender") ? res.get("gender").getAsString() : null);
	            vo.setMobile(res.has("mobile") ? res.get("mobile").getAsString() : null);
	
	            if (res.has("birthyear") && res.has("birthday")) {
	                String yy = res.get("birthyear").getAsString().substring(2, 4);
	                String mmdd = res.get("birthday").getAsString().replace("-", "");
	                vo.setBirth6(yy + mmdd);
	            }
	            break;
	
	        case "KAKAO":
	            // 카카오 
	            break;
	
	        case "GOOGLE":
	            // 구글
	            break;
		}
		logger.info(" ServiceImpl: parseProfile() 끝! ");
		return vo;
	}

	@Override
	public MemberVO findByProviderId(String providerId) {
		logger.info(" ServiceImpl: findByProviderId() 실행! ");
		
		MemberVO resultVO = memberDAO.findByProviderId(providerId);
		
		logger.info(" ServiceImpl: findByProviderId() 끝! ");
		return resultVO;
	}

	@Override
	public void socialJoin(MemberVO vo) {
		logger.info(" ServiceImpl: socialJoin() 실행! ");
		
		// 소셜 로그인은 비밀번호 없음 → 랜덤 더미 PW
        String dummyPw = pwEncoder.encode(UUID.randomUUID().toString());
        vo.setUserpw(dummyPw);

        vo.setSeller_status("N");
        vo.setEnable_flag("1");

        memberDAO.insertSocialMember(vo);
		
		logger.info(" ServiceImpl: socialJoin() 끝! ");
	}

	@Override
	public void forceLogin(MemberVO vo, HttpServletRequest request) {
        CustomUserDetails cud =
                (CustomUserDetails) userDetailsService.loadUserByUsername(vo.getUserid());

        UsernamePasswordAuthenticationToken auth =
                new UsernamePasswordAuthenticationToken(
                        cud, null, cud.getAuthorities()
                );

        SecurityContextHolder.getContext().setAuthentication(auth);

        request.getSession().setAttribute("loginInfo", vo);
	}

}
