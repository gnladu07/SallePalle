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
import org.springframework.web.multipart.MultipartFile;

import com.itwillbs.component.FileComponent;
import com.itwillbs.domain.ChatMessageVO;
import com.itwillbs.domain.ChatRoomVO;
import com.itwillbs.domain.MemberVO;
import com.itwillbs.service.ChatGPTService;
import com.itwillbs.service.ChatService;

@Controller
public class ChatController {

    private static final Logger log = LoggerFactory.getLogger(ChatController.class);

    @Inject private ChatService chatService;
    @Inject private SimpMessagingTemplate messagingTemplate;
    @Inject private FileComponent fileComponent;
    @Inject private ChatGPTService gptService;
    
    @GetMapping("/chat/chatRoom")
    public String chatRoom(@RequestParam int room_id, Model model, HttpSession session) {
    	log.debug("ChatController: chatRoom() 실행!");
        MemberVO loginInfo = (MemberVO) session.getAttribute("loginInfo");
        if(loginInfo == null) return "redirect:/member/login";
        log.debug("ChatController: chatRoom() 실행!");
        return "/chat/chatRoom"; 
    }

    // 채팅방 개설
    @PostMapping("/chat/createRoom")
    @ResponseBody
    public int createRoom(@RequestParam int trade_id, @RequestParam int seller_id, HttpSession session) {
    	log.debug("ChatController: createRoom() 실행!");
        MemberVO loginInfo = (MemberVO) session.getAttribute("loginInfo");
        if (loginInfo == null) return -1;
        
        int buyer_id = loginInfo.getMember_id();
        log.debug("ChatController: createRoom() 끝!");
        return chatService.createOrGetRoom(trade_id, buyer_id, seller_id);
    }

    // 채팅 내역 조회
    @GetMapping("/chat/history")
    @ResponseBody
    public List<ChatMessageVO> getChatHistory(@RequestParam int room_id) {
    	log.debug("ChatController: getChatHistory() 실행!");
    	log.debug("ChatController: getChatHistory() 끝!");
        return chatService.getMessageHistory(room_id);
    }

    // 내 채팅 목록 페이지로 이동
    @GetMapping("/chat/list")
    public String chatList(HttpSession session, Model model) {
    	log.debug("ChatController: chatList() 실행!");
        MemberVO loginInfo = (MemberVO) session.getAttribute("loginInfo");
        if (loginInfo == null) return "redirect:/member/login";
        
        List<ChatRoomVO> roomList = chatService.getMyChatRooms(loginInfo.getMember_id());
        model.addAttribute("roomList", roomList);
        log.debug("ChatController: chatList() 끝!");
        return "/chat/chatList";
    }

    // WebSocket 메시지 수신 및 발신
    @MessageMapping("/chat/send")
    public void sendMessage(ChatMessageVO message) {
    	log.debug("ChatController: sendMessage() 실행!");
        log.info("수신된 채팅 메시지: {}", message);
        
        // 1. DB에 메시지 저장
        chatService.saveMessage(message);
        
        // 2. 해당 방(room_id)을 켜놓고 있는 사람들에게 메시지 쏴주기
        messagingTemplate.convertAndSend("/sub/chat/room/" + message.getRoom_id(), message);
        
        // 3. 채팅방 정보를 조회해서 누가 수신자인지 파악
        ChatRoomVO room = chatService.getRoom(message.getRoom_id());
        
        // 보낸 사람이 구매자면 수신자는 판매자, 보낸 사람이 판매자면 수신자는 구매자
        int receiverId = (message.getSender_id() == room.getBuyer_id()) ? room.getSeller_id() : room.getBuyer_id();
        
        // 4. 수신자의 개인 알림 채널로 메시지 발송!
        messagingTemplate.convertAndSend("/sub/notify/" + receiverId, message);
        
        // 5. ChatGPT를 이용한 외부 거래 유도 감지 필터링
        if ("TEXT".equals(message.getType())) {
            try {
                // 프롬프트
                String systemPrompt = "너는 중고거래 사이트 보안 감시관이야. "
                                    + "사용자의 채팅 메시지에 '현금', '계좌이체', '직거래', '카톡', '라인', '수수료 없는 거래' 등 "
                                    + "사이트 내 안전결제를 우회하려는 의도나 외부 연락처를 공유하려는 의도가 포함되어 있다면 오직 'TRUE', "
                                    + "일상적인 대화나 안전결제를 진행하려는 내용이라면 오직 'FALSE'만 출력해. 부가 설명은 절대 하지마.";

                String gptResponse = gptService.askChatGPT(systemPrompt, message.getMessage_text());
                
                if (gptResponse != null && gptResponse.contains("TRUE")) {
                    ChatMessageVO warningMsg = new ChatMessageVO();
                    warningMsg.setRoom_id(message.getRoom_id());
                    warningMsg.setSender_id(1); // 0번을 시스템 관리자용 ID로 사용
                    warningMsg.setType("SYSTEM");
                    warningMsg.setMessage_text("🚨 시스템 경고: 외부 메신저 유도 또는 직접 현금 거래 정황이 감지되었습니다. 당사 안전결제 외의 거래는 사기 피해의 위험이 있습니다.\n\n※ 추가로 동일한 발언을 할 경우 운영자가 즉시 호출되며, 채팅방이 강제로 종료될 수 있습니다.");
                    
                    chatService.saveMessage(warningMsg);
                    messagingTemplate.convertAndSend("/sub/chat/room/" + message.getRoom_id(), warningMsg);
                    
                    chatService.flagChatRoom(message.getRoom_id());
                }
            } catch (Exception e) {
                log.error("GPT 필터링 중 오류 발생: ", e);
            }
        }	
        log.debug("ChatController: sendMessage() 끝!");
    }
    
    @PostMapping("/chat/pay")
    @ResponseBody
    public String processChatPayment(@RequestParam int room_id, HttpSession session) {
    	log.debug("ChatController: processChatPayment() 실행!");
        MemberVO loginInfo = (MemberVO) session.getAttribute("loginInfo");
        if (loginInfo == null) return "NO_LOGIN";

        log.debug("ChatController: processChatPayment() 끝!");
        try {
            
            ChatRoomVO room = chatService.getRoom(room_id);
            
            
            if (room.getBuyer_id() != loginInfo.getMember_id()) {
                return "NOT_BUYER";
            }

            boolean success = chatService.executePayment(room);
            
            if (success) {
                ChatMessageVO paymentMsg = new ChatMessageVO();
                paymentMsg.setRoom_id(room_id);
                paymentMsg.setSender_id(loginInfo.getMember_id());
                paymentMsg.setMessage_text("💰 결제 및 송금이 완료되었습니다. (거래 완료)");
                paymentMsg.setType("SYSTEM");
                
                sendMessage(paymentMsg);
                
                return "OK";
            } else {
                return "INSUFFICIENT_POINTS";
            }
        } catch (Exception e) {
            log.error("결제 처리 중 오류 발생: ", e);
            return "ERROR";
        }
    }

    // 채팅방 나가기
    @PostMapping("/chat/leave")
    @ResponseBody
    public String leaveChatRoom(@RequestParam int room_id, HttpSession session) {
    	log.debug("ChatController: leaveChatRoom() 실행!");
        MemberVO loginInfo = (MemberVO) session.getAttribute("loginInfo");
        if (loginInfo == null) return "NO_LOGIN";
        log.debug("ChatController: leaveChatRoom() 끝!");
        try {
            // 서비스로 넘겨서 해당 방과 메시지 삭제 진행
            chatService.leaveChatRoom(room_id);
            return "OK";
        } catch (Exception e) {
            log.error("채팅방 나가기 오류: ", e);
            return "ERROR";
        }
    }
    
    // 채팅 읽음 처리 API
    @PostMapping("/chat/markAsRead")
    @ResponseBody
    public String markAsRead(@RequestParam int room_id, HttpSession session) {
    	log.debug("ChatController: markAsRead() 실행!");
        MemberVO loginInfo = (MemberVO) session.getAttribute("loginInfo");
        log.debug("ChatController: markAsRead() 끝!");
        if (loginInfo == null) return "NO_LOGIN";
        
        try {
            chatService.markMessagesAsRead(room_id, loginInfo.getMember_id());
            
            ChatMessageVO readNotice = new ChatMessageVO();
            readNotice.setRoom_id(room_id);
            readNotice.setSender_id(loginInfo.getMember_id());
            readNotice.setType("READ");
            
            messagingTemplate.convertAndSend("/sub/chat/room/" + room_id, readNotice);
            
            return "OK";
        } catch (Exception e) {
            log.error("읽음 처리 중 오류 발생: ", e);
            return "ERROR";
        }
    }
    
    // 마이페이지 - 내 전체 채팅 기록 리스트
    @GetMapping("/chat/historyList")
    public String chatHistoryList(HttpSession session, Model model) throws Exception {
    	log.debug("ChatController: chatHistoryList() 실행!");
        MemberVO loginInfo = (MemberVO) session.getAttribute("loginInfo");
        if (loginInfo == null) return "redirect:/member/login";
        
        List<ChatRoomVO> historyLog = chatService.getChatHistoryLog(loginInfo.getMember_id());
        model.addAttribute("historyLog", historyLog);
        log.debug("ChatController: chatHistoryList() 끝!");
        return "/chat/chatHistoryList"; 
    }
    
    // 채팅 파일 업로드
    @PostMapping("/chat/upload")
    @ResponseBody
    public String uploadChatFile(@RequestParam("file") MultipartFile file) {
        if (file.isEmpty()) return "FAIL";
        
        try {
            String savedFileName = fileComponent.upload(file);
            
            if (savedFileName != null) {
                return savedFileName;
            } else {
                return "FAIL";
            }
        } catch (Exception e) {
            log.error("채팅 파일 업로드 실패: ", e);
            return "FAIL";
        }
    }
    
    // 관리자 - 채팅방 강제 해산 API
    @PostMapping("/admin/chat/close")
    @ResponseBody
    public String adminCloseChat(@RequestParam int room_id, HttpSession session) {
        log.debug("ChatController: adminCloseChat() 실행!");
        MemberVO loginInfo = (MemberVO) session.getAttribute("loginInfo");
        
        if (loginInfo == null) return "NO_LOGIN";
        
        try {
            ChatMessageVO closeMsg = new ChatMessageVO();
            closeMsg.setRoom_id(room_id);
            closeMsg.setSender_id(1);
            closeMsg.setType("CLOSE");
            closeMsg.setMessage_text("🚨 관리자에 의해 채팅방이 강제 해산되었습니다. 사기 거래에 주의하세요.");
            
            messagingTemplate.convertAndSend("/sub/chat/room/" + room_id, closeMsg);
            
            Thread.sleep(500);
            
            chatService.adminSoftCloseRoom(room_id);
            
            return "OK";
        } catch (Exception e) {
            log.error("채팅방 강제 종료 중 오류: ", e);
            return "ERROR";
        }
    }
    
    
}