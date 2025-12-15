package com.itwillbs.service;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.stereotype.Service;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponents;
import org.springframework.web.util.UriComponentsBuilder;

import com.itwillbs.controller.HomeController;
import com.itwillbs.domain.AccountSearchRequestVO;
import com.itwillbs.domain.AccountSearchResponseVO;
import com.itwillbs.domain.RequestTokenVO;
import com.itwillbs.domain.ResponseTokenVO;
import com.itwillbs.domain.UserInfoRequestVO;
import com.itwillbs.domain.UserInfoResponseVO;

@Service
public class OpenBankingApiClient {
	
	private static final Logger logger 
		= LoggerFactory.getLogger(OpenBankingApiClient.class);
	
	// 외부에 노출되면 안되는 정보(KEY값)를 설정파일로 부터 주입받아서 사용
	// => Github 사용시 반드시 설정파일은 이그노어 지정
//	@Value("${client_id}")
	private final String ClientID = "b41453f5-4099-4020-a1b3-8200b48abf95";
	
//	@Value("${client_secret}")
	private final String ClientSecret = "60c7ad2e-5722-49bb-a5da-08f43a2af68e";

	private String redirect_uri = "http://localhost:8088/fintech/callback";
	private String grant_type = "authorization_code";

	private String baseUrl = "https://testapi.openbanking.or.kr/v2.0";
	
	// API 호출에 사용되는 공통 객체
	
	// RESTAPI 호출 객체
	private RestTemplate restTemplate;
						
	// 헤더 정보를 저장하는 객체
	private HttpHeaders httpHeaders;
	
	/*
	 * 요청 메시지 UTL
	 * @HTTP_URL https://openapi.openbanking.or.kr/oauth/2.0/token
	 * @HTTP_Method POST
	 * @Content_Type application/x-www-form-urlencoded; charset=UTF-8
	 * 요청 메시지 명세(전달해야 하는 메시지)
	 * code, client_id, client_secret, redirect_uri, grant_type
	 * 
	 * 
	 * @param requestTokenVO
	 * @return 
	 * @throws Exception
	 * 
	 */
	// 기능 - 토큰정보를 요청하는 동작
	public ResponseTokenVO requestToken(RequestTokenVO requestTokenVO) throws Exception {
		
		// 객체 생성(RESTAPI 호출 + HTTP 해더)
		restTemplate = new RestTemplate();
		httpHeaders = new HttpHeaders();
		
		// @Content_Type application/x-www-form-urlencoded; charset=UTF-8
		// => 해더에 정보를 담아서 처리해야함(API 문서에 저장된 형태 그대로 사용)
		httpHeaders.add("Content-Type", "application/x-www-form-urlencoded; charset=UTF-8");
		
		// RequestTokenVO(외부에서 전달받은 정보)
		requestTokenVO.setClient_id(ClientID);
		requestTokenVO.setClient_secret(ClientSecret);
		requestTokenVO.setRedirect_uri(redirect_uri);
		requestTokenVO.setGrant_type(grant_type);
		
		// API 호출을 위한 정보(파라메터)를 생성
		// MultiValueMap<K, V>
		MultiValueMap<String, String> parameters
			= new LinkedMultiValueMap<>();
		
		// code - ARS 후 인증정보
		parameters.add("code", requestTokenVO.getCode());
		// client_id
		parameters.add("client_id", requestTokenVO.getClient_id());
		// client_secret
		// parameters.add("client_secret", requestTokenVO.getClient_secret());
		parameters.add("client_secret", ClientSecret);
		// redirect_uri
		parameters.add("redirect_uri", requestTokenVO.getRedirect_uri());
	//	parameters.add("redirect_uri", redirect_uri);
		// grant_type
		parameters.add("grant_type", requestTokenVO.getGrant_type());
	//	parameters.add("grant_type", grant_type);
		
		// HttpHeaders + parameters 한번에 담기
		HttpEntity<MultiValueMap<String, String>> param
			= new HttpEntity<>(parameters, httpHeaders);
		
		// 호출할 REST API 주소(p27)
		String requestURL 
			= "https://testapi.openbanking.or.kr/oauth/2.0/token";
		
		// * 전달받은 정보를 사용하기 위해서
		//   라이브러리가 필요(jackson-databind, JSON In Java or gson)
		// REST API 호출
		// restTemplate.exchange(호출주소, 호출방법, 전당할 파라메터, 응답받을 타입)
		return restTemplate.exchange(requestURL, HttpMethod.POST, param, ResponseTokenVO.class).getBody();
	}
	/*
	 * @HTTP URL https://openapi.openbanking.or.kr/v2.0/user/me
	 * @HTTP Method GET
	 * 
	 * @param userInfoRequestVO
	 * @return 
	 * @throws Exception 
	 */
	// 사용자 정보조회(외부 API호출)
	public UserInfoResponseVO findUser(UserInfoRequestVO userInfoRequestVO) throws Exception {
		logger.info(" findUser() 실행! ");
		
		// REST 호출에 필요한 객체 생성
		restTemplate = new RestTemplate();
		httpHeaders = new HttpHeaders();
		
		// 사용자정보 조회API 주소 
		String url = baseUrl + "/user/me";
		
		// - 입력값: Bearer <access_token>
		httpHeaders.add("Authorization","Bearer "+userInfoRequestVO.getAccess_token());
		
		// HttpHeaders + HttpBody => 파라메터 정보 + 해더정보 전달
		HttpEntity<String> openBankingUserInfoRequest
			= new HttpEntity<>(httpHeaders);
		
		// UriComponents: 객체를 통해서 특정주소에 파라메터를 전달하는 객체
		// fromHttpUrl(url): 실행할 특정주소(action페이지)
		// queryParam(): 전달할 파라메터 정보(input태그)
		// build(): 메서드 호출을 사용해서 객체 생성
		UriComponents uriBuilder 
			= UriComponentsBuilder
			  .fromHttpUrl(url)		
			  .queryParam("user_seq_no", userInfoRequestVO.getUser_seq_no())
			  .build(); 
		
		// restTemplate.exchange(호출주소, 호출방법, 전당할 파라메터, 응답받을 타입)
		return restTemplate.exchange(uriBuilder.toString(),HttpMethod.GET,openBankingUserInfoRequest,UserInfoResponseVO.class).getBody();
	}
	
	// 계좌정보 조회 - API호출
	public AccountSearchResponseVO findAccount(AccountSearchRequestVO accountSearchRequestVO) throws Exception {
		
		// REST 호출에 필요한 객체 생성
		restTemplate = new RestTemplate();
		httpHeaders = new HttpHeaders();
		
		// 호출할 API주소
		// String url = " https://openapi.openbanking.or.kr/v2.0/account/list";
		String url = baseUrl + "/account/list";
		
		// header 정보를 설정 (Authorization)
		// 입력값: Bearer <access_token>
		httpHeaders.add("Authorization", "Bearer "+accountSearchRequestVO.getAccess_token());
		
		// HttpHeaders -> HttpEntity로 변환
		HttpEntity<String> accountListRequest = new HttpEntity<>(httpHeaders);
		
		// 파라메터는 UriComponents를 사용해서 전달
		UriComponents uriBuilder 
			= UriComponentsBuilder
			  .fromHttpUrl(url)
			  .queryParam("user_seq_no", accountSearchRequestVO.getUser_seq_no())
			  .queryParam("include_cancel_yn", accountSearchRequestVO.getInclude_cancel_yn())
			  .queryParam("sort_order", accountSearchRequestVO.getSort_order())
			  .build();
		
		// RESTAPI 호출
		return restTemplate.exchange(uriBuilder.toString(), HttpMethod.GET, accountListRequest, AccountSearchResponseVO.class).getBody();
	}
	
}
