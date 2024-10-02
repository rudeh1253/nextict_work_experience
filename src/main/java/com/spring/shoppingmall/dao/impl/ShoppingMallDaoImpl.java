package com.spring.shoppingmall.dao.impl;

import org.springframework.stereotype.Repository;
import org.springframework.ui.Model;
import org.springframework.web.multipart.MultipartFile;

import com.spring.shoppingmall.dao.ShoppingMallDao;
import com.spring.shoppingmall.vo.ProductGroupInfoVo;

@Repository
public class ShoppingMallDaoImpl implements ShoppingMallDao {

	@Override
	public int saveProductGroup(ProductGroupInfoVo productGroupInfoVo, MultipartFile prdGrImg, Model model) {
		// TODO Auto-generated method stub
		return 0;
	}

}
