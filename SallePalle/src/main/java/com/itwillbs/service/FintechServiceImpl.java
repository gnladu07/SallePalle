package com.itwillbs.service;

import javax.inject.Inject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestTemplate;

import com.itwillbs.domain.MileageHistoryVO;
import com.itwillbs.domain.MileageWalletVO;
import com.itwillbs.domain.PayHistoryVO;
import com.itwillbs.domain.PayWalletVO;
import com.itwillbs.domain.RequestTokenVO;
import com.itwillbs.domain.ResponseTokenVO;
import com.itwillbs.persistence.MileageHistoryDAO;
import com.itwillbs.persistence.MileageWalletDAO;
import com.itwillbs.persistence.PayHistoryDAO;
import com.itwillbs.persistence.PayWalletDAO;

@Service
public class FintechServiceImpl implements FintechService {
	
	private static final Logger log 
		= LoggerFactory.getLogger(FintechServiceImpl.class);

    @Inject private PayWalletDAO payWalletDAO;
    @Inject private PayHistoryDAO payHistoryDAO;
    @Inject private MileageWalletDAO mileageWalletDAO;
    @Inject private MileageHistoryDAO mileageHistoryDAO;

	@Override
	public void processCharge(int member_id, Integer amount) {
	       log.debug("FintechServiceImpl: processCharge() 실행");

	        PayWalletVO wallet = payWalletDAO.getWallet(member_id);

	        if (wallet == null) {
	            log.info("지갑이 없어 신규 생성 수행");
	            payWalletDAO.createWallet(member_id);
	            wallet = payWalletDAO.getWallet(member_id);
	        }

	        int newBalance = wallet.getBalance() + amount;
	        wallet.setBalance(newBalance);
	        payWalletDAO.updateBalance(wallet);

	        PayHistoryVO his = new PayHistoryVO();
	        his.setMember_id(member_id);
	        his.setAmount(amount);
	        his.setType("CHARGE");
	        his.setMemo("오픈뱅킹 충전");

	        payHistoryDAO.insertHistory(his);

	        // 4) 마일리지 적립
	        int mileageAmount = (int) (amount * 0.1);

	        MileageWalletVO mWallet = mileageWalletDAO.getWallet(member_id);
	        if (mWallet == null) {
	            mileageWalletDAO.createWallet(member_id);
	            mWallet = mileageWalletDAO.getWallet(member_id);
	        }

	        mWallet.setMileage(mWallet.getMileage() + mileageAmount);
	        mileageWalletDAO.updateMileage(mWallet);

	        // 5) 마일리지 내역 저장
	        MileageHistoryVO mh = new MileageHistoryVO();
	        mh.setMember_id(member_id);
	        mh.setAmount(mileageAmount);
	        mh.setType("EARN");
	        mh.setMemo("포인트 충전 적립");
	        mileageHistoryDAO.insertHistory(mh);

	        log.debug("포인트 충전 완료: {} P / 마일리지 적립 완료: {} M", amount, mileageAmount);
		
	}
}
