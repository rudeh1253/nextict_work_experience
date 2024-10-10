package com.spring.shoppingmall.controller;

import java.lang.reflect.Field;
import java.lang.reflect.ParameterizedType;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;
import java.util.function.BiConsumer;
import java.util.function.Consumer;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.spring.shoppingmall.dto.PatternDetailRequestDto;
import com.spring.shoppingmall.dto.PatternRegistrationRequestDto;
import com.spring.shoppingmall.service.ShoppingMallService;
import com.spring.shoppingmall.vo.ProductGroupProductVo;
import com.spring.shoppingmall.vo.ProductInfoVo;

@Controller
public class ShoppingMallController {
	private static final Map<String, String> PATTERN_TYPE_SELECTIONS;
	private static final Map<String, String> DETAIL_TYPE_SELECTIONS;
	
	static {
		PATTERN_TYPE_SELECTIONS = getPatternTypeSelections();
		DETAIL_TYPE_SELECTIONS = getDetailTypeSelections();
	}
	
	private static Map<String, String> getPatternTypeSelections() {
		Map<String, Integer> patternTypeOrders = new HashMap<>();
		patternTypeOrders.put("img1", 1);
		patternTypeOrders.put("img2", 2);
		patternTypeOrders.put("text", 3);
		patternTypeOrders.put("movie", 4);
		
		Map<String, String> patternTypeSelections = new TreeMap<>(new Comparator<String>() {
			
			@Override
			public int compare(String s1, String s2) {
				return patternTypeOrders.get(s1) - patternTypeOrders.get(s2);
			}
		});
		patternTypeSelections.put("img1", "2단이미지");
		patternTypeSelections.put("img2", "4단이미지");
		patternTypeSelections.put("text", "텍스트");
		patternTypeSelections.put("movie", "동영상");
		
		return Collections.unmodifiableMap(patternTypeSelections);
	}
	
	private static Map<String, String> getDetailTypeSelections() {
		Map<String, Integer> detailTypeOrders = new HashMap<>();
		detailTypeOrders.put("image", 1);
		detailTypeOrders.put("text", 2);
		detailTypeOrders.put("movie", 3);
		
		Map<String, String> detailTypeSelections = new TreeMap<>(new Comparator<String>() {

			@Override
			public int compare(String o1, String o2) {
				return detailTypeOrders.get(o1) - detailTypeOrders.get(o2);
			}
		});
		
		detailTypeSelections.put("image", "이미지");
		detailTypeSelections.put("text", "텍스트");
		detailTypeSelections.put("movie", "동영상");
		
		return detailTypeSelections;
	}
	
	@Autowired
	private ShoppingMallService shoppingMallService;

	@RequestMapping(value = "/shoppingmall/patternRegistrationView.do", method = RequestMethod.GET)
	public String patternRegistrationView(Model model) {
		model.addAttribute("patternTypeSelections", PATTERN_TYPE_SELECTIONS);
		model.addAttribute("detailTypeSelections", DETAIL_TYPE_SELECTIONS);
		model.addAttribute("exhibitionIdx", 1); // TODO
		model.addAttribute("exhibitionName", "test"); // TODO
		return "shoppingmall/patternRegistrationView";
	}
	
	@RequestMapping(
			value = "/shoppingmall/registerPatterns.do",
			method = RequestMethod.POST
	)
	@ResponseBody
	public String registerPattern(
			@RequestParam("productGroupIdx") Integer productGroupIdx,
			@RequestBody PatternRegistrationRequestDto[] dtoList
	) throws Exception {
		int rowCount = this.shoppingMallService.insertPatterns(productGroupIdx, Arrays.asList(dtoList));
		
		System.out.println("rowCount=" + rowCount);
		
		if (rowCount == 0) {
			throw new Exception("Something wrong");
		}
			
		return "{\"message\":\"success\"}";
	}
	
	@RequestMapping(value = "/shoppingmall/productRegistrationView.do", method = RequestMethod.GET)
	public String productRegistrationView(Model model, @RequestParam("productGroupIdx") Integer productGroupIdx) {
		List<ProductInfoVo> dummyProductInfos = getDummyProductInfos();
		model.addAttribute("productInfos", dummyProductInfos);
		model.addAttribute("productGroupIdx", productGroupIdx);
		
		double dummyDiscount = 0.3;
		model.addAttribute("discount", dummyDiscount);
		
		return "shoppingmall/productRegistrationView";
	}
	
	private List<ProductInfoVo> getDummyProductInfos() {
		ProductInfoVo product1 = new ProductInfoVo();
		product1.setProductIdx(1);
		product1.setProductBrand("asdf");
		product1.setProductCategory("fdsa");
		product1.setProductName("prod1");
		product1.setProductPrice(30000);
		product1.setProductView(true);
		product1.setProductImage("");
		
		ProductInfoVo product2 = new ProductInfoVo();
		product2.setProductIdx(2);
		product2.setProductBrand("asdf");
		product2.setProductCategory("fdsa");
		product2.setProductName("prod2");
		product2.setProductPrice(30000000);
		product2.setProductView(true);
		product2.setProductImage("");
		
		return Arrays.asList(product1, product2);
	}
	
	@RequestMapping(value = "/shoppingmall/registerProduct.do", method = RequestMethod.POST)
	@ResponseBody
	public String registerProduct(@RequestBody ProductGroupProductVo[] requestBody) throws Exception {
		for (ProductGroupProductVo vo : requestBody) {
			System.out.println(vo);
		}
		int row = this.shoppingMallService.insertProductRestrations(requestBody);
		return row > 0
				? "{\"message\":\"success\"}"
				: "{\"message\":\"no insertion\"}";
	}
}
