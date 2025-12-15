package com.itwillbs.service;

import com.itwillbs.domain.RequestTokenVO;
import com.itwillbs.domain.ResponseTokenVO;

public interface FintechService {

	// 금융결제원 토큰 요청
	public ResponseTokenVO requestToken(RequestTokenVO vo) throws Exception;

	// 포인트 + 마일리지 충전 처리
	public void processCharge(Integer amount, ResponseTokenVO token) throws Exception;

}
