package com.spring.board.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class SpecialExhibitionController {

	@RequestMapping(value = "/exhibition/registerView.do")
	public String registerView() {
		return "exhibition/registerView";
	}
}
