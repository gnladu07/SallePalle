package com.itwillbs.service;

import java.util.List;
import javax.inject.Inject;
import org.springframework.stereotype.Service;
import com.itwillbs.domain.ChatMessageVO;
import com.itwillbs.domain.ChatRoomVO;
import com.itwillbs.persistence.ChatDAO;

@Service
public class ChatServiceImpl implements ChatService {

    @Inject private ChatDAO chatDAO;

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
}