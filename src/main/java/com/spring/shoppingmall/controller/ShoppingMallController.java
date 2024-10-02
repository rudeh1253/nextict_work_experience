package com.spring.shoppingmall.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
public class ShoppingMallController {

	@RequestMapping(value = "/shoppingmall/patternRegistrationView.do", method = RequestMethod.GET)
	public String patternRegistrationView() {
		return "exhibition/patternRegistrationView";
	}
}

