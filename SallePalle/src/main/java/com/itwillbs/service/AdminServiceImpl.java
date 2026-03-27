package com.itwillbs.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.itwillbs.component.MailComponent;
import com.itwillbs.domain.Criteria;
import com.itwillbs.domain.MemberVO;
import com.itwillbs.persistence.AdminDAO;

@Service
public class AdminServiceImpl implements AdminService {
		
	private static final Logger log 
		= LoggerFactory.getLogger(AdminServiceImpl.class);
	
	@Inject private AdminDAO aDAO;
	@Inject private MailComponent mailComponent;

	@Override
	public List<MemberVO> getMemberListPaged(Criteria cri) {
		log.debug(" AdminServiceImpl: getMemberListPaged() 실행! ");
		
		List<MemberVO> resultVO = aDAO.getMemberListPaged(cri);
		
		log.debug(" AdminServiceImpl: getMemberListPaged() 끝! ");
		return resultVO;
	}
	
	@Override
	public int getTotalCount() {
		log.debug(" AdminServiceImpl: getTotalCount() 실행! ");
		
		int resultVO = aDAO.getTotalCount();
		
		log.debug(" AdminServiceImpl: getTotalCount() 끝! ");
		return resultVO;
	}

	@Override
	public int getSellerCount() {
		log.debug(" AdminServiceImpl: getSellerCount() 실행! ");
		
		int resultVO = aDAO.getSellerCount();
		
		log.debug(" AdminServiceImpl: getSellerCount() 끝! ");
		return resultVO;
	}
	
	@Override
	public int getTotalCountFiltered(Criteria cri) {
		log.debug(" AdminServiceImpl: getTotalCountFiltered() 실행! ");
		
		int resultVO = aDAO.getTotalCountFiltered(cri);
		
		log.debug(" AdminServiceImpl: getTotalCountFiltered() 끝! ");
		return resultVO;
	}

	@Override
	public int getTotalProductCount() throws Exception {
		log.debug(" AdminServiceImpl: getTotalProductCount() 실행! ");
		log.debug(" AdminServiceImpl: getTotalProductCount() 끝! ");
		return aDAO.getTotalProductCount();
	}

	@Override
	public int getActiveChatRoomCount() throws Exception {
		log.debug(" AdminServiceImpl: getActiveChatRoomCount() 실행! ");
		log.debug(" AdminServiceImpl: getActiveChatRoomCount() 끝! ");
		return aDAO.getActiveChatRoomCount();
	}

    @Override
    public List<Map<String, Object>> getAdminGoodsList(Map<String, Object> paramMap) throws Exception {
    	log.debug(" AdminServiceImpl: getAdminGoodsList() 실행! ");
		log.debug(" AdminServiceImpl: getAdminGoodsList() 끝! ");
        return aDAO.getAdminGoodsList(paramMap);
    }

    @Override
    public void adminUpdateGoodsStatus(int trade_id, String actionType, String reason, String seller_email) throws Exception {
    	log.debug(" AdminServiceImpl: adminUpdateGoodsStatus() 실행! ");
    	
        Map<String, Object> params = new HashMap<>();
        params.put("trade_id", trade_id);
        params.put("status", actionType.equals("STOP") ? "R" : "D"); // R: 판매중지, D: 강제삭제
        
        aDAO.adminUpdateGoodsStatus(params);

        String subject = "[살래팔래] 등록하신 중고 물품에 대한 관리자 조치 안내";       
        String content = "<div style='font-family: \"Noto Sans KR\", sans-serif; padding: 30px; border: 1px solid #eee; border-radius: 10px; max-width: 600px; margin: 0 auto;'>"
                       + "  <h2 style='color: #333; border-bottom: 2px solid #FF6F61; padding-bottom: 10px;'>관리자 조치 안내</h2>"
                       + "  <p style='font-size: 15px; color: #555; line-height: 1.6;'>안녕하세요, 살래팔래 관리자입니다.<br>"
                       + "  회원님께서 등록하신 게시물 (<strong>상품 번호: " + trade_id + "</strong>)에 대해 다음과 같은 조치가 취해졌습니다.</p>"
                       + "  <div style='background: #f8f9fa; padding: 20px; border-radius: 8px; margin: 20px 0;'>"
                       + "    <p style='margin: 0 0 10px 0; font-size: 15px;'><strong>▶ 조치 내용 : </strong> <span style='color: #e74c3c; font-weight: bold;'>" + (actionType.equals("STOP") ? "판매 중지 처리" : "게시물 강제 삭제") + "</span></p>"
                       + "    <p style='margin: 0; font-size: 15px;'><strong>▶ 관리자 사유 : </strong> " + reason + "</p>"
                       + "  </div>"
                       + "  <p style='font-size: 14px; color: #888; margin-top: 30px;'>안전하고 신뢰할 수 있는 거래 환경을 위해 서비스 이용 규정을 준수해 주시길 부탁드립니다. 감사합니다.</p>"
                       + "</div>";

        int mailResult = mailComponent.sendMassage(seller_email, subject, content);
        
        if(mailResult == 1) {
        	log.info("관리자 제재 안내 메일 발송 성공 (대상: {})", seller_email);
        } else {
        	log.error("관리자 제재 안내 메일 발송 실패 (대상: {})", seller_email);
        }
        log.debug(" AdminServiceImpl: adminUpdateGoodsStatus() 끝! ");
    }

}
