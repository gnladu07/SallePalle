package com.itwillbs.controller;

import java.util.List;
import javax.inject.Inject;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.itwillbs.domain.ChatMessageVO;
import com.itwillbs.domain.ChatRoomVO;
import com.itwillbs.domain.MemberVO;
import com.itwillbs.service.ChatService;

@Controller
public class ChatController {

    private static final Logger log = LoggerFactory.getLogger(ChatController.class);

    @Inject private ChatService chatService;
    
    // 특정 브로커로 메시지를 전달해주는 스프링 객체
    @Inject private SimpMessagingTemplate messagingTemplate;
    
    // ChatController.java 내부
    @GetMapping("/chat/chatRoom")
    public String chatRoom(@RequestParam int room_id, Model model, HttpSession session) {
        MemberVO loginInfo = (MemberVO) session.getAttribute("loginInfo");
        if(loginInfo == null) return "redirect:/member/login";
        return "/chat/chatRoom"; 
    }

    // 1. 채팅방 개설 API (상세페이지에서 '채팅하기' 버튼 클릭 시 AJAX로 호출됨)
    @PostMapping("/chat/createRoom")
    @ResponseBody
    public int createRoom(@RequestParam int trade_id, @RequestParam int seller_id, HttpSession session) {
        MemberVO loginInfo = (MemberVO) session.getAttribute("loginInfo");
        if (loginInfo == null) return -1; // 비로그인 예외처리
        
        int buyer_id = loginInfo.getMember_id();
        return chatService.createOrGetRoom(trade_id, buyer_id, seller_id);
    }

    // 2. 채팅 내역 조회 API (채팅창 열었을 때 과거 메시지 불러오기)
    @GetMapping("/chat/history")
    @ResponseBody
    public List<ChatMessageVO> getChatHistory(@RequestParam int room_id) {
        return chatService.getMessageHistory(room_id);
    }

    // 3. 내 채팅 목록 페이지로 이동
    @GetMapping("/chat/list")
    public String chatList(HttpSession session, Model model) {
        MemberVO loginInfo = (MemberVO) session.getAttribute("loginInfo");
        if (loginInfo == null) return "redirect:/member/login";
        
        List<ChatRoomVO> roomList = chatService.getMyChatRooms(loginInfo.getMember_id());
        model.addAttribute("roomList", roomList);
        
        return "/chat/chatList"; // 나중에 만들 JSP 화면
    }

    // 4. WebSocket (STOMP) 메시지 수신 및 발신
    // 프론트에서 "/pub/chat/send" 로 메시지를 보내면 이 메서드가 실행됨
    @MessageMapping("/chat/send")
    public void sendMessage(ChatMessageVO message) {
        log.info("수신된 채팅 메시지: {}", message);
        
        // 1. DB에 메시지 저장
        chatService.saveMessage(message);
        
        // 2. 해당 방(room_id)을 켜놓고 있는 사람들에게 메시지 쏴주기
        messagingTemplate.convertAndSend("/sub/chat/room/" + message.getRoom_id(), message);
        
        // --- [추가된 알림 로직] ---
        // 3. 채팅방 정보를 조회해서 누가 수신자인지 파악
        ChatRoomVO room = chatService.getRoom(message.getRoom_id());
        
        // 보낸 사람이 구매자면 수신자는 판매자, 보낸 사람이 판매자면 수신자는 구매자
        int receiverId = (message.getSender_id() == room.getBuyer_id()) ? room.getSeller_id() : room.getBuyer_id();
        
        // 4. 수신자의 개인 알림 채널로 메시지 발송!
        messagingTemplate.convertAndSend("/sub/notify/" + receiverId, message);
    }
    
 // ChatController.java 내부 추가

    @PostMapping("/chat/pay")
    @ResponseBody
    public String processChatPayment(@RequestParam int room_id, HttpSession session) {
        MemberVO loginInfo = (MemberVO) session.getAttribute("loginInfo");
        if (loginInfo == null) return "NO_LOGIN";

        try {
            // 채팅방 정보를 가져와서 거래 대상(상품, 판매자, 구매자) 파악
            ChatRoomVO room = chatService.getRoom(room_id);
            
            // 본인이 구매자인지 확인
            if (room.getBuyer_id() != loginInfo.getMember_id()) {
                return "NOT_BUYER";
            }

            // 기존 SaleTradeService의 buyTrade 로직을 호출하거나 
            // 채팅 전용 결제 서비스 로직을 실행 (아래 ChatService에 구현)
            boolean success = chatService.executePayment(room);
            
            if (success) {
                // 결제 완료 메시지를 웹소켓으로 전송 (상대방에게도 알림)
                ChatMessageVO paymentMsg = new ChatMessageVO();
                paymentMsg.setRoom_id(room_id);
                paymentMsg.setSender_id(loginInfo.getMember_id());
                paymentMsg.setMessage_text("💰 결제 및 송금이 완료되었습니다. (거래 완료)");
                paymentMsg.setType("SYSTEM"); // 시스템 메시지 타입
                
                sendMessage(paymentMsg); // 기존의 sendMessage 메서드 활용
                
                return "OK";
            } else {
                return "INSUFFICIENT_POINTS";
            }
        } catch (Exception e) {
            log.error("결제 처리 중 오류 발생: ", e);
            return "ERROR";
        }
    }

    // 채팅방 나가기 (방 및 메시지 삭제)
    @PostMapping("/chat/leave")
    @ResponseBody
    public String leaveChatRoom(@RequestParam int room_id, HttpSession session) {
        MemberVO loginInfo = (MemberVO) session.getAttribute("loginInfo");
        if (loginInfo == null) return "NO_LOGIN";

        try {
            // 서비스로 넘겨서 해당 방과 메시지 삭제 진행
            chatService.leaveChatRoom(room_id);
            return "OK";
        } catch (Exception e) {
            log.error("채팅방 나가기 오류: ", e);
            return "ERROR";
        }
    }
    
    
}