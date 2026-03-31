package com.itwillbs.persistence;

import java.util.List;
import java.util.Map;

import com.itwillbs.domain.ChatMessageVO;
import com.itwillbs.domain.ChatRoomVO;

public interface ChatDAO {
	
	// 채팅방 조회
    public int findRoom(int trade_id, int buyer_id);
    
    // 채팅방 생성
    public void createRoom(ChatRoomVO vo);
    
    // 채팅 메시지 저장
    public void insertMessage(ChatMessageVO vo);
    
    // 메시지 내역 조회
    public List<ChatMessageVO> getMessagesByRoomId(int room_id);
    
    // 참여 중인 전체 채팅방 목록 조회
    public List<ChatRoomVO> getRoomList(int member_id);
    
    // 채팅방의 상세 정보 조회
    public ChatRoomVO getRoom(int room_id);
    
    // 채팅방 메시지 삭제
	public void deleteChatMessages(int room_id) throws Exception;
	
	// 채팅방 삭제
	public void deleteChatRoom(int room_id) throws Exception;
	
	// 메시지 읽음 처리
    public void markMessagesAsRead(Map<String, Object> paramMap) throws Exception;
    
    // 채팅 참여 히스토리 로그 조회
    public List<ChatRoomVO> getChatHistoryLog(int member_id) throws Exception;
    
    // 관리자용 모니터링 상태값 없데이트(is_flagged = 'Y' 처리)
    public void flagChatRoom(int room_id) throws Exception;
    
    // 관리자용 채팅 리스트
    public List<ChatRoomVO> getAdminChatList(Map<String, Object> paramMap) throws Exception;
    
    // 관리자용 전체 채팅 개수 (페이징용)
    public int getTotalAdminChatCount(Map<String, Object> paramMap) throws Exception;
    
    // 관리자 채팅방 강제 해산 (소프트 딜리트)
    public void adminSoftCloseRoom(int room_id) throws Exception; 
    
    // 관리자 강제 해산된 채팅방 목록 조회
    public List<ChatRoomVO> getAdminClosedChatList() throws Exception; 
    
}