package com.itwillbs.service;

import java.util.List;
import java.util.Map;

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
		log.debug(" SellerServiceImpl: createRequest()실행! ");
		
		sellerDAO.insertSellerRequest(member_id);
		
		log.debug(" SellerServiceImpl: createRequest()끝! ");
	}

	@Override
	public SellerRequestVO getRequest(int request_id) {
		log.debug(" SellerServiceImpl: getRequest()실행! ");
		
		SellerRequestVO resultVO = sellerDAO.selectSellerRequest(request_id);
		
		log.debug(" SellerServiceImpl: getRequest()끝! ");
		return resultVO;
	}

	@Override
	public void updateRequestStatus(int request_id, String status) {
		log.debug(" SellerServiceImpl: updateRequestStatus()실행! ");
		
		sellerDAO.updateSellerRequestStatus(request_id, status);
		
		log.debug(" SellerServiceImpl: updateRequestStatus()끝! ");
	}

	@Override
    public List<SellerRequestVO> getSellerRequestListPaged(Map<String, Object> paramMap) throws Exception {
		log.debug(" SellerServiceImpl: getSellerRequestListPaged()실행! ");
		log.debug(" SellerServiceImpl: getSellerRequestListPaged()끝! ");
        return sellerDAO.getSellerRequestListPaged(paramMap);
    }

    @Override
    public int getTotalSellerRequestCount(Map<String, Object> paramMap) throws Exception {
    	log.debug(" SellerServiceImpl: getTotalSellerRequestCount()실행! ");
		log.debug(" SellerServiceImpl: getTotalSellerRequestCount()끝! ");
        return sellerDAO.getTotalSellerRequestCount(paramMap);
    }

	@Override
	public void approveRequest(int request_id, int member_id) {
		log.debug(" SellerServiceImpl: approveRequest() 실행!");
		
		sellerDAO.approveRequest(request_id);
        mService.updateSellerStatus(member_id, "Y");
        mService.setNotifyFlag(member_id, "Y");
        
        // 이메일 발송
        MemberVO member = mService.getMemberById(member_id);

        String subject = "[살래팔래] 판매 권한 승인 안내";
        String content = member.getUsername() + "님,<br><br>"
                + "판매 권한 신청이 승인되었습니다.<br>"
                + "이제부터 판매자 기능을 이용하실 수 있습니다.<br><br>"
                + "감사합니다.";

        mail.sendMassage(member.getEmail(), subject, content);
		
        log.debug(" SellerServiceImpl: approveRequest() 끝!");
	}

	@Override
	public void rejectRequest(int request_id, int member_id) {
		log.debug(" SellerServiceImpl: rejectRequest() 실행!");
		
		sellerDAO.rejectRequest(request_id);

        mService.updateSellerStatus(member_id, "N");
        mService.setNotifyFlag(member_id, "Y");
		
		// 이메일 발송
        MemberVO member = mService.getMemberById(member_id);

        String subject = "[살래팔래] 판매 권한 신청 결과 안내";
        String content = member.getUsername() + "님,<br><br>"
                + "판매 권한 신청이 검토 결과 거절되었습니다.<br>"
                + "추후 조건 충족 시 다시 신청해 주세요.<br><br>"
                + "감사합니다.";

        mail.sendMassage(member.getEmail(), subject, content);
        log.debug(" SellerServiceImpl: rejectRequest() 끝!");
	}

}
