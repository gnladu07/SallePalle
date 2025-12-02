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
	
	public int sendMassage(String email, String string, String string2) {
		MimeMessage message = mailSender.createMimeMessage();
		try {
			MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");
			helper.setFrom("gnlaud07@naver.com");
			helper.setTo(email);
			helper.setSubject(string);
			helper.setText(string2);
			mailSender.send(message);
			return 1;
			
		} catch (MessagingException e) {
			e.printStackTrace();
			return 0;
		}
	}

}
