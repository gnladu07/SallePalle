package com.itwillbs.controller;

import java.security.Principal;
import java.util.List;

import javax.inject.Inject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.itwillbs.domain.SaleTradeVO;
import com.itwillbs.service.SaleTradeService;

@Controller
@RequestMapping("/traBoard/*")
public class SaleTradeController {
		
	private static final Logger log 
		= LoggerFactory.getLogger(SaleTradeController.class);

	@Inject private SaleTradeService stService; 
	
	@GetMapping("/saleTradeList")
	public String saleTradeListGET(@RequestParam(value = "type", required = false) String type,
	                               @RequestParam(value = "keyword", required = false) String keyword,
	                               @RequestParam(value = "item_ctg_id", required = false) Integer itemCtgId,
	                               Model model) {
		log.info(" saleTradeListGET() 실행! ");
		
		List<SaleTradeVO> list = stService.getSaleTradeList(type, keyword, itemCtgId);
	    model.addAttribute("saleTradeList", list);
	    model.addAttribute("item_ctg_id", itemCtgId);

	    log.info(" 조회 결과 수 = {}", list.size());
		log.info(" saleTradeListGET() 끝! ");
		return "/traBoard/saleTradeList";
	}
	
	@GetMapping("/detail")
	public String saleTradeDetailGET(@RequestParam("trade_id") int tradeId,
							         Model model,
							         Principal principal) {
	    log.info(" saleTradeDetailGET() 실행! trade_id={}", tradeId);

	    // 1. 판매글 상세 조회
	    SaleTradeVO detail = stService.getSaleTradeDetail(tradeId);
	    model.addAttribute("detail", detail);

	    // 2. 판매자의 다른 상품
	    List<SaleTradeVO> otherList =
	            stService.getOtherSaleTradeBySeller(detail.getSeller_id(), tradeId);
	    model.addAttribute("otherList", otherList);

	    // 3. 로그인 여부 전달
	    if (principal != null) {
	        model.addAttribute("loginUserid", principal.getName());
	    }

	    log.info(" saleTradeDetailGET() 끝!");
	    return "/traBoard/detail";
	}
	
	@PostMapping("/recommend")
	@ResponseBody
	public int recommend(@RequestParam("trade_id") int tradeId,
	                     Principal principal) {
		log.info(" recommend()실행! ");

	    if (principal == null) {
	        return -1; // NOT_LOGIN
	    }

	    String userid = principal.getName();
	    
	    // 추천 처리
	    int result = stService.recommendTrade(tradeId, userid);

	    log.info("추천 결과 반환값={}", result);
	    log.info(" recommend()끝! ");
	    return result;
	}
	
	@PostMapping("/buy")
	@ResponseBody
	public String buyTrade(@RequestParam int trade_id,
	                       @RequestParam boolean payPoint,
	                       @RequestParam boolean payMileage,
	                       @RequestParam(required=false) String mileageType,
	                       @RequestParam(required=false) Integer useMileage,
	                       Principal principal) {
		log.info(" buyTrade()실행! ");
	    log.info("trade_id={}", trade_id);

	    if(principal == null){
	        return "LOGIN_REQUIRED";
	    }

	    stService.buyTrade(trade_id, principal.getName(),
	                       payPoint, payMileage, mileageType, useMileage);

	    log.info(" buyTrade()끝! ");
	    return "SUCCESS";
	}

}
