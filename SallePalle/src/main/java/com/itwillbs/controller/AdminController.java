package com.itwillbs.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.itwillbs.domain.ChatRoomVO;
import com.itwillbs.domain.Criteria;
import com.itwillbs.domain.MemberVO;
import com.itwillbs.domain.PageVO;
import com.itwillbs.domain.SellerRequestVO;
import com.itwillbs.service.AdminService;
import com.itwillbs.service.ChatGPTService;
import com.itwillbs.service.ChatService;
import com.itwillbs.service.MemberService;
import com.itwillbs.service.SellerService;

@Controller
@RequestMapping("/admin/*")
public class AdminController {
		
	private static final Logger log 
		= LoggerFactory.getLogger(AdminController.class);
	
	@Inject private SellerService sService;
	@Inject private MemberService mService;
	@Inject private AdminService aService;
	@Inject private ChatService chatService;
	
	@GetMapping("/login")
	public void loginGET() {
		log.debug(" AdminController: loginGET() 실행!");
		log.debug(" AdminController: loginGET() 끝!");
	}
	
	@GetMapping("/home")
    public String dashboard(Model model) {
		log.debug(" AdminController: dashboard() 실행! ");
		
		int list = aService.getTotalCount();
		model.addAttribute("listsize", list);
		
		int slist = aService.getSellerCount();
		model.addAttribute("slistsize", slist);
		
		log.debug(" AdminController: dashboard() 끝! ");
        return "/admin/home";
    }
	
	@GetMapping("/sellerPendingCount")
	@ResponseBody
	public Map<String, Object> sellerPendingCount() {
		log.debug(" AdminController: sellerPendingCount() 실행!");
	    Map<String, Object> map = new HashMap<>();
	    int cnt = aService.getSellerCount();
	    map.put("count", cnt);
	    log.debug(" AdminController: sellerPendingCount() 끝!");
	    return map;
	}
	
	@GetMapping("/memberPendingCount")
	@ResponseBody
	public Map<String, Object> memberPendingCount() {
		log.debug(" AdminController: memberPendingCount() 실행!");
		Map<String, Object> map = new HashMap<>();
		int cnt = aService.getTotalCount();
		map.put("count", cnt);
		log.debug(" AdminController: memberPendingCount() 끝!");
		return map;
	}
	
	// 판매 권한 신청 리스트
    @GetMapping("/sellerRequest")
    public String sellerRequestList(Model model) {
    	log.debug(" AdminController: sellerRequestList() 실행! ");

        List<SellerRequestVO> list = sService.getWaitingRequests();
        model.addAttribute("list", list);

        log.debug(" AdminController: sellerRequestList() 끝! ");
        return "/admin/sellerRequest";
    }
    
    // 승인 처리
    @PostMapping("/seller/approve")
    public String approveSeller(int request_id, int member_id, 
    		                    RedirectAttributes rttr) {
    	log.debug(" AdminController: approveSeller() 실행! ");
        sService.approveRequest(request_id, member_id);
        rttr.addFlashAttribute("msgA", "판매 권한 승인 완료!");
        log.debug(" AdminController: approveSeller() 끝! ");
        return "redirect:/admin/sellerRequest";
    }
    
    // 거절처리
    @PostMapping("/seller/reject")
    public String rejectSeller(int request_id, int member_id,
    		                   RedirectAttributes rttr) {
    	log.debug(" AdminController: rejectSeller() 실행! ");
        sService.rejectRequest(request_id, member_id);
        rttr.addFlashAttribute("msgR", "거절 처리 완료!");
        log.debug(" AdminController: rejectSeller() 끝! ");
        return "redirect:/admin/sellerRequest";
    }
    
    // 회원 정지
    @PostMapping("/disableMember")
    public String disableMember(int member_id) {
    	log.debug(" AdminController: disableMember() 실행! ");
    	
        mService.disableMember(member_id); // enable_flag = 0

        log.debug(" AdminController: disableMember() 끝! ");
        return "redirect:/admin/members";
    }
    
    // 정지 해제 
    @PostMapping("/enableMember")
    public String enableMember(int member_id) {
    	log.debug(" AdminController: enableMember() 실행! ");
    	
    	mService.enableMember(member_id); // 추가된 기능

    	log.debug(" AdminController: enableMember() 끝! ");
        return "redirect:/admin/members";
    }
    
    // 회원 삭제
    @PostMapping("/deleteMember")
    public String deleteMember(int member_id) {
    	log.debug(" AdminController: deleteMember() 실행! ");

        mService.deleteMember(member_id);

        log.debug(" AdminController: deleteMember() 끝! ");
        return "redirect:/admin/members";
    }
    
    // 정렬 기준에 따라 회원 리스트 출력
    @GetMapping("/members")
    public String memberList(Model model,
                             Criteria cri) {
    	log.debug(" AdminController: memberList() 실행! ");
    	
        if (cri.getSort() == null || cri.getSort().equals("")) {
            cri.setSort("regdate");
        }

        List<MemberVO> list = aService.getMemberListPaged(cri);

        int total = aService.getTotalCountFiltered(cri);
        PageVO pageDTO = new PageVO(cri, total);

        model.addAttribute("memberList", list);
        model.addAttribute("pageMaker", pageDTO);

        log.debug(" AdminController: memberList() 끝! ");
        return "/admin/members";
    }
    
    // 관리자 - 채팅 모니터링 페이지
    @GetMapping("/chatList")
    public String adminChatList(
            Criteria cri,
            @RequestParam(required = false, defaultValue = "regdate") String sort,
            Model model) throws Exception {
        
        log.debug(" AdminController: adminChatList() 실행! ");
        
        Map<String, Object> paramMap = new HashMap<>();
        paramMap.put("type", cri.getType());
        paramMap.put("keyword", cri.getKeyword());
        paramMap.put("sort", sort);
        paramMap.put("pageStart", cri.getPageStart());
        paramMap.put("amount", cri.getAmount());
        
        List<ChatRoomVO> adminChatList = chatService.getAdminChatList(paramMap);
        int total = chatService.getTotalAdminChatCount(paramMap);
        
        PageVO pageDTO = new PageVO(cri, total);
        
        model.addAttribute("chatList", adminChatList);
        model.addAttribute("pageMaker", pageDTO);
        
        log.debug(" AdminController: adminChatList() 끝! ");
        return "/admin/chatList";
    }
    
    // 대시보드 실시간 카운트 갱신 (물품 수)
    @GetMapping("/dashboardCounts")
    @ResponseBody
    public Map<String, Object> getDashboardCounts() throws Exception {
        log.debug(" AdminController: getDashboardCounts() 실행! ");
        
        Map<String, Object> map = new HashMap<>();
        
        int productCount = aService.getTotalProductCount();
        int activeChatCount = aService.getActiveChatRoomCount();
        
        map.put("productCount", productCount);
        map.put("activeChatCount", activeChatCount);
        
        log.debug(" AdminController: getDashboardCounts() 끝! ");
        return map;
    }
    
    // 중고 물품 관리 페이지 (리스트 출력)
    @GetMapping("/goodsManagement")
    public String getGoodsManagement(
    		Criteria cri,
            @RequestParam(required = false) String type,
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false, defaultValue = "regdate") String sort,
            Model model) throws Exception {
        
        log.debug(" AdminController: getGoodsManagement() 실행! ");
        
        // 검색/정렬 데이터를 Map에 담아서 전달
        Map<String, Object> paramMap = new HashMap<>();
        paramMap.put("type", type);
        paramMap.put("keyword", keyword);
        paramMap.put("sort", sort);
        paramMap.put("pageStart", cri.getPageStart());
        paramMap.put("amount", cri.getAmount());
        
        List<Map<String, Object>> goodsList = aService.getAdminGoodsList(paramMap);
        int total = aService.getTotalGoodsCount(paramMap);
        
        PageVO pageDTO = new PageVO(cri, total);
        
        model.addAttribute("goodsList", goodsList);
        model.addAttribute("pageMaker", pageDTO);
        
        log.debug(" AdminController: getGoodsManagement() 끝! ");
        return "/admin/goodsManagement";
    }

    // 관리자 - 물품 상태 변경 (모달창 폼 제출 처리)
    @PostMapping("/updateGoodsStatus")
    public String updateGoodsStatus(
            @RequestParam int trade_id,
            @RequestParam String actionType,
            @RequestParam String reason,
            @RequestParam String seller_email,
            RedirectAttributes rttr) throws Exception {
        
        log.debug(" AdminController: updateGoodsStatus() 실행! ");
        
        // 상태 업데이트 및 메일 발송 서비스 호출
        aService.adminUpdateGoodsStatus(trade_id, actionType, reason, seller_email);
        
        rttr.addFlashAttribute("msg", "SUCCESS"); // 처리 완료 알림용
        
        return "redirect:/admin/goodsManagement";
    }


}
