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
	private String callbackURL = "http://localhost:8088/member/naverCallback";
	private SecureRandom random = new SecureRandom();
	
	public String getAuthorizationUrl() {
		String state = new BigInteger(130, random).toString();
		String url = "https://nid.naver.com/oauth2.0/authorize?response_type=code";
		url += "&client_id=" + clientId;
		url += "&redirect_uri=" + callbackURL;
		url += "&state=" + state;
		return url;
	}

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

	public String getProfile(String access_token) throws URISyntaxException {
		logger.info(" getProfile()실행! ");
		String url = "https://openapi.naver.com/v1/nid/me";
		URI uri = new URI(url);
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Authorization", "Bearer " + access_token);
		
		logger.info(" headers: "+headers);
		
		RestTemplate template = new RestTemplate();
		RequestEntity<String> request = new RequestEntity<String>(headers, HttpMethod.GET, uri);
		ResponseEntity<String> response = template.exchange(request, String.class);
		logger.info(" getProfile()끝! ");
		return response.getBody();
	}
	
}
