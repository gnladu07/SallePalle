package com.itwillbs.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.messaging.simp.config.MessageBrokerRegistry;
import org.springframework.web.socket.config.annotation.EnableWebSocketMessageBroker;
import org.springframework.web.socket.config.annotation.StompEndpointRegistry;
import org.springframework.web.socket.config.annotation.WebSocketMessageBrokerConfigurer;

@Configuration
@EnableWebSocketMessageBroker
public class WebSocketConfig implements WebSocketMessageBrokerConfigurer {

    @Override
    public void registerStompEndpoints(StompEndpointRegistry registry) {
        // 프론트엔드(jsp)에서 웹소켓에 접속할 때 사용할 엔드포인트 지정
        // ws://localhost:8088/ws-stomp 로 연결하게 됩니다.
        registry.addEndpoint("/ws-stomp")
                .setAllowedOrigins("*")
                .withSockJS(); // 브라우저가 웹소켓을 지원하지 않을 경우 대체 옵션(SockJS) 활성화
    }

    @Override
    public void configureMessageBroker(MessageBrokerRegistry registry) {
        // 메시지를 구독(수신)하는 요청 엔드포인트 (예: /sub/chat/room/1)
        registry.enableSimpleBroker("/sub");
        
        // 메시지를 발행(송신)하는 요청 엔드포인트 (예: /pub/chat/message)
        registry.setApplicationDestinationPrefixes("/pub");
    }
}