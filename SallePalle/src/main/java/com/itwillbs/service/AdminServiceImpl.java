package com.itwillbs.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.itwillbs.domain.Criteria;
import com.itwillbs.domain.MemberVO;
import com.itwillbs.persistence.AdminDAO;

@Service
public class AdminServiceImpl implements AdminService {
		
	private static final Logger log 
		= LoggerFactory.getLogger(AdminServiceImpl.class);
	
	@Inject private AdminDAO aDAO;

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
    public List<Map<String, Object>> getAdminGoodsList() throws Exception {
		log.debug(" AdminServiceImpl: getAdminGoodsList() 실행! ");
		log.debug(" AdminServiceImpl: getAdminGoodsList() 끝! ");
        return aDAO.getAdminGoodsList();
    }

    @Override
    public void adminUpdateGoodsStatus(int trade_id, String actionType, String reason, String seller_email) throws Exception {
        // 1. DAO에 넘겨줄 Map 조립
        Map<String, Object> params = new HashMap<>();
        params.put("trade_id", trade_id);
        params.put("status", actionType.equals("STOP") ? "R" : "D"); // R: 판매중지, D: 강제삭제
        
        // 2. DB 업데이트 실행
        aDAO.adminUpdateGoodsStatus(params);

        // 3. 이메일 발송 로직
        String subject = "[살래팔래] 등록하신 중고 물품에 대한 관리자 조치 안내";
        String content = "안녕하세요, 살래팔래 관리자입니다.\n\n"
                       + "회원님께서 등록하신 게시물(방 번호: " + trade_id + ")에 대해 다음과 같은 조치가 취해졌습니다.\n\n"
                       + "▶ 조치 내용: " + (actionType.equals("STOP") ? "판매 중지" : "게시물 강제 삭제") + "\n"
                       + "▶ 관리자 사유: " + reason + "\n\n"
                       + "서비스 이용 규정을 준수해 주시길 부탁드립니다.";
        
        // mailService.sendMail(seller_email, subject, content); // (본인의 메일 서비스 객체로 전송하세요!)
    }

}
