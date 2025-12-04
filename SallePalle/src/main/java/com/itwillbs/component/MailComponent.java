package com.itwillbs.component;

import javax.mail.MessagingException;
import javax.mail.internet.MimeMessage;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Component;

@Component
public class MailComponent {
	
	@Autowired private JavaMailSender mailSender;
	
	public int sendMassage(String email, String subject, String htmlContent) {
		MimeMessage message = mailSender.createMimeMessage();
		try {
			MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");
			helper.setFrom("gnlaud07@naver.com");
			helper.setTo(email);
			helper.setSubject(subject);

			// 핵심: HTML 이메일 전송
			helper.setText(htmlContent, true);   // true = HTML 모드

			mailSender.send(message);
			return 1;

		} catch (MessagingException e) {
			e.printStackTrace();
			return 0;
		}
	}

}
