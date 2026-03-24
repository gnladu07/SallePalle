package com.itwillbs.service;

import javax.inject.Inject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

@Service
public class ChatGPTService {
	
	private static final Logger log = LoggerFactory.getLogger(ChatGPTService.class);
	
	@Inject
	private ChatGPTClient gptClient;
	
	public String askChatGPT(String systemPrompt, String userPrompt) throws Exception{
		log.debug(" ChatGPTService: askChatGPT() 실행! ");
		
		String result = gptClient.sendChatGPT(systemPrompt, userPrompt);
		
		log.debug(" ChatGPTService: askChatGPT() 끝! ");
	    return result;
	}
}
