package com.itwillbs.service;

import javax.inject.Inject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.itwillbs.domain.AccountSearchRequestVO;
import com.itwillbs.domain.AccountSearchResponseVO;
import com.itwillbs.domain.RequestTokenVO;
import com.itwillbs.domain.ResponseTokenVO;
import com.itwillbs.domain.UserInfoRequestVO;
import com.itwillbs.domain.UserInfoResponseVO;

@Service
public class OpenBankingService {
	
	private static final Logger logger 
		= LoggerFactory.getLogger(OpenBankingService.class);
	
	// API 호출 객체 주입
	@Inject private OpenBankingApiClient apiClient;
	
//	public void setApiClient(OpenBankingApiClient apiClient) {
//		this.apiClient = apiClient;
//	}

	// 토큰발급 요청
	public ResponseTokenVO requestToken(RequestTokenVO requestTokenVO) throws Exception {
		return apiClient.requestToken(requestTokenVO);
	}
	
	// 사용자 정보조회(찾기)
	public UserInfoResponseVO findUserInfo(UserInfoRequestVO userInfoRequestVO) throws Exception {
		return apiClient.findUser(userInfoRequestVO);
	}
	
	// 계좌정보를 조회
	public AccountSearchResponseVO findAccount(AccountSearchRequestVO accountSearchRequestVO) throws Exception {
		return apiClient.findAccount(accountSearchRequestVO);
	}

	
}
