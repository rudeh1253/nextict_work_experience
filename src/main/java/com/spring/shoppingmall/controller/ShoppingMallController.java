package com.spring.shoppingmall.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.spring.shoppingmall.service.ShoppingMallService;
import com.spring.shoppingmall.vo.ProductGroupInfoVo;

@Controller
public class ShoppingMallController {
	
	@Autowired
	private ShoppingMallService shoppingMallService ;

	@RequestMapping(value = "/shoppingmall/patternRegistrationView.do", method = RequestMethod.GET)
	public String patternRegistrationView() {
		return "exhibition/patternRegistrationView";
	}
	
	@RequestMapping(value = "/shoppingmall/exhibitionRegistrationView.do", method = RequestMethod.GET)
	public String exhibitionRegistrationView() {
		return "shoppingmall/exhibitionRegistrationView";
	}
	
	@RequestMapping(value = "/shoppingmall/saveExhibition.do", method = RequestMethod.POST)
	public String exhibitionCreate() {
		 public String saveProductGroup(ProductGroupInfoVo productGroupInfoVo, @RequestParam("prdGrImg") MultipartFile prdGrImg, Model model) {
		        try {
		            // Handle file upload if needed
		            if (!prdGrImg.isEmpty()) {
		                // You can save the file to a location on your server or database
		                String fileName = prdGrImg.getOriginalFilename();
		                // Example: Save the file to the /uploads directory
		                String filePath = "C:/uploads/" + fileName;
		                prdGrImg.transferTo(new File(filePath));
		                
		                // Save file name to the VO
		                productGroupInfoVo.setPrdGrImg(fileName);
		            }

		            // Save the product group info using the service
		            shoppingMallService.saveProductGroup(productGroupInfoVo, prdGrImg, model);

		            // Add a success message to the model
		            model.addAttribute("message", "기획전 정보가 성공적으로 저장되었습니다.");
		        } catch (Exception e) {
		            e.printStackTrace();
		            model.addAttribute("message", "저장 중 오류가 발생했습니다.");
		        }
		        
		        return "redirect:/shoppingmall/exhibitionRegistrationView.do"; // 추후에 리스트로 리다이렉트 되게 수정하기
		    }
}

