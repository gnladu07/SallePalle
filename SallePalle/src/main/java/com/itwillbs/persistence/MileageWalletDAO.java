package com.itwillbs.persistence;

import com.itwillbs.domain.MileageWalletVO;

public interface MileageWalletDAO {
	
	// 마일리지 지갑 정보 조회
	public MileageWalletVO getWallet(int member_id);

	// 회원가입 시 회원의 마일리지 지갑 생성
	public void createWallet(int member_id);

	// 거래나 충전에 따른 마일리지 잔액 업데이트
	public void updateMileage(MileageWalletVO vo);

}
