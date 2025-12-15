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
	
	@Inject private OpenBankingService openBankService;   // 금융결제원 API 호출용 서비스
	
	@Inject private PayWalletDAO payWalletDAO;
    @Inject private PayHistoryDAO payHistoryDAO;
    
    @Inject private MileageWalletDAO mileageWalletDAO;
    @Inject private MileageHistoryDAO mileageHistoryDAO;

	@Override
	public ResponseTokenVO requestToken(RequestTokenVO vo) throws Exception {

		log.info("금융결제원 토큰 요청 - requestToken() 시작");

	    RestTemplate restTemplate = new RestTemplate();
	    HttpHeaders headers = new HttpHeaders();
	    headers.add("Content-Type", "application/x-www-form-urlencoded; charset=UTF-8");
	    headers.add("Accept", "application/json");  // JSON 응답 강제

	    // 요청 파라미터 구성
	    MultiValueMap<String, String> params = new LinkedMultiValueMap<>();
	    params.add("code", vo.getCode());
	    params.add("client_id", vo.getClient_id());
	    params.add("client_secret", vo.getClient_secret());
	    params.add("redirect_uri", vo.getRedirect_uri());
	    params.add("grant_type", vo.getGrant_type());

	    HttpEntity<MultiValueMap<String, String>> requestEntity = new HttpEntity<>(params, headers);

	    String url = "https://testapi.openbanking.or.kr/oauth/2.0/token";

	    // 1) 원본 응답 로깅
	    ResponseEntity<String> raw = restTemplate.exchange(url, HttpMethod.POST, requestEntity, String.class);

	    log.error("===== [Raw Token Response] =====");
	    log.error("StatusCode: " + raw.getStatusCode());
	    log.error("Headers: " + raw.getHeaders());
	    log.error("Body: " + raw.getBody());
	    log.error("===============================");

	    // 2) 실패 판단
	    if (!raw.getStatusCode().is2xxSuccessful()) {
	    	log.error("토큰 요청 실패 - 응답코드 비정상");
	        throw new RuntimeException("토큰 요청 실패: HTTP " + raw.getStatusCode());
	    }

	    // 3) JSON → VO 매핑 시도
	    ResponseTokenVO token =
	        restTemplate.exchange(url, HttpMethod.POST, requestEntity, ResponseTokenVO.class).getBody();

	    log.info("===== [Parsed TokenVO] =====");
	    log.info("access_token: " + token.getAccess_token());
	    log.info("refresh_token: " + token.getRefresh_token());
	    log.info("user_seq_no: " + token.getUser_seq_no());
	    log.info("============================");

	    return token;
    }

	@Transactional
	@Override
	public void processCharge(Integer amount, ResponseTokenVO token) throws Exception {
		log.info(" FintechServiceImpl: processCharge()실행! ");
		
		int member_id = token.getMember_id(); 
		
		// 1) 포인트 지갑 조회 / 없으면 생성
		PayWalletVO wallet = payWalletDAO.getWallet(member_id);

        if (wallet == null) {
            log.info("포인트 지갑 없음 → 신규 생성");
            payWalletDAO.createWallet(member_id);
            wallet = payWalletDAO.getWallet(member_id);
        }

        int newBalance = wallet.getBalance() + amount;
        wallet.setBalance(newBalance);
        payWalletDAO.updateBalance(wallet);
        
        // 2) 포인트 내역 저장
        PayHistoryVO payHis = new PayHistoryVO();
        payHis.setMember_id(member_id);
        payHis.setAmount(amount);
        payHis.setType("CHARGE");
        payHis.setMemo("포인트 충전");

        payHistoryDAO.insertHistory(payHis);

        // 3) 마일리지 적립 (충전 금액의 10%)
        int mileageAmount = (int)(amount * 0.1);

        MileageWalletVO mWallet = mileageWalletDAO.getWallet(member_id);

        if (mWallet == null) {
            mileageWalletDAO.createWallet(member_id);
            mWallet = mileageWalletDAO.getWallet(member_id);
        }

        mWallet.setMileage(mWallet.getMileage() + mileageAmount);
        mileageWalletDAO.updateMileage(mWallet);
        
        // 4) 마일리지 히스토리 저장
        MileageHistoryVO mh = new MileageHistoryVO();
        mh.setMember_id(member_id);
        mh.setAmount(mileageAmount);
        mh.setType("EARN");
        mh.setMemo("포인트 충전 적립");

        mileageHistoryDAO.insertHistory(mh);

        log.info("포인트 충전 + 마일리지 적립 완료");
		log.info(" FintechServiceImpl: processCharge()끝! ");
	}

}
