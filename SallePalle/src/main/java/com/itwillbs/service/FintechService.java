package com.itwillbs.service;

public interface FintechService {

	// 핀테크 계좌 연동 및 살래 포인트 충전 처리
	public void processCharge(int member_id, Integer amount);

}
