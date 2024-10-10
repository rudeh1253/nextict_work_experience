<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@include file="/WEB-INF/views/common/common.jsp"%>    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta charset="EUC-KR">
<title>상품 등록</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/shoppingmall/product-registration.css">
<script type="text/javascript">
const productGroupIdx = ${productGroupIdx};
const productInfos = {
		<c:forEach var="prod" items="${productInfos}">
			${prod.productIdx}: {
				productName: "${prod.productName}",
				productPrice: ${prod.productPrice}
			},
		</c:forEach>
}

const discount = ${discount};

const texts = {
		"productName": "상품명",
		"price": "가격",
		"isDisplayed": "전시여부",
		"noProductRegistered": "등록된 상품이 없습니다.",
		"registrationSucceess": "등록 성공",
		"fail": "실패"
}
</script>
<script src="${pageContext.request.contextPath}/resources/js/firstparty/utils.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/firstparty/shoppingmall/productregistration/initscript.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/firstparty/shoppingmall/productregistration/updateProductRegistrationTable.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/firstparty/shoppingmall/productregistration/sendRequest.js"></script>
</head>
<body>
<h1>상품 등록</h1>
<div class="registration-body">
	<table border="1" id="productInfoTable">
		<tr>
			<td></td>
			<td>상품명</td>
			<td>가격</td>
		</tr>
	</table>
	<button id="productAddButton" type="button">▶</button>
	<div>
		<button id="productRegistrationDeleteButton" type="button">삭제</button>
		<table border="1" id="productRegistrationTable">
			<tr>
				<td></td>
				<td>상품명</td>
				<td>가격</td>
				<td>전시여부</td>
			</tr>
		</table>
	</div>
</div>
<table align="center">
	<tr>
		<td>
			<button type="button" id="saveButton">저장</button>
		</td>
	</tr>
</table>
</body>
</html>