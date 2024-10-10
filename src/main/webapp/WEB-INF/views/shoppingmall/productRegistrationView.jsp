<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@include file="/WEB-INF/views/common/common.jsp"%>    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta charset="EUC-KR">
<title>��ǰ ���</title>
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
		"productName": "��ǰ��",
		"price": "����",
		"isDisplayed": "���ÿ���",
		"noProductRegistered": "��ϵ� ��ǰ�� �����ϴ�.",
		"registrationSucceess": "��� ����",
		"fail": "����"
}
</script>
<script src="${pageContext.request.contextPath}/resources/js/firstparty/utils.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/firstparty/shoppingmall/productregistration/initscript.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/firstparty/shoppingmall/productregistration/updateProductRegistrationTable.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/firstparty/shoppingmall/productregistration/sendRequest.js"></script>
</head>
<body>
<h1>��ǰ ���</h1>
<div class="registration-body">
	<table border="1" id="productInfoTable">
		<tr>
			<td></td>
			<td>��ǰ��</td>
			<td>����</td>
		</tr>
	</table>
	<button id="productAddButton" type="button">��</button>
	<div>
		<button id="productRegistrationDeleteButton" type="button">����</button>
		<table border="1" id="productRegistrationTable">
			<tr>
				<td></td>
				<td>��ǰ��</td>
				<td>����</td>
				<td>���ÿ���</td>
			</tr>
		</table>
	</div>
</div>
<table align="center">
	<tr>
		<td>
			<button type="button" id="saveButton">����</button>
		</td>
	</tr>
</table>
</body>
</html>