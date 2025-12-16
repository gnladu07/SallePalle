package com.itwillbs.service;

import java.util.List;

import javax.inject.Inject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.itwillbs.component.MailComponent;
import com.itwillbs.domain.MemberVO;
import com.itwillbs.domain.SellerRequestVO;
import com.itwillbs.persistence.SellerDAO;

@Service
public class SellerServiceImpl implements SellerService {
		
	private static final Logger log 
		= LoggerFactory.getLogger(SellerServiceImpl.class);

	@Inject SellerDAO sellerDAO;
	@Inject private MemberService mService;
    @Inject private MailComponent mail;
	
	
	@Override
	public void createRequest(int member_id) {
		log.info(" SellerServiceImpl: createRequest()실행! ");
		
		sellerDAO.insertSellerRequest(member_id);
		
		log.info(" SellerServiceImpl: createRequest()끝! ");
	}

	@Override
	public SellerRequestVO getRequest(int request_id) {
		log.info(" SellerServiceImpl: getRequest()실행! ");
		
		SellerRequestVO resultVO = sellerDAO.selectSellerRequest(request_id);
		
		log.info(" SellerServiceImpl: getRequest()끝! ");
		return resultVO;
	}

	@Override
	public void updateRequestStatus(int request_id, String status) {
		log.info(" SellerServiceImpl: updateRequestStatus()실행! ");
		
		sellerDAO.updateSellerRequestStatus(request_id, status);
		
		log.info(" SellerServiceImpl: updateRequestStatus()끝! ");
	}

	@Override
	public List<SellerRequestVO> getWaitingRequests() {
		log.info(" SellerServiceImpl: getWaitingRequests() 실행!");
		return sellerDAO.getWaitingRequests();
	}

	@Override
	public void approveRequest(int request_id, int member_id) {
		log.info(" SellerServiceImpl: approveRequest() 실행!");
		
		// seller_request 승인 처리
		sellerDAO.approveRequest(request_id);

        // member 테이블 seller_status = 'Y'
        mService.updateSellerStatus(member_id, "Y");
    
        // 메일 발송 확인 
        mService.setNotifyFlag(member_id, "Y");
        
        // 이메일 발송
        MemberVO member = mService.getMemberById(member_id);

        String subject = "[살래팔래] 판매 권한 승인 안내";
        String content = member.getUsername() + "님,<br><br>"
                + "판매 권한 신청이 승인되었습니다.<br>"
                + "이제부터 판매자 기능을 이용하실 수 있습니다.<br><br>"
                + "감사합니다.";

        mail.sendMassage(member.getEmail(), subject, content);
		
	}

	@Override
	public void rejectRequest(int request_id, int member_id) {
		log.info(" SellerServiceImpl: rejectRequest() 실행!");
		
		sellerDAO.rejectRequest(request_id);
		
        // member 테이블 seller_status = 'N'
        mService.updateSellerStatus(member_id, "N");
     
        // 메일 발송 확인
        mService.setNotifyFlag(member_id, "Y");
		
		// 이메일 발송
        MemberVO member = mService.getMemberById(member_id);

        String subject = "[살래팔래] 판매 권한 신청 결과 안내";
        String content = member.getUsername() + "님,<br><br>"
                + "판매 권한 신청이 검토 결과 거절되었습니다.<br>"
                + "추후 조건 충족 시 다시 신청해 주세요.<br><br>"
                + "감사합니다.";

        mail.sendMassage(member.getEmail(), subject, content);
	}

}
