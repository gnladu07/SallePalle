package com.itwillbs.component;


import java.math.BigInteger;
import java.net.URI;
import java.net.URISyntaxException;
import java.security.SecureRandom;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.RequestEntity;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestTemplate;

@Component
public class NaverLoginComponent {

	
	private static final Logger logger = LoggerFactory.getLogger(NaverLoginComponent.class);


	private String clientId = "bSCdMpZcof9QoefeNJGk";
	private String clientSecret = "dMWiCkpOXN";
	private String callbackURL = "http://c6d2507t3p2.itwillbs.com/member/naverCallback";
	private SecureRandom random = new SecureRandom();
	
	// 1) 네이버 로그인 주소를 불러오기 위한 함수
	// 네이버 로그인 API를 신청한 클라이언트(서비스 제공자)의 clientId 를 전달한다
	// 로그인 결과를 알려줄 콜백 주소를 전달한다
	// 여러 사람이 동시에 로그인을 시도할 수 있으므로, 각각을 구분하기 위한 state 를 전달한다
	public String getAuthorizationUrl() {
		String state = new BigInteger(130, random).toString();
		String url = "https://nid.naver.com/oauth2.0/authorize?response_type=code";
		url += "&client_id=" + clientId;
		url += "&redirect_uri=" + callbackURL;
		url += "&state=" + state;
//		session.setAttribute("state", state);
		return url;
	}

	// 2) 네이버 액세스 토큰을 획득하는 과정
	// 토큰을 가지고 있는 사용자만 네이버 로그인 전용 API를 사용할 수 있다
	// 토큰을 획득하기 위해서는, clientSecret 도 함께 전달하고
	// 이전 단계에서 로그인을 수행했던 state 를 함께 전달해야 한다
	public String getAccessToken(String code, String state) throws URISyntaxException {
		String url = "https://nid.naver.com/oauth2.0/token?grant_type=authorization_code";
		url += "&client_id=" + clientId;
		url += "&client_secret=" + clientSecret;
		url += "&redirect_uri=" + callbackURL;
		url += "&code=" + code;
		url += "&state=" + state;
		
		URI uri = new URI(url);
		
		RestTemplate template = new RestTemplate();
		RequestEntity<String> request = new RequestEntity<String>(HttpMethod.GET, uri);
		ResponseEntity<String> response = template.exchange(request, String.class);
		
		return response.getBody();
	}

	// 3) 액세스 토큰을 이용하여 네이버 프로필 정보를 받아오기
	// 발급받은 액세스 토큰을 이용하여 사용자 프로필 정보를 획득할 수 있다
	// 액세스 토큰만으로도, NAVER API 의 모든 권한을 부여받기 때문에 다른 값은 필요없다
	public String getProfile(String access_token) throws URISyntaxException {
		logger.info(" getProfile()실행! ");
		String url = "https://openapi.naver.com/v1/nid/me";
		URI uri = new URI(url);
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Authorization", "Bearer " + access_token);	// Bearer AccessToken 사이에 띄어쓰기
		
		logger.info(" headers: "+headers);
		
		RestTemplate template = new RestTemplate();
		RequestEntity<String> request = new RequestEntity<String>(headers, HttpMethod.GET, uri);
		ResponseEntity<String> response = template.exchange(request, String.class);
		logger.info(" getProfile()끝! ");
		return response.getBody();
	}
	
}
