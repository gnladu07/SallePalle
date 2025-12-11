package com.itwillbs.controller;

import java.util.List;

import javax.inject.Inject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.itwillbs.domain.SellerRequestVO;
import com.itwillbs.service.SellerService;

@Controller
@RequestMapping("/admin/*")
public class AdminController {
		
	private static final Logger log 
		= LoggerFactory.getLogger(AdminController.class);
	
	@Inject private SellerService sService;
	
	@GetMapping("/login")
	public void loginGET() {
		log.info(" loginGET() 실행!");
	}
	
	@GetMapping("/home")
    public String dashboard() {
		log.info(" dashboard() 실행! ");
        return "/admin/home";
    }
	
	// 판매 권한 신청 리스트
    @GetMapping("/sellerRequest")
    public String sellerRequestList(Model model) {

        List<SellerRequestVO> list = sService.getWaitingRequests();
        model.addAttribute("list", list);

        return "/admin/sellerRequest";
    }
    
    // 승인 처리
    @PostMapping("/seller/approve")
    public String approveSeller(int request_id, int member_id, 
    		                    RedirectAttributes rttr) {
        sService.approveRequest(request_id, member_id);
        rttr.addFlashAttribute("msgA", "판매 권한 승인 완료!");
        return "redirect:/admin/sellerRequest";
    }
    
    // 거절처리
    @PostMapping("/seller/reject")
    public String rejectSeller(int request_id, int member_id,
    		                   RedirectAttributes rttr) {
        sService.rejectRequest(request_id, member_id);
        rttr.addFlashAttribute("msgR", "거절 처리 완료!");
        return "redirect:/admin/sellerRequest";
    }


}
