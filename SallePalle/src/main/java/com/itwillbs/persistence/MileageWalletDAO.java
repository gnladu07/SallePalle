package com.itwillbs.persistence;

import com.itwillbs.domain.MileageWalletVO;

public interface MileageWalletDAO {
	
	MileageWalletVO getWallet(int member_id);

    void createWallet(int member_id);

    void updateMileage(MileageWalletVO vo);

}
