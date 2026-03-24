package com.itwillbs.service;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.UUID;

import javax.inject.Inject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.itwillbs.component.FileComponent;
import com.itwillbs.component.MailComponent;
import com.itwillbs.domain.Criteria;
import com.itwillbs.domain.MemberAuthVO;
import com.itwillbs.domain.MemberHistoryVO;
import com.itwillbs.domain.MemberVO;
import com.itwillbs.domain.PageVO;
import com.itwillbs.domain.PasswordResetTokenVO;
import com.itwillbs.domain.PaymentHistoryVO;
import com.itwillbs.domain.TradeHistoryViewVO;
import com.itwillbs.persistence.MemberDAO;

@Service
public class MemberServiceImpl implements MemberService {

	private static final Logger logger 
		= LoggerFactory.getLogger(MemberServiceImpl.class);
	
	@Inject private MemberDAO memberDAO;
	@Inject private PasswordEncoder pwEncoder;
	@Inject private MailComponent mailComponent;
	@Inject private FileComponent fileComponent;

	@Override
	public MemberVO selectOne(String userid) {
		logger.debug(" MServiceImpl: selectOne() 실행! ");
		
		MemberVO resultInfo 
			= memberDAO.selectOne(userid);
		
		if(resultInfo != null) {
			logger.debug(" MServiceImpl: selectOne() 결과 seller_status = [" + resultInfo.getSeller_status() + "]");
			logger.debug(" 문자열 길이 = " + (resultInfo.getSeller_status() == null ? "null" : resultInfo.getSeller_status().length()));
	    } else {
	    	logger.debug(" MServiceImpl: selectOne() 결과가 NULL 입니다.");
	    }
		
		logger.debug(" MServiceImpl: selectOne() 끝! ");
		return resultInfo;
	}

	@Override
	public void memberJoin(MemberVO vo) {
		logger.debug(" MServiceImpl: memberJoin() 실행! ");
		
	    if (vo.getUserpw() == null || vo.getUserpw().trim().equals("")) {
	        throw new IllegalArgumentException("비밀번호는 반드시 입력되어야 합니다.");
	    }
	    vo.setUserpw(pwEncoder.encode(vo.getUserpw()));

	    if (vo.getMobile() != null && vo.getMobile().trim().equals("")) {
	        vo.setMobile(null);
	    }

	    if (vo.getBirth6() != null && !vo.getBirth6().matches("^[0-9]{6}$")) {
	        vo.setBirth6(null);
	    }

	    memberDAO.insertMember(vo);

	    MemberAuthVO auth = new MemberAuthVO();
	    auth.setUserid(vo.getUserid());
	    auth.setAuth("ROLE_MEMBER");
	    memberDAO.insertAuth(auth);
		
		logger.debug(" MServiceImpl: memberJoin() 끝! ");
	}
	
	@Override
	public boolean isUseridExists(String userid) {
		logger.debug(" MServiceImpl: isUseridExists()실행! ");
		logger.debug(" MServiceImpl: isUseridExists()끝! ");
	    return memberDAO.countUserid(userid) > 0;
	}

	@Override
	public int emailSendCode(String email) {
		logger.debug(" MServiceImpl: emailSendCode() 실행! ");
		
		int code = (int) ((Math.random()*900000) + 100000);
		mailComponent.sendMassage(email, "살래팔래 인증번호", "인증번호: "+code);
		
		logger.debug(" MServiceImpl: emailSendCode() 끝! ");
		return code;
	}

	@Override
	public void changeProfileImage(String userid, MultipartFile file) {
		logger.debug(" MServiceImpl: changeProfileImage() 실행! ");
		
		if (file.isEmpty()) return;
		
		MemberVO current = memberDAO.selectOne(userid);
		String newFileName = fileComponent.upload(file);
		String oldFile = current.getProfile_img();
		if (oldFile != null && !oldFile.equals("default_profile.png")) {
			fileComponent.deleteFile(oldFile);
		}
		
		MemberVO vo = new MemberVO();
		vo.setUserid(userid);
		vo.setProfile_img(newFileName);
		
		memberDAO.updateProfileImg(vo);
		logger.debug(" MServiceImpl: changeProfileImage() 끝! ");		
	}

	@Override
	public void resetProfileImage(String userid) {
		logger.debug(" MServiceImpl: resetProfileImage() 실행! ");
		
        MemberVO current = memberDAO.selectOne(userid);
        String oldImg = current.getProfile_img();
        
        memberDAO.updateProfileToDefault(userid);
        if (oldImg != null && !oldImg.equals("default_profile.png")) {
            fileComponent.deleteFile(oldImg);
        }
		
		logger.debug(" MServiceImpl: resetProfileImage() 끝! ");
	}

	@Override
	public void updateMemberWithHistory(MemberVO vo) {
		logger.debug(" MServiceImpl: resetProfileImage() 실행! ");
		
		MemberVO old = memberDAO.selectOne(vo.getUserid());
		
		// nickname 변경 기록
		if (!old.getNickname().equals(vo.getNickname())) {
			memberDAO.insertMemberHistory(new MemberHistoryVO(
					vo.getUserid(), 
					"nickname", 
					old.getNickname(), 
					vo.getNickname(), 
					vo.getUserid()
			));
		}
		
        // 지역 변경 기록
		if (!Objects.equals(old.getToplct_id(), vo.getToplct_id())) {
            memberDAO.insertMemberHistory(new MemberHistoryVO(
                vo.getUserid(),
                "toplct_id",
                String.valueOf(old.getToplct_id()),
                String.valueOf(vo.getToplct_id()),
                vo.getUserid()
            ));
        }
		
		// 기본 주소 변경 기록
        if (old.getAddress() != null && !old.getAddress().equals(vo.getAddress())) {
            memberDAO.insertMemberHistory(new MemberHistoryVO(
                vo.getUserid(),
                "address",
                old.getAddress(),
                vo.getAddress(),
                vo.getUserid()
            ));
        }

        // 상세주소 변경 기록
        if (!old.getDetail_address().equals(vo.getDetail_address())) {
            memberDAO.insertMemberHistory(new MemberHistoryVO(
                vo.getUserid(),
                "detail_address",
                old.getDetail_address(),
                vo.getDetail_address(),
                vo.getUserid()
            ));
        }

        // 이메일 변경 기록
        if (!old.getEmail().equals(vo.getEmail())) {
            memberDAO.insertMemberHistory(new MemberHistoryVO(
                vo.getUserid(),
                "email",
                old.getEmail(),
                vo.getEmail(),
                vo.getUserid()
            ));
        }

        // 실제 DB 업데이트 호출
        memberDAO.updateMember(vo);
		
		logger.debug(" MServiceImpl: resetProfileImage() 끝! ");
	}

	@Override
	public void rollbackMemberInfo(String userid) {
		logger.debug(" MServiceImpl: rollbackMemberInfo() 실행! ");
		
		memberDAO.rollbackMemberInfo(userid);
		
		logger.debug(" MServiceImpl: rollbackMemberInfo() 끝! ");
	}

	@Override
	public boolean checkPassword(String userid, String userpw) {
		logger.debug(" MServiceImpl: checkPassword() 실행! ");
		
		MemberVO vo = memberDAO.selectOne(userid);
		
		logger.debug(" MServiceImpl: checkPassword() 끝! ");
		return pwEncoder.matches(userpw, vo.getUserpw());
	}

	@Override
	public void deactivateMember(String userid) {
		logger.debug(" MServiceImpl: deactivateMember() 실행! ");
		
		memberDAO.deactivateMember(userid);
		memberDAO.insertMemberHistory(new MemberHistoryVO(userid, "account_status", "active", "deleted", userid));
		
		logger.debug(" MServiceImpl: deactivateMember() 끝! ");
	}

	@Override
	public String findUseridByPassword(String inputPw) {
		logger.debug(" MServiceImpl: findUseridByPassword() 실행! ");
		
		List<MemberVO> list = memberDAO.findAllMembersForIdSearch();
		
        for(MemberVO vo : list) {
            if(pwEncoder.matches(inputPw, vo.getUserpw())) {
                return vo.getUserid(); 
            }
        }
		
		logger.debug(" MServiceImpl: findUseridByPassword() 끝! ");
		return null;
	}

	@Override
	public boolean sendResetLink(String userid, String email) {
		logger.debug(" MServiceImpl: sendResetLink() 실행! ");
		
        MemberVO input = new MemberVO();
        input.setUserid(userid);
        input.setEmail(email);

        MemberVO member = memberDAO.findMemberByIdAndEmail(input);
        if(member == null) return false;

        // 토큰 생성
        String token = UUID.randomUUID().toString();
        LocalDateTime expire = LocalDateTime.now().plusMinutes(30);

        PasswordResetTokenVO tokenVO = new PasswordResetTokenVO();
        tokenVO.setUserid(userid);
        tokenVO.setToken(token);
        tokenVO.setExpire_time(expire);

        memberDAO.insertResetToken(tokenVO);

        String link = "http://localhost:8088/member/resetPw?token=" + token;
        String html = ""
            + "<p>아래 링크를 클릭하여 비밀번호를 재설정하세요.</p>"
            + "<p><a href='" + link + "' style='font-size:16px; color:blue;'>비밀번호 재설정하기</a></p>"
            + "<br>"
            + "<p>만약 링크가 클릭되지 않는다면 아래 주소를 브라우저에 직접 복사하여 이용해주세요:</p>"
            + "<p>" + link + "</p>";
        
        mailComponent.sendMassage(
            email,
            "비밀번호 재설정 링크 안내",
            html
        );
		
		logger.debug(" MServiceImpl: sendResetLink() 끝! ");
		return true;
	}

	@Override
	public boolean validateToken(String token) {
		logger.debug(" MServiceImpl: validateToken() 실행! ");
		
		PasswordResetTokenVO vo = memberDAO.findByToken(token);
		if(vo == null) return false;
		
		logger.debug(" MServiceImpl: validateToken() 끝! ");
		return vo.getExpire_time().isAfter(LocalDateTime.now());
	}

	@Override
	public boolean resetPassword(String token, String newPw) {
		logger.debug(" MServiceImpl: resetPassword() 실행! ");
		
		PasswordResetTokenVO tokenVO = memberDAO.findByToken(token);
        if(tokenVO == null) return false;

        MemberVO member = new MemberVO();
        member.setUserid(tokenVO.getUserid());
        member.setUserpw(pwEncoder.encode(newPw));

        memberDAO.updatePassword(member);

        // 토큰 삭제
        memberDAO.deleteToken(token);
		
		logger.debug(" MServiceImpl: resetPassword() 끝! ");
		return true;
	}

	@Override
	public MemberVO selectNaverLogin(String provider_id) {
		logger.debug(" MServiceImpl: selectNaverLogin() 실행! ");
		
		MemberVO resultVO = memberDAO.selectNaverLogin(provider_id);
		
		logger.debug(" MServiceImpl: selectNaverLogin() 끝! ");
		return resultVO;
	}

	@Override
	public void updateSellerStatus(int member_id, String status) {
		logger.debug(" MServiceImpl: updateSellerStatus() 실행! ");
		
		memberDAO.updateSellerStatus(member_id, status);
		
		logger.debug(" MServiceImpl: updateSellerStatus() 끝! ");
	}

	@Override
	public void insertAuth(MemberAuthVO vo) {
		logger.debug(" MServiceImpl: insertAuth() 실행! ");
		
		vo.setUserid(vo.getUserid());
		vo.setAuth(vo.getAuth());
		
		memberDAO.insertAuth(vo);		
		logger.debug(" MServiceImpl: insertAuth() 끝! ");
	}

	@Override
	public void setNotifyFlag(int member_id, String flag) {
		logger.debug(" MServiceImpl: setNotifyFlag() 실행! ");
		
		Map<String,Object> map = new HashMap<>();
	    map.put("member_id", member_id);
	    map.put("flag", flag);
	    memberDAO.setNotifyFlag(map);
	    
	    logger.debug(" MServiceImpl: setNotifyFlag() 끝! ");
	}

	@Override
	public void updateNotifyFlag(String userid, String flag) {
		logger.debug(" MServiceImpl: updateNotifyFlag() 실행!");

	    Map<String, Object> map = new HashMap<>();
	    map.put("userid", userid);
	    map.put("flag", flag);

	    memberDAO.updateNotifyFlag(map);

	    logger.debug(" MServiceImpl: updateNotifyFlag() 끝!");
		
	}

	@Override
	public List<MemberVO> getMemberList() {
		logger.debug(" MServiceImpl: getMemberList() 실행!");
		
		List<MemberVO> resultVO = memberDAO.getMemberList();
		
		logger.debug(" MServiceImpl: getMemberList() 끝!");
		return resultVO;
	}

	@Override
	public void disableMember(int member_id) {
		logger.debug(" MServiceImpl: disableMember() 실행!");
		
		memberDAO.disableMember(member_id);
		
		logger.debug(" MServiceImpl: disableMember() 끝!");
	}

	@Override
	public void deleteMember(int member_id) {
		logger.debug(" MServiceImpl: deleteMember() 실행! ");
		
		memberDAO.deleteMember(member_id);
		
		logger.debug(" MServiceImpl: deleteMember() 끝! ");
	}

	@Override
	public void enableMember(int member_id) {
		logger.debug(" MServiceImpl: enableMember() 실행! ");
		
		memberDAO.enableMember(member_id);
		
		logger.debug(" MServiceImpl: enableMember() 끝! ");
	}

	@Override
	public MemberVO getMemberById(int member_id) {
		logger.debug(" MServiceImpl: getMemberById() 실행! ");
		
		MemberVO resultVO = memberDAO.getMemberById(member_id);
		
		logger.debug(" MServiceImpl: getMemberById() 끝! ");
		return resultVO;
	}

	@Override
	public void updateOpenBankingToken(MemberVO vo) {
		logger.debug(" MServiceImpl: updateOpenBankingToken() 실행! ");

		memberDAO.updateOpenBankingToken(vo);
		
		logger.debug(" MServiceImpl: updateOpenBankingToken() 끝! ");
	}

	@Override
	public Map<String, Object> getPaymentHistory(int member_id, boolean isSeller) {
		logger.debug(" MServiceImpl: getPaymentHistory() 실행! ");
	    List<PaymentHistoryVO> walletList =
	            memberDAO.selectHistoryLimit50(member_id);

	    Map<String, Object> result = new HashMap<>();
	    result.put("walletList", walletList);

	    if (isSeller) {
	        result.put("sellList",
	                memberDAO.selectSellHistory(member_id));
	    }
	    logger.debug(" MServiceImpl: getPaymentHistory() 끝! ");
	    return result;
	}


}
