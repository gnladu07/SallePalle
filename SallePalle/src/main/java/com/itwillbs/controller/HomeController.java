package com.itwillbs.controller;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * Handles requests for the application home page.
 */
@Controller
@RequestMapping("/main/*")
public class HomeController {
	
	private static final Logger logger = LoggerFactory.getLogger(HomeController.class);
	// http://localhost:8088/controller/
	/**
	 * Simply selects the home view to render by returning its name.
	 */
	
	@GetMapping("/header")
	public void headerGET() {
		logger.info(" headerGET 실행! ");
	}
	
}
