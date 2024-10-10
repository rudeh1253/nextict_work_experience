package com.spring.shoppingmall.dao.impl;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.spring.shoppingmall.dao.ShoppingMallDao;
import com.spring.shoppingmall.vo.ProductGroupProductVo;
import com.spring.shoppingmall.vo.ProductPatternDetail;
import com.spring.shoppingmall.vo.ProductPatternInfo;

@Repository
public class ShoppingMallDaoImpl implements ShoppingMallDao {
	
	@Autowired
	private SqlSession sqlSession;

	@Override
	public int insertPattern(ProductPatternInfo productPatternInfo) {
		return this.sqlSession.insert("shoppingmall.insertPattern", productPatternInfo);
	}

	@Override
	public int insertPatternDetail(ProductPatternDetail productPatternDetail) {
		return this.sqlSession.insert("shoppingmall.insertPatternDetail", productPatternDetail);
	}
	
	@Override
	public int insertProductGroupProductVo(ProductGroupProductVo productGroupProductVo) throws Exception {
		return this.sqlSession.insert("shoppingmall.insertProductGroupProduct", productGroupProductVo);
	}
}
