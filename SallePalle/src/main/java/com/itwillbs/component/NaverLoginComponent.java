package com.itwillbs.component;

import java.math.BigInteger;
import java.net.URI;
import java.net.URISyntaxException;
import java.security.SecureRandom;

import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.RequestEntity;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestTemplate;


@Component
public class NaverLoginComponent {
	
	private String clientId = "GdIw0YPGrs9vqpGmpzBk";
	private String clientSecret  = "oWtEayreak";
	private String callBackURL = "http://localhost:8088/SallePalle/member/naverCallback";
	SecureRandom random = new SecureRandom();
	
	public String getAuthorizationUrl() {
		String state = new BigInteger(130, random).toString();
		String url = "https://nid.naver.com/oauth2.0/authorize?response_type=code";
		url += "&client_id=" + clientId;
		url += "&redirect_uri=" + callBackURL;
		url += "&state=" + state;
		return url;
	}

	public String getAccessToken(String code, String state) throws URISyntaxException {
		String url = "https://nid.naver.com/oauth2.0/token?grant_type=authorization_code&";
		url += "&client_id=" + clientId;
		url += "&client_secret=" + clientSecret;
		url += "&redirect_uri=" + callBackURL;
		url += "&code=" + code;
		url += "&state=" + state;
		
		URI uri = new URI(url);
		
		RestTemplate restTemplate = new RestTemplate();
		RequestEntity<String> request = new RequestEntity<String>(HttpMethod.GET, uri);
		ResponseEntity<String> response = restTemplate.exchange(request, String.class);
		
		return response.getBody();
	}

	public String getProfile(String accessToken) throws URISyntaxException {
		String url = "https://openapi.naver.com/v1/nid/me";
		URI uri = new URI(url);
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Authorization", "Bearer " + accessToken);
		
		RestTemplate restTemplate = new RestTemplate();
		RequestEntity<String> request = new RequestEntity<String>(headers, HttpMethod.GET, uri);
		ResponseEntity<String> response = restTemplate.exchange(request, String.class);
		
		return response.getBody();
	}

}
