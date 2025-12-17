package com.itwillbs.controller;

import java.util.List;

import javax.inject.Inject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

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
	                               Model model) {
		log.info(" saleTradeListGET() 실행! ");
		log.info(" 검색 type = {}, keyword = {}", type, keyword);
		
		List<SaleTradeVO> list = stService.getSaleTradeList(type, keyword);
	    model.addAttribute("saleTradeList", list);
	    model.addAttribute("totalCount", list.size());

	    log.info(" 조회 결과 수 = {}", list.size());
		log.info(" saleTradeListGET() 끝! ");
		return "/traBoard/saleTradeList";
	}

}
