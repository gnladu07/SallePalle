package com.itwillbs.controller;

import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.inject.Inject;
import javax.sql.DataSource;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(
        locations = {
            "file:src/main/webapp/WEB-INF/spring/root-context.xml"
        }
		)
public class MemberAuthTest {
		
	private static final Logger log 
		= LoggerFactory.getLogger(MemberAuthTest.class);
	
	@Inject private DataSource ds;
	@Inject private PasswordEncoder pwEncoder;
	
	// @Test
	public void 주입확인_테스트() {
		log.info(" 주입확인_테스트() 실행! ");
		
		log.info(" ds: {} ",ds);
		log.info(" pwEncoder: {} ",pwEncoder);
	}
	
	// @Test
	public void createTestAdmin() throws Exception {
		log.info("=== 테스트 관리자 계정 생성 ===");

	    Connection con = null;
	    PreparedStatement pstmt = null;

	    // 1) member INSERT (DDL 필수 컬럼 포함)
	    String sql1 = 
	        "INSERT INTO member " +
	        " (userid, userpw, username, nickname, email, gender, toplct_id, detail_address) " +
	        " VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

	    con = ds.getConnection();
	    pstmt = con.prepareStatement(sql1);

	    String userid = "admin";
	    String encodedPw = pwEncoder.encode("1234");

	    pstmt.setString(1, userid);
	    pstmt.setString(2, encodedPw);
	    pstmt.setString(3, "관리자1");
	    pstmt.setString(4, "admin1");
	    pstmt.setString(5, "admin@test.com");
	    pstmt.setString(6, "M");        // 성별(M/F)
	    pstmt.setInt(7, 1);             // toplct_id (테스트용으로 1 사용)
	    pstmt.setString(8, "관리자 상세주소");

	    pstmt.executeUpdate();
	    log.info("member 테이블 관리자 row 생성 완료!");

	    // 2) member_auth INSERT
	    String sql2 = 
	        "INSERT INTO member_auth (userid, auth) VALUES (?, ?)";

	    pstmt = con.prepareStatement(sql2);
	    pstmt.setString(1, userid);
	    pstmt.setString(2, "ROLE_ADMIN");

	    pstmt.executeUpdate();
	    
	    // 3) member_auth INSERT
	    String sql3 = 
	    		"INSERT INTO member_auth (userid, auth) VALUES (?, ?)";
	    
	    pstmt = con.prepareStatement(sql3);
	    pstmt.setString(1, userid);
	    pstmt.setString(2, "ROLE_MEMBER");
	    
	    pstmt.executeUpdate();
	    log.info("member_auth ROLE_ADMIN 생성 완료!");

	    log.info("=== 관리자 계정 생성 완료! ===");
	}
	
	@Test
	public void createTestMemberBatch() throws Exception {
	    log.info("=== 100명 일반 회원 생성 시작 ===");

	    String sql1 =
	        "INSERT INTO member " +
	        " (userid, userpw, username, nickname, email, gender, toplct_id, detail_address) " +
	        " VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

	    String sql2 =
	        "INSERT INTO member_auth (userid, auth) VALUES (?, ?)";

	    // 공통 비밀번호(전부 동일)
	    String encodedPw = pwEncoder.encode("1234");

	    try (Connection con = ds.getConnection()) {

	        for (int i = 0; i < 100; i++) {

	            String userid = "test" + i;
	            String username = "일반회원" + i;
	            String nickname = "닉네임" + i;
	            String email = "user" + i + "@test.com";
	            String gender = (i % 2 == 0) ? "M" : "F";  // M/F 번갈아 넣기
	            int toplctId = 1;
	            String detailAddr = "일반회원 주소 " + i;

	            // 1) member 테이블 Insert
	            try (PreparedStatement pstmt = con.prepareStatement(sql1)) {
	                pstmt.setString(1, userid);
	                pstmt.setString(2, encodedPw);
	                pstmt.setString(3, username);
	                pstmt.setString(4, nickname);
	                pstmt.setString(5, email);
	                pstmt.setString(6, gender);
	                pstmt.setInt(7, toplctId);
	                pstmt.setString(8, detailAddr);

	                pstmt.executeUpdate();
	            }

	            // 2) member_auth 테이블 Insert
	            try (PreparedStatement pstmt2 = con.prepareStatement(sql2)) {
	                pstmt2.setString(1, userid);
	                pstmt2.setString(2, "ROLE_MEMBER");
	                pstmt2.executeUpdate();
	            }

	            log.info(">> {}번 회원(test_user{}) 생성 완료", i, i);
	        }
	    }

	    log.info("=== 100명 일반 회원 생성 완료 ===");
	}


}
