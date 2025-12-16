package com.itwillbs.controller;

import java.util.List;

import javax.inject.Inject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.itwillbs.domain.SaleTradeVO;
import com.itwillbs.service.SaleTradeService;

@Controller
@RequestMapping("/traBoard/*")
public class SaleTradeController {
		
	private static final Logger log 
		= LoggerFactory.getLogger(SaleTradeController.class);

	@Inject private SaleTradeService stService; 
	
	@GetMapping("/saleTradeList")
	public String saleTradeListGET(Model model) {
		log.info(" saleTradeListGET() 실행! ");
		
		List<SaleTradeVO> list = stService.getSaleTradeList();
		model.addAttribute("saleTradeList", list);
		
		log.info(" saleTradeListGET() 끝! ");
		return "/traBoard/saleTradeList";
	}

}
