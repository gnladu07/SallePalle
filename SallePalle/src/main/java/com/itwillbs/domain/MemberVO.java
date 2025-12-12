package com.itwillbs.domain;

import java.sql.Timestamp;
import java.util.List;

import lombok.Data;

//	CREATE TABLE member (
//	    member_id       INT AUTO_INCREMENT PRIMARY KEY,          -- 회원 고유 PK
//	    userid          VARCHAR(100) NOT NULL UNIQUE,            -- 로그인 ID
//	    userpw          VARCHAR(255) NOT NULL,                   -- 암호화된 비밀번호
//	    username        VARCHAR(100) NOT NULL,                   -- 실명
//	    nickname        VARCHAR(100) NOT NULL,                   -- 닉네임
//	    email           VARCHAR(200) NOT NULL,                   -- 이메일 (인증 필요)
//	    gender          CHAR(1) CHECK (gender IN ('M','F')),     -- 성별(M/F)
//	    toplct_id       INT NOT NULL,                            -- 선택형 주소 (시/군/구 FK)
//	    detail_address  VARCHAR(255) NOT NULL,                   -- 상세 주소 입력값
//	    profile_img     VARCHAR(255) DEFAULT 'default_profile.png',  -- 기본 프로필 이미지
//	    seller_status   CHAR(1) DEFAULT 'N' CHECK (seller_status IN ('N','W','Y')),  -- 판매 권한(N: 일반회원 / W: 승인 대기 / Y: 승인됨)
//	    provider        VARCHAR(50) DEFAULT 'LOCAL',             -- 로그인 제공자(LOCAL/KAKAO/NAVER)

//		provider_id     VARCHAR(200) DEFAULT NULL,  -- ★ 추가된 외부로그인 고유ID
//		mobile          VARCHAR(20) DEFAULT NULL CHECK (mobile REGEXP '^[0-9]{3}-[0-9]{4}-[0-9]{4}$'),
//		birth6          CHAR(6) DEFAULT NULL CHECK (birth6 REGEXP '^[0-9]{6}$'),

//	    enable_flag     CHAR(1) DEFAULT '1',                     -- 계정 활성화 여부(1/0)
//	    regdate         TIMESTAMP DEFAULT CURRENT_TIMESTAMP,     -- 가입일
//	    updatedate      TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,          -- 업데이트일
//	    deleted_at      TIMESTAMP NULL DEFAULT NULL,             -- 탈퇴 시점 기록

//		notify_flag CHAR(1) NOT NULL DEFAULT 'N', -- 관리자 승인/거절 시 사용자의 알림 상태를 저장
//		-- Y = 새 알림 있음 (승인/거절 알림)
//		-- N = 알림 없음

//	    agree_terms_required     CHAR(1) DEFAULT 'N' CHECK (agree_terms_required IN ('Y','N')),            -- (필수) 회원약관 동의
//	    agree_privacy_required   CHAR(1) DEFAULT 'N' CHECK (agree_privacy_required IN ('Y','N')),          -- (필수) 개인정보 수집/이용 동의
//	    agree_location_optional  CHAR(1) DEFAULT 'N' CHECK (agree_location_optional IN ('Y','N')),         -- (선택) 위치기반서비스 약관 동의
//	    agree_marketing_email    CHAR(1) DEFAULT 'N' CHECK (agree_marketing_email IN ('Y','N')),           -- (선택) 마케팅 이메일 수신 동의
//	    agree_marketing_sms      CHAR(1) DEFAULT 'N' CHECK (agree_marketing_sms IN ('Y','N')),              -- (선택) 마케팅 SMS/MMS 동의
//
//		FOREIGN KEY (toplct_id) REFERENCES top_location(toplct_id)
//	);


@Data
public class MemberVO {
	
	private int member_id;					// 회원 고유 PK
	private String userid;					// 로그인 ID
	private String userpw;					// 암호화된 비밀번호
	private String username;				// 실명
	private String nickname;				// 닉네임
	private String email;					// 이메일 (인증 필요)
	private String gender;					// 성별(M/F)
	
	private int    toplct_id;				// 선택형 주소 (시/군/구 FK)
	private String detail_address;			// 상세 주소 입력값
	
	private String profile_img;				// 기본 프로필 이미지
	private String seller_status;			// 판매 권한(N: 일반회원 / W: 승인 대기 / Y: 승인됨)
	private String provider;				// 로그인 제공자(LOCAL/KAKAO/NAVER)	
	
	private String provider_id;				// 외부 로그인 아이디
	private String mobile;					// 휴대폰 번호
	private String birth6;					// 생년월일 6자리
	
	private String enable_flag;				// 계정 활성화 여부(1/0)
	
	private Timestamp regdate;				// 가입일
	private Timestamp updatedate;			// 업데이트일
	private Timestamp deleted_at;			// 탈퇴 시점 기록
	
	private String agree_terms_required;	// (필수) 회원약관 동의
	private String agree_privacy_required;	// (필수) 개인정보 수집/이용 동의
	private String agree_location_optional; // (선택) 위치기반서비스 약관 동의
	private String agree_marketing_email;	// (선택) 마케팅 이메일 수신 동의
	private String agree_marketing_sms;		// (선택) 마케팅 SMS/MMS 동의
	
	private String notify_flag;             // 관리자 승인/거절 시 사용자의 알림 상태를 저장(Y: 알림 있음, N: 알림 없음)
	
	private List<MemberAuthVO> authList;

}
