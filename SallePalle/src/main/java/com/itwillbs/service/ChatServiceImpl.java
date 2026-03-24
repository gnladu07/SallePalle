package com.itwillbs.service;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.itwillbs.domain.ChatMessageVO;
import com.itwillbs.domain.ChatRoomVO;
import com.itwillbs.domain.SaleTradeVO;
import com.itwillbs.persistence.ChatDAO;
import com.itwillbs.persistence.SaleTradeDAO;

@Service
public class ChatServiceImpl implements ChatService {
	
	private static final Logger log 
		= LoggerFactory.getLogger(AdminServiceImpl.class);

    @Inject private ChatDAO chatDAO;
    @Inject private SaleTradeDAO saleTradeDAO;

    @Override
    public int createOrGetRoom(int trade_id, int buyer_id, int seller_id) {
    	log.debug(" ChatServiceImpl: findRoom() 실행! ");
        int roomId = chatDAO.findRoom(trade_id, buyer_id);
        
        if (roomId == 0) {
            ChatRoomVO newRoom = new ChatRoomVO();
            newRoom.setTrade_id(trade_id);
            newRoom.setBuyer_id(buyer_id);
            newRoom.setSeller_id(seller_id);
            
            chatDAO.createRoom(newRoom);
            roomId = newRoom.getRoom_id();
        }
        log.debug(" ChatServiceImpl: findRoom() 끝! ");
        return roomId;
    }

    @Override
    public void saveMessage(ChatMessageVO vo) {
    	log.debug(" ChatServiceImpl: saveMessage() 실행! ");
        chatDAO.insertMessage(vo);
        log.debug(" ChatServiceImpl: saveMessage() 실행! ");
    }

    @Override
    public List<ChatMessageVO> getMessageHistory(int room_id) {
    	log.debug(" ChatServiceImpl: getMessageHistory() 실행! ");
    	log.debug(" ChatServiceImpl: getMessageHistory() 실행! ");
        return chatDAO.getMessagesByRoomId(room_id);
    }

    @Override
    public List<ChatRoomVO> getMyChatRooms(int member_id) {
    	log.debug(" ChatServiceImpl: getMyChatRooms() 실행! ");
    	log.debug(" ChatServiceImpl: getMyChatRooms() 실행! ");
        return chatDAO.getRoomList(member_id);
    }

    @Override
    public ChatRoomVO getRoom(int room_id) {
    	log.debug(" ChatServiceImpl: getRoom() 실행! ");
    	log.debug(" ChatServiceImpl: getRoom() 실행! ");
        return chatDAO.getRoom(room_id);
    }

    @Transactional
    @Override
    public boolean executePayment(ChatRoomVO room) {
    	log.debug(" ChatServiceImpl: executePayment() 실행! ");
        // 1. 상품 정보 조회 (가격 확인)
        SaleTradeVO trade = saleTradeDAO.selectSaleTradeDetail(room.getTrade_id());
        int price = trade.getPrice_point();

        // 2. 구매자 잔액 확인
        int balance = saleTradeDAO.selectPayBalance(room.getBuyer_id());
        if (balance < price) return false;

        // 구매자 지갑이 없으면 생성
        if (saleTradeDAO.existsPayWallet(room.getBuyer_id()) == 0) {
            saleTradeDAO.insertPayWallet(room.getBuyer_id());
        }

        // 3. 구매자 포인트 차감 - 지갑없으면 생성
        saleTradeDAO.usePoint(room.getBuyer_id(), price);
        if (saleTradeDAO.existsPayWallet(room.getSeller_id()) == 0) {
            saleTradeDAO.insertPayWallet(room.getSeller_id());
        }

        // 4. 판매자 포인트 적립
        saleTradeDAO.earnPoint(room.getSeller_id(), price);

        // 5. 거래 내역 저장
        saleTradeDAO.insertTradeHistory(room.getTrade_id(), room.getBuyer_id(), room.getSeller_id(), price, price, 0);

        log.debug(" ChatServiceImpl: executePayment() 실행! ");
        return true;
    }

    @Transactional
    @Override
    public void leaveChatRoom(int room_id) throws Exception {
    	log.debug(" ChatServiceImpl: leaveChatRoom() 실행! ");
        // 메시지 삭제
        chatDAO.deleteChatMessages(room_id);
        
        // 채팅방 삭제
        chatDAO.deleteChatRoom(room_id);
        log.debug(" ChatServiceImpl: leaveChatRoom() 실행! ");
    }
    
    @Override
    public void markMessagesAsRead(int room_id, int reader_id) throws Exception {
    	log.debug(" ChatServiceImpl: markMessagesAsRead() 실행! ");
        Map<String, Object> paramMap = new java.util.HashMap<>();
        paramMap.put("room_id", room_id);
        paramMap.put("reader_id", reader_id);
        
        chatDAO.markMessagesAsRead(paramMap);
        log.debug(" ChatServiceImpl: markMessagesAsRead() 실행! ");
    }

    @Override
    public List<ChatRoomVO> getChatHistoryLog(int member_id) throws Exception {
    	log.debug(" ChatServiceImpl: getChatHistoryLog() 실행! ");
    	log.debug(" ChatServiceImpl: getChatHistoryLog() 실행! ");
        return chatDAO.getChatHistoryLog(member_id);
    }

	@Override
	public void flagChatRoom(int room_id) throws Exception {
		log.debug(" ChatServiceImpl: flagChatRoom() 실행! ");
		chatDAO.flagChatRoom(room_id);
		log.debug(" ChatServiceImpl: flagChatRoom() 실행! ");
	}

	@Override
    public List<ChatRoomVO> getAdminChatList() throws Exception {
		log.debug(" ChatServiceImpl: getAdminChatList() 실행! ");
    	log.debug(" ChatServiceImpl: getAdminChatList() 실행! ");
        return chatDAO.getAdminChatList();
    }

	@Override
    public void adminSoftCloseRoom(int room_id) throws Exception {
		log.debug(" ChatServiceImpl: adminSoftCloseRoom() 실행! ");
        chatDAO.adminSoftCloseRoom(room_id);
        log.debug(" ChatServiceImpl: adminSoftCloseRoom() 실행! ");
    }

    @Override
    public List<ChatRoomVO> getAdminClosedChatList() throws Exception {
    	log.debug(" ChatServiceImpl: getAdminClosedChatList() 실행! ");
    	log.debug(" ChatServiceImpl: getAdminClosedChatList() 실행! ");
        return chatDAO.getAdminClosedChatList();
    }
}