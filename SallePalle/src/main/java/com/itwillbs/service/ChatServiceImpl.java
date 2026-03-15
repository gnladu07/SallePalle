package com.itwillbs.service;

import java.util.List;
import javax.inject.Inject;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.itwillbs.domain.ChatMessageVO;
import com.itwillbs.domain.ChatRoomVO;
import com.itwillbs.domain.SaleTradeVO;
import com.itwillbs.persistence.ChatDAO;
import com.itwillbs.persistence.SaleTradeDAO;

@Service
public class ChatServiceImpl implements ChatService {

    @Inject private ChatDAO chatDAO;
    @Inject private SaleTradeDAO saleTradeDAO;

    @Override
    public int createOrGetRoom(int trade_id, int buyer_id, int seller_id) {
        // 1. 방이 이미 존재하는지 확인
        int roomId = chatDAO.findRoom(trade_id, buyer_id);
        
        // 2. 없으면 새로 생성
        if (roomId == 0) {
            ChatRoomVO newRoom = new ChatRoomVO();
            newRoom.setTrade_id(trade_id);
            newRoom.setBuyer_id(buyer_id);
            newRoom.setSeller_id(seller_id);
            
            chatDAO.createRoom(newRoom);
            roomId = newRoom.getRoom_id(); // MyBatis useGeneratedKeys 속성으로 자동 세팅됨
        }
        return roomId;
    }

    @Override
    public void saveMessage(ChatMessageVO vo) {
        chatDAO.insertMessage(vo);
    }

    @Override
    public List<ChatMessageVO> getMessageHistory(int room_id) {
        return chatDAO.getMessagesByRoomId(room_id);
    }

    @Override
    public List<ChatRoomVO> getMyChatRooms(int member_id) {
        return chatDAO.getRoomList(member_id);
    }

    @Override
    public ChatRoomVO getRoom(int room_id) {
        return chatDAO.getRoom(room_id);
    }

    @Transactional // 중요: 하나라도 실패하면 롤백
    @Override
    public boolean executePayment(ChatRoomVO room) {
        // 1. 상품 정보 조회 (가격 확인)
        SaleTradeVO trade = saleTradeDAO.selectSaleTradeDetail(room.getTrade_id());
        int price = trade.getPrice_point();

        // 2. 구매자 잔액 확인
        int balance = saleTradeDAO.selectPayBalance(room.getBuyer_id());
        if (balance < price) return false;

        // 3. 구매자 포인트 차감
        saleTradeDAO.usePoint(room.getBuyer_id(), price);

        // 4. 판매자 포인트 적립
        saleTradeDAO.earnPoint(room.getSeller_id(), price);

        // 5. 거래 내역 저장 (trade_history)
        // 기존 메서드: insertTradeHistory(tradeId, buyerId, sellerId, usedPoint, earnPoint, usedMileage)
        saleTradeDAO.insertTradeHistory(room.getTrade_id(), room.getBuyer_id(), room.getSeller_id(), price, price, 0);

        // 6. 게시글 상태 변경 (S:판매중 -> C:완료)
        saleTradeDAO.updateTradeStatusComplete(room.getTrade_id());

        return true;
    }

    @Transactional // 메시지와 방 삭제가 원자적으로 이루어지도록 설정
    @Override
    public void leaveChatRoom(int room_id) throws Exception {
        // 1. 외래키(FK) 충돌을 막기 위해 해당 방의 '메시지'들을 먼저 모두 삭제합니다.
        chatDAO.deleteChatMessages(room_id);
        
        // 2. 그 다음 빈 '채팅방'을 삭제합니다.
        chatDAO.deleteChatRoom(room_id);
    }
}