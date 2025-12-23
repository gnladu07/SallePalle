package com.itwillbs.controller;

import javax.inject.Inject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.itwillbs.service.ChatGPTService;

@Controller
public class ChatGPTController {
	
	private static final Logger logger = LoggerFactory.getLogger(ChatGPTController.class);
	
	@Inject
	private ChatGPTService gptService;
	
	@RequestMapping(
		    value = "/traBoard/gpt/description",
		    method = RequestMethod.POST,
		    produces = "text/plain; charset=UTF-8"
		)
		@ResponseBody
		public String generateTradeDescription(
		        @RequestParam("content") String content
		) throws Exception {

		    String systemPrompt =
		    		"너는 중고 거래 플랫폼의 판매글 작성 도우미다. "
				  + "사용자가 말하듯 입력한 문장을 분석해서 "
				  + "중고 거래 게시글에 어울리는 자연스러운 판매글로 바꿔줘."

				  + "[작성 규칙]"
				  + "- 말투는 너무 딱딱하지 않게, 신뢰감 있는 중고 거래 톤"
				  + "- 가격, 사용 기간, 제품 정보는 자연스럽게 녹여서 표현"
				  + "- 이모지는 1~3개 정도만 사용"
				  + "- 광고 문구, 과장 표현 금지"

				  + "[중요 규칙]"
				  + "- 반드시 마지막 문장은 구매 유도 멘트로 끝내야 한다"
				  + "- 마지막 문장은 아래 예시와 유사한 형태 중 하나로 작성한다"

				  + "[구매 유도 문장 예시]"
				  + "• 관심 있으시면 구매 꼭 부탁 드려요 🙂"
				  + "• 빠른 거래 원하시면 지금바로 구매 버튼 눌러 주세요 🙌"

				  + "- 결과는 설명 없이 완성된 판매글만 출력한다.";

		    return gptService.askChatGPT(systemPrompt, content);
		}
	
}
