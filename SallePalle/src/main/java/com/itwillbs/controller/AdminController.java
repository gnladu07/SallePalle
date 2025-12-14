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
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.itwillbs.domain.Criteria;
import com.itwillbs.domain.MemberVO;
import com.itwillbs.domain.PageVO;
import com.itwillbs.domain.SellerRequestVO;
import com.itwillbs.service.AdminService;
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
	
	@GetMapping("/login")
	public void loginGET() {
		log.info(" loginGET() 실행!");
		log.info(" loginGET() 끝!");
	}
	
	@GetMapping("/home")
    public String dashboard(Model model) {
		log.info(" dashboard() 실행! ");
		
		int list = aService.getTotalCount();
		model.addAttribute("listsize", list);
		
		int slist = aService.getSellerCount();
		model.addAttribute("slistsize", slist);
		
		log.info(" dashboard() 끝! ");
        return "/admin/home";
    }
	
	// 판매 권한 신청 리스트
    @GetMapping("/sellerRequest")
    public String sellerRequestList(Model model) {
    	log.info(" sellerRequestList() 실행! ");

        List<SellerRequestVO> list = sService.getWaitingRequests();
        model.addAttribute("list", list);

        log.info(" sellerRequestList() 끝! ");
        return "/admin/sellerRequest";
    }
    
    // 승인 처리
    @PostMapping("/seller/approve")
    public String approveSeller(int request_id, int member_id, 
    		                    RedirectAttributes rttr) {
    	log.info(" approveSeller() 실행! ");
        sService.approveRequest(request_id, member_id);
        rttr.addFlashAttribute("msgA", "판매 권한 승인 완료!");
        log.info(" approveSeller() 끝! ");
        return "redirect:/admin/sellerRequest";
    }
    
    // 거절처리
    @PostMapping("/seller/reject")
    public String rejectSeller(int request_id, int member_id,
    		                   RedirectAttributes rttr) {
    	log.info(" rejectSeller() 실행! ");
        sService.rejectRequest(request_id, member_id);
        rttr.addFlashAttribute("msgR", "거절 처리 완료!");
        log.info(" rejectSeller() 끝! ");
        return "redirect:/admin/sellerRequest";
    }
    
    // 회원 리스트 페이지
//    @GetMapping("/members")
//    public String membersPage(Model model) {
//    	log.info(" membersPage() 실행! ");
//
//        List<MemberVO> list = mService.getMemberList();
//        model.addAttribute("memberList", list);
//
//        log.info(" membersPage() 끝! ");
//        return "/admin/members";
//    }
    
    // 회원 정지
    @PostMapping("/disableMember")
    public String disableMember(int member_id) {
    	log.info(" disableMember() 실행! ");
    	
        mService.disableMember(member_id); // enable_flag = 0

        log.info(" disableMember() 끝! ");
        return "redirect:/admin/members";
    }
    
    // 정지 해제 
    @PostMapping("/enableMember")
    public String enableMember(int member_id) {
    	log.info(" enableMember() 실행! ");
    	
    	mService.enableMember(member_id); // 추가된 기능

    	log.info(" enableMember() 끝! ");
        return "redirect:/admin/members";
    }
    
    // 회원 삭제
    @PostMapping("/deleteMember")
    public String deleteMember(int member_id) {
    	log.info(" deleteMember() 실행! ");

        mService.deleteMember(member_id);

        log.info(" deleteMember() 끝! ");
        return "redirect:/admin/members";
    }
    
    // 정렬 기준에 따라 회원 리스트 출력
    @GetMapping("/members")
    public String memberList(Model model,
                             Criteria cri) {
    	log.info(" memberList() 실행! ");
    	
    	// sort 없으면 기본값 regdate
        if (cri.getSort() == null || cri.getSort().equals("")) {
            cri.setSort("regdate");
        }

        List<MemberVO> list = aService.getMemberListPaged(cri);

//        int total = aService.getTotalCount();
        int total = aService.getTotalCountFiltered(cri);  // 검색 조건 포함된 total
        PageVO pageDTO = new PageVO(cri, total);

        model.addAttribute("memberList", list);
        model.addAttribute("pageMaker", pageDTO);

        log.info(" memberList() 끝! ");
        return "/admin/members";
    }


}
