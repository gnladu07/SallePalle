package com.itwillbs.security;

import java.util.Collection;
import java.util.stream.Collectors;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import com.itwillbs.domain.MemberVO;

/**
 * 스프링 시큐리티가 "로그인한 사용자 정보"를 보관하는 객체.
 * MemberVO + 권한(authList) 를 스프링 시큐리티가 이해하는 형태로 바꿔주는 역할.
 * 
 * 즉 UserDetails는 스프링 시큐리티 인증의 핵심 객체이며,
 * Authentication(principal)에 저장됨.
 */

public class CustomUserDetails implements UserDetails {
	
	private MemberVO member; // DB에서 가져온 회원 정보 + 권한 정보

	public CustomUserDetails(MemberVO member) {
		this.member = member;
	}
	
	/** 
	 * 컨트롤러/서비스에서 로그인 정보를 가져오기 위해 사용하는 메서드 
	 * (session.setAttribute("loginInfo") 등에 사용)
	 */
	public MemberVO getMember() {
		return member;
	}

	/**
	 * 권한 목록을 스프링 시큐리티가 이해하는 SimpleGrantedAuthority 형식으로 변환
	 */
	@Override
	public Collection<? extends GrantedAuthority> getAuthorities() {
	    
		return member.getAuthList()
				     .stream()
				     .map(auth -> new SimpleGrantedAuthority(auth.getAuth()))
				     .collect(Collectors.toList());
	}

	// 스프링 시큐리티가 비교하는 비밀번호
	@Override
	public String getPassword() {
		return member.getUserpw();
	}

	/**
	 * 스프링 시큐리티가 내부적으로 사용하는 "로그인 아이디"
	 * 반드시 userid를 반환해야 함 (username 아님)
	 */
	@Override
	public String getUsername() {
		return member.getUserid(); // <- 반드시 userid!
	}
	
	// 계정 활성화 여부
	@Override
	public boolean isEnabled() {
		// 주석: enable_flag를 여기서 false 처리하면 Spring Security가 "로그인 실패"로 간주하여
		//       CustomLoginSuccessHandler로 흐름이 전달되지 않는다.
		//       따라서 정지 계정 처리는 SuccessHandler에서 직접 구현한다.
		return true;
	}

	@Override
	public boolean isAccountNonExpired() {
		return true;
	}

	@Override
	public boolean isAccountNonLocked() {
		return true;
	}

	@Override
	public boolean isCredentialsNonExpired() {
		return true;
	}


}
