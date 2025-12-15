package com.itwillbs.persistence;

import com.itwillbs.domain.PayWalletVO;

public interface PayWalletDAO {
	
    // 보유 포인트 조회
    PayWalletVO getWallet(int member_id);

    // 지갑 생성 (회원가입 시 자동 생성)
    void createWallet(int member_id);

    // 포인트 충전/차감 처리
    void updateBalance(PayWalletVO vo);

}
