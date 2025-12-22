package com.itwillbs.controller;

import java.security.Principal;
import java.util.List;

import javax.inject.Inject;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.itwillbs.component.FileComponent;
import com.itwillbs.domain.MemberVO;
import com.itwillbs.domain.SaleTradeVO;
import com.itwillbs.service.ItemCategoryService;
import com.itwillbs.service.SaleTradeService;
import com.itwillbs.service.TopLocationService;

@Controller
@RequestMapping("/traBoard/*")
public class SaleTradeController {
		
	private static final Logger log 
		= LoggerFactory.getLogger(SaleTradeController.class);

	@Inject private SaleTradeService stService; 
	@Inject private TopLocationService tlService;
	@Inject private ItemCategoryService icService;
	@Inject private FileComponent fComponent;
	
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
	public String saleTradeDetailGET(@RequestParam("trade_id") Integer tradeId,
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

	    if (principal == null) {
	        return "LOGIN_REQUIRED";
	    }

	    try {
	        stService.buyTrade(
	            trade_id,
	            principal.getName(),
	            payPoint,
	            payMileage,
	            mileageType,
	            useMileage
	        );
	        log.info(" buyTrade()끝! ");
	        return "SUCCESS";

	    } catch (IllegalStateException e) {
	        if ("NOT_ENOUGH_POINT".equals(e.getMessage())) {
	            return "NOT_ENOUGH_POINT";
	        }
	        throw e;
	    }
	}
	
	@GetMapping("/write")
	public String writeGET(HttpSession session, Model model) {
		log.info(" writeGET() 실행!");
	    MemberVO loginInfo = (MemberVO) session.getAttribute("loginInfo");

	    if (loginInfo == null || !"Y".equals(loginInfo.getSeller_status())) {
	        return "redirect:/traBoard/saleTradeList";
	    }

	    model.addAttribute("topLocationList", tlService.getTopLocationList());
	    model.addAttribute("itemCategoryList", icService.getItemCategoryList());

	    log.info(" writeGET() 끝!");
	    return "/traBoard/write";
	}
	
	@PostMapping("/write")
	public String writePOST(SaleTradeVO vo,
					        MultipartFile thumbFile,
					        HttpSession session) {
		log.info(" writePOST() 실행!");
	    MemberVO loginInfo = (MemberVO) session.getAttribute("loginInfo");

	    if (loginInfo == null || !"Y".equals(loginInfo.getSeller_status())) {
	        return "redirect:/traBoard/saleTradeList";
	    }

	    vo.setSeller_id(loginInfo.getMember_id());

	    // 수량 기본값 보정
	    if (vo.getQuantity() <= 0) {
	        vo.setQuantity(1);
	    }

	    // 마일리지 전액 허용 기본값
	    if (vo.getAllow_full_mileage() == null) {
	        vo.setAllow_full_mileage("N");
	    }

	    // 썸네일 업로드
	    if (thumbFile != null && !thumbFile.isEmpty()) {
	        String savedName = fComponent.upload(thumbFile);
	        vo.setThumb_img(savedName);
	    }

	    stService.writeSaleTrade(vo);

	    log.info(" writePOST() 끝!");
	    return "redirect:/traBoard/saleTradeList";
	}
	
	@GetMapping("/update")
	public String updateSaleTradeGET(@RequestParam("trade_id") Integer tradeId,
	                                 Model model,
	                                 Principal principal) {
		log.info(" updateSaleTradeGET() 실행!");
	    SaleTradeVO detail = stService.getSaleTradeDetail(tradeId);

	    /* ===== 판매자 본인 검증 (중요) ===== */
	    if (principal == null || 
	        !principal.getName().equals(detail.getSeller_userid())) {
	        throw new AccessDeniedException("수정 권한 없음");
	    }

	    model.addAttribute("detail", detail);
	    model.addAttribute("topLocationList", tlService.getTopLocationList());
	    log.info(" updateSaleTradeGET() 끝!");
	    return "/traBoard/update";
	}
	
	@PostMapping("/update")
	public String updateSaleTradePOST(SaleTradeVO vo,
	                                  @RequestParam(required = false) MultipartFile thumbFile,
	                                  Principal principal) {
		log.info(" updateSaleTradePOST() 실행!");
	    SaleTradeVO origin = stService.getSaleTradeDetail(vo.getTrade_id());

	    /* ===== 판매자 본인 검증 (중요) ===== */
	    if (principal == null ||
	        !principal.getName().equals(origin.getSeller_userid())) {
	        throw new AccessDeniedException("수정 권한 없음");
	    }

	    stService.updateSaleTrade(vo, thumbFile, origin);

	    log.info(" updateSaleTradePOST() 끝!");
	    return "redirect:/traBoard/detail?trade_id=" + vo.getTrade_id();
	}
	
	@PostMapping("/delete")
	public String deleteSaleTradePOST(@RequestParam("trade_id") Integer tradeId,
	                                  Principal principal) {
		log.info(" deleteSaleTradePOST() 실행!");
	    if(principal == null){
	        throw new AccessDeniedException("로그인 필요");
	    }

	    SaleTradeVO origin = stService.getSaleTradeDetail(tradeId);

	    /* 판매자 본인 검증 */
	    if(!principal.getName().equals(origin.getSeller_userid())){
	        throw new AccessDeniedException("삭제 권한 없음");
	    }

	    stService.deleteSaleTrade(origin);

	    log.info(" deleteSaleTradePOST() 끝!");
	    return "redirect:/traBoard/saleTradeList";
	}
}
