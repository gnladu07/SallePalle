package com.itwillbs.persistence;

import java.util.List;
import java.util.Map;

import com.itwillbs.domain.ChatMessageVO;
import com.itwillbs.domain.ChatRoomVO;

public interface ChatDAO {
    public int findRoom(int trade_id, int buyer_id);
    public void createRoom(ChatRoomVO vo);
    public void insertMessage(ChatMessageVO vo);
    public List<ChatMessageVO> getMessagesByRoomId(int room_id);
    public List<ChatRoomVO> getRoomList(int member_id);
    public ChatRoomVO getRoom(int room_id);
	public void deleteChatMessages(int room_id) throws Exception;
	public void deleteChatRoom(int room_id) throws Exception;
    public void markMessagesAsRead(Map<String, Object> paramMap) throws Exception;
    public List<ChatRoomVO> getChatHistoryLog(int member_id) throws Exception;
    public void flagChatRoom(int room_id) throws Exception;
    public List<ChatRoomVO> getAdminChatList() throws Exception; // 관리자용 채팅 리스트
}