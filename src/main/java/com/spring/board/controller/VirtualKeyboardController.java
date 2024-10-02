package com.spring.board.controller;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
public class VirtualKeyboardController {
	private static final String[][] KEYBOARD_SET = {
			{
				"one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "zero"
			},
			{
				"q", "w", "e", "r", "t", "y", "u", "i", "o", "p", "backspace"
			},
			{
				"a", "s", "d", "f", "g", "h", "j", "k", "l", "semicolon", "quote", "enter"
			},
			{
				"shift", "z", "x", "c", "v", "b", "n", "m", "comma", "dot", "slash"
			}
	};
	
	private static final Map<String, String> KEYBOARD_VALUE_TABLE = new HashMap<>();
	
	static {
		String keyboardSet =
				"one-1=two-2=three-3=four-4=five-5=six-6=seven-7=eight-8=nine-9=zero-0="
				+ "q-げ=w-じ=e-ぇ=r-ぁ=t-さ=y-に=u-づ=i-ち=o-だ=p-つ=backspace-Back Space="
				+ "a-け=s-い=d-し=f-ぉ=g-ぞ=h-で=j-っ=k-た=l-び=semicolon-;=quote-'=enter-Enter="
				+ "shift-Shift=z-せ=x-ぜ=c-ず=v-そ=b-ば=n-ぬ=m-ぱ=comma-,=dot-.=slash-/";
		
		for (String keyPair : keyboardSet.split("=")) {
			String[] keyValue = keyPair.split("\\-");
			KEYBOARD_VALUE_TABLE.put(keyValue[0], keyValue[1]);
		}
		
		for (Map.Entry<String, String> entry : KEYBOARD_VALUE_TABLE.entrySet()) {
			System.out.println(entry.getKey() + "=" + entry.getValue());
		}
	}
	
	private static final Map<String, String> UPPER_CASE_MAP = new HashMap<>();
	
	static {
		String upperCaseSet = "one=!-two=@-three=#-four=$-five=%-six=^-seven=&-eight=*-nine=(-zero=)-" 
				+ "q=こ-w=す-e=え-r=あ-t=ざ-colon=:-quote=\\\"-comma=<-dot=>-slash=?-o=ぢ-p=て";
		
		for (String upperCase : upperCaseSet.split("\\-")) {
			String[] keyValuePair = upperCase.split("=");
			UPPER_CASE_MAP.put(keyValuePair[0], keyValuePair[1]);
		}
	}
	
	private static final Set<String> HANGUL_SET
			= new HashSet<>(Arrays.asList("げ", "じ", "ぇ", "ぁ", "さ", "に", "づ", "ち", "だ", "つ",
					"け", "い", "し", "ぉ", "ぞ", "で", "っ", "た", "び", "せ", "ぜ", "ず", "そ", "ば", "ぬ", "ぱ"));
	private static final Set<String> SPECIAL_FUNCTION_SET = new HashSet<>(Arrays.asList(
			"backspace", "enter", "shift", "spacebar"));
	
	@RequestMapping(value = "/keyboard/keyboardView.do", method = RequestMethod.GET)
	public String keyboardView(Model model) {
		model.addAttribute("keyboardSet", KEYBOARD_SET);
		model.addAttribute("keyboardValueTable", KEYBOARD_VALUE_TABLE);
		model.addAttribute("hangulSet", HANGUL_SET);
		model.addAttribute("specialFunctionSet", SPECIAL_FUNCTION_SET);
		model.addAttribute("upperCaseMap", UPPER_CASE_MAP);
		return "/keyboard/keyboardView";
	}
}
