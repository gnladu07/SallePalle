package com.itwillbs.service;

import java.util.List;
import com.itwillbs.domain.ChatMessageVO;
import com.itwillbs.domain.ChatRoomVO;

public interface ChatService {
    // 채팅방 개설 (없으면 생성, 있으면 기존 방 번호 리턴)
    public int createOrGetRoom(int trade_id, int buyer_id, int seller_id);
    // 메시지 저장
    public void saveMessage(ChatMessageVO vo);
    // 특정 채팅방의 메시지 내역 불러오기
    public List<ChatMessageVO> getMessageHistory(int room_id);
    // 내 채팅방 목록 불러오기
    public List<ChatRoomVO> getMyChatRooms(int member_id);
    
    public ChatRoomVO getRoom(int room_id);
    
	public boolean executePayment(ChatRoomVO room);
	
	public void leaveChatRoom(int room_id) throws Exception;
	
    public void markMessagesAsRead(int room_id, int reader_id) throws Exception;
}