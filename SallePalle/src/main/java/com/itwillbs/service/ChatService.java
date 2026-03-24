package com.itwillbs.service;

import java.util.List;
import com.itwillbs.domain.ChatMessageVO;
import com.itwillbs.domain.ChatRoomVO;

public interface ChatService {
	
    // 채팅방 개설
    public int createOrGetRoom(int trade_id, int buyer_id, int seller_id);
    
    // 채팅 메시지 DB 저장
    public void saveMessage(ChatMessageVO vo);
    
    // 특정 채팅방의 과거 메시지 내역 조회
    public List<ChatMessageVO> getMessageHistory(int room_id);
    
    // 로그인한 회원의 참여 중인 채팅방 목록 조회
    public List<ChatRoomVO> getMyChatRooms(int member_id);
    
    // 특정 채팅방의 상세 정보 조회
    public ChatRoomVO getRoom(int room_id);
    
    // 채팅방 내 물품 대금 결제 처리
    public boolean executePayment(ChatRoomVO room);
    
    // 채팅방 나가기
    public void leaveChatRoom(int room_id) throws Exception;
    
    // 채팅 메시지 읽음 처리
    public void markMessagesAsRead(int room_id, int reader_id) throws Exception;
    
    // 마이페이지용 회원의 전체 채팅 기록 로그 조회
    public List<ChatRoomVO> getChatHistoryLog(int member_id) throws Exception;
    
    // AI 안전결제 필터링: 위험 채팅방 감지 시 상태값(Flag) 변경
    public void flagChatRoom(int room_id) throws Exception;
    
    // [관리자] 전체 채팅방 모니터링 목록 조회 (위험 감지 방 최상단 정렬)
    public List<ChatRoomVO> getAdminChatList() throws Exception;

    // [관리자] 사기 의심 채팅방 강제 해산 처리
    public void adminSoftCloseRoom(int room_id) throws Exception;
    
    // [관리자] 강제 해산(폭파)된 채팅방 목록 및 증거 조회
    public List<ChatRoomVO> getAdminClosedChatList() throws Exception;
}