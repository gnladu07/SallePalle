package com.itwillbs.controller;

import javax.inject.Inject;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.itwillbs.domain.MemberVO;
import com.itwillbs.service.MemberService;

@Controller
@RequestMapping("/member")
public class MemberSessionController {

    @Inject
    private MemberService memberService;

    @PostMapping("/refreshSession")
    @ResponseBody
    public String refreshSession(HttpSession session) {

        MemberVO loginInfo = (MemberVO) session.getAttribute("loginInfo");

        if (loginInfo == null) {
            return "NO_SESSION";
        }

        MemberVO fresh =
            memberService.getMemberById(loginInfo.getMember_id());

        session.setAttribute("loginInfo", fresh);

        return "OK";
    }
}
