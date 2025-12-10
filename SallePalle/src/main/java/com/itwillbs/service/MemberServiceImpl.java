package com.itwillbs.service;
import java.time.LocalDateTime;
import java.util.List;
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
import com.itwillbs.domain.MemberAuthVO;
import com.itwillbs.domain.MemberHistoryVO;
import com.itwillbs.domain.MemberVO;
import com.itwillbs.domain.PasswordResetTokenVO;
import com.itwillbs.persistence.MemberDAO;

@Service
public class MemberServiceImpl implements MemberService {

    private final BCryptPasswordEncoder passwordEncoder;

	private static final Logger logger 
		= LoggerFactory.getLogger(MemberServiceImpl.class);
	
	@Inject private MemberDAO memberDAO;
	@Inject private PasswordEncoder pwEncoder;
	@Inject private MailComponent mailComponent;
	@Inject private FileComponent fileComponent;

    MemberServiceImpl(BCryptPasswordEncoder passwordEncoder) {
        this.passwordEncoder = passwordEncoder;
    }
	
	@Override
	public MemberVO selectOne(String userid) {
		logger.info(" MServiceImpl: selectOne() 실행! ");
		
		MemberVO resultInfo 
			= memberDAO.selectOne(userid);
		
		logger.info(" MServiceImpl: selectOne() 끝! ");
		return resultInfo;
	}

	@Override
	public void memberJoin(MemberVO vo) {
		logger.info(" MServiceImpl: memberJoin() 실행! ");
		
		// 1) provider 값 분기
	    if (vo.getUserpw() == null || vo.getUserpw().trim().equals("")) {
	        throw new IllegalArgumentException("비밀번호는 반드시 입력되어야 합니다.");
	    }
	    vo.setUserpw(passwordEncoder.encode(vo.getUserpw()));

	    // 3) 기타 값 보정
	    if (vo.getMobile() != null && vo.getMobile().trim().equals("")) {
	        vo.setMobile(null);
	    }

	    if (vo.getBirth6() != null && !vo.getBirth6().matches("^[0-9]{6}$")) {
	        vo.setBirth6(null);
	    }

	    // 4) DB insert
	    memberDAO.insertMember(vo);

	    // 5) 권한 부여 (LOCAL, NAVER 모두 ROLE_MEMBER)
	    MemberAuthVO auth = new MemberAuthVO();
	    auth.setUserid(vo.getUserid());
	    auth.setAuth("ROLE_MEMBER");
	    memberDAO.insertAuth(auth);
		
		logger.info(" MServiceImpl: memberJoin() 끝! ");
	}
	
	@Override
	public boolean isUseridExists(String userid) {
		logger.info(" MServiceImpl: isUseridExists()실행! ");
		logger.info(" MServiceImpl: isUseridExists()끝! ");
	    return memberDAO.countUserid(userid) > 0;
	}

	@Override
	public int emailSendCode(String email) {
		logger.info(" MServiceImpl: emailSendCode() 실행! ");
		
		int code = (int) ((Math.random()*900000) + 100000);
		mailComponent.sendMassage(email, "살래팔래 인증번호", "인증번호: "+code);
		
		logger.info(" MServiceImpl: emailSendCode() 끝! ");
		return code;
	}

	@Override
	public void changeProfileImage(String userid, MultipartFile file) {
		logger.info(" MServiceImpl: changeProfileImage() 실행! ");
		
		if (file.isEmpty()) return;
		
		// 1) 현재 회원 정보 조회(기존 이미지 확인용)
		MemberVO current = memberDAO.selectOne(userid);
		
		// 2) 새 이미지 업로드
		String newFileName = fileComponent.upload(file);
		
		// 3) 기존 프로필 이미지 삭제 (default_profile.png는 건드리지 않음)
		String oldFile = current.getProfile_img();
		if (oldFile != null && !oldFile.equals("default_profile.png")) {
			fileComponent.deleteFile(oldFile);
		}
		
		// 4) DB 업데이트
		MemberVO vo = new MemberVO();
		vo.setUserid(userid);
		vo.setProfile_img(newFileName);
		
		memberDAO.updateProfileImg(vo);
		logger.info(" MServiceImpl: changeProfileImage() 끝! ");		
	}

	@Override
	public void resetProfileImage(String userid) {
		logger.info(" MServiceImpl: resetProfileImage() 실행! ");
		
		// 기존 프로필 가져오기
        MemberVO current = memberDAO.selectOne(userid);
        String oldImg = current.getProfile_img();
        
        // DB 기본 이미지로 업데이트
        memberDAO.updateProfileToDefault(userid);

        // 기존 이미지 삭제 (기본 이미지면 삭제 X)
        if (oldImg != null && !oldImg.equals("default_profile.png")) {
            fileComponent.deleteFile(oldImg);
        }
		
		logger.info(" MServiceImpl: resetProfileImage() 끝! ");
	}

	@Override
	public void updateMemberWithHistory(MemberVO vo) {
		logger.info(" MServiceImpl: resetProfileImage() 실행! ");
		
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
        if (old.getToplct_id() != vo.getToplct_id()) {
            memberDAO.insertMemberHistory(new MemberHistoryVO(
                vo.getUserid(),
                "toplct_id",
                String.valueOf(old.getToplct_id()),
                String.valueOf(vo.getToplct_id()),
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
		
		logger.info(" MServiceImpl: resetProfileImage() 끝! ");
	}

	@Override
	public void rollbackMemberInfo(String userid) {
		logger.info(" MServiceImpl: rollbackMemberInfo() 실행! ");
		
		memberDAO.rollbackMemberInfo(userid);
		
		logger.info(" MServiceImpl: rollbackMemberInfo() 끝! ");
	}

	@Override
	public boolean checkPassword(String userid, String userpw) {
		logger.info(" MServiceImpl: checkPassword() 실행! ");
		
		MemberVO vo = memberDAO.selectOne(userid);
		
		logger.info(" MServiceImpl: checkPassword() 끝! ");
		return passwordEncoder.matches(userpw, vo.getUserpw());
	}

	@Override
	public void deactivateMember(String userid) {
		logger.info(" MServiceImpl: deactivateMember() 실행! ");
		
		memberDAO.deactivateMember(userid);
		
		// 히스토리 테이블에도 기록
		memberDAO.insertMemberHistory(new MemberHistoryVO(userid, 
				                                          "account_status", 
				                                          "active", 
				                                          "deleted", 
				                                          userid));
		logger.info(" MServiceImpl: deactivateMember() 끝! ");
	}

	@Override
	public String findUseridByPassword(String inputPw) {
		logger.info(" MServiceImpl: findUseridByPassword() 실행! ");
		
		List<MemberVO> list = memberDAO.findAllMembersForIdSearch();
		
		 // 모든 회원의 암호화된 비밀번호와 비교
        for(MemberVO vo : list) {
            if(pwEncoder.matches(inputPw, vo.getUserpw())) {
                return vo.getUserid(); 
            }
        }
		
		logger.info(" MServiceImpl: findUseridByPassword() 끝! ");
		return null;
	}

	@Override
	public boolean sendResetLink(String userid, String email) {
		logger.info(" MServiceImpl: sendResetLink() 실행! ");
		
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

        // HTML 메일 본문
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
		
		logger.info(" MServiceImpl: sendResetLink() 끝! ");
		return true;
	}

	@Override
	public boolean validateToken(String token) {
		logger.info(" MServiceImpl: validateToken() 실행! ");
		
		PasswordResetTokenVO vo = memberDAO.findByToken(token);
		if(vo == null) return false;
		
		logger.info(" MServiceImpl: validateToken() 끝! ");
		return vo.getExpire_time().isAfter(LocalDateTime.now());
	}

	@Override
	public boolean resetPassword(String token, String newPw) {
		logger.info(" MServiceImpl: resetPassword() 실행! ");
		
		PasswordResetTokenVO tokenVO = memberDAO.findByToken(token);
        if(tokenVO == null) return false;

        MemberVO member = new MemberVO();
        member.setUserid(tokenVO.getUserid());
        member.setUserpw(passwordEncoder.encode(newPw));

        memberDAO.updatePassword(member);

        // 토큰 삭제
        memberDAO.deleteToken(token);
		
		logger.info(" MServiceImpl: resetPassword() 끝! ");
		return true;
	}

	@Override
	public MemberVO selectNaverLogin(String provider_id) {
		logger.info(" MServiceImpl: selectNaverLogin() 실행! ");
		
		MemberVO resultVO = memberDAO.selectNaverLogin(provider_id);
		
		logger.info(" MServiceImpl: selectNaverLogin() 끝! ");
		return resultVO;
	}

	@Override
	public void updateSellerStatus(int member_id, String status) {
		logger.info(" MServiceImpl: updateSellerStatus() 실행! ");
		
		memberDAO.updateSellerStatus(member_id, status);
		
		logger.info(" MServiceImpl: updateSellerStatus() 끝! ");
	}

	@Override
	public void insertAuth(MemberAuthVO vo) {
		logger.info(" MServiceImpl: insertAuth() 실행! ");
		
		vo.setUserid(vo.getUserid());
		vo.setAuth(vo.getAuth());
		
		memberDAO.insertAuth(vo);		
		logger.info(" MServiceImpl: insertAuth() 끝! ");
	}




}
