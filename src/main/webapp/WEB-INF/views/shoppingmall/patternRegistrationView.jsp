<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@include file="/WEB-INF/views/common/common.jsp"%>    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta charset="EUC-KR">
<title>��ȹ�� ��� ���� ���</title>

<script type="text/javascript">
let patterns = [];

const literals = {
		exhibitionName: "��ȹ����",
		patternType: "����Ÿ��",
		patternOrder: "���ϼ���",
		isPatternDisplayed: "�������ÿ���",
		patternDetailType: "���ϻ�Ÿ��",
		patternDetailImage: "���ϻ��̹���",
		patternDetailText: "���ϻ��ؽ�Ʈ",
		patternDetailMovie: "���ϻ󼼵�����",
		addition: "�߰�",
		deletion: "����",
		noPatternRegistered: "��ϵ� ������ �����ϴ�",
		noPatternDetails: "��ϵ� ���� �󼼰� �����ϴ�",
		pleaseInputPatternOrder: "���� ������ �Է��� �ּ���",
		pleaseInputNumber: "���ڸ� �Է��� �ּ���",
		pleaseLetNoDuplicatePatternOrderExist: "���� ������ ��ġ�� �ʰ� �� �ּ���",
		success: "����!"
};

const detailTypes = {
		<c:forEach var="detailType" items="${detailTypeSelections}">
			${detailType.key}: "${detailType.value}",
		</c:forEach>
};
</script>

<script src="${pageContext.request.contextPath}/resources/js/firstparty/shoppingmall/patternregistration/patternRegistrationView.js" type="text/javascript"></script>
<script src="${pageContext.request.contextPath}/resources/js/firstparty/shoppingmall/patternregistration/updatePatterns.js" type="text/javascript"></script>
<script src="${pageContext.request.contextPath}/resources/js/firstparty/shoppingmall/patternregistration/updatePatternDetails.js" type="text/javascript"></script>
</head>
<body>

<button type="button" id="addPatternButton">�߰�</button>
<table border="1">
	<tr>
		<td>��ȹ����</td>
		<td><input id="exhibitionName" data-exhibition-idx="${exhibitionIdx}" type="text" value="${exhibitionName}" disabled></td>
	</tr>
	<tr>
		<td>����Ÿ��</td>
		<td>
			<select id="patternTypeSelection">
				<c:forEach var="patternType" items="${patternTypeSelections}">
					<option value="${patternType.key}">${patternType.value}</option>
				</c:forEach>
			</select>
		</td>
	</tr>
	<tr>
		<td>���� ����</td>
		<td><input type="number" id="patternOrder"></td>
	</tr>
	<tr>
		<td>���� ���ÿ���</td>
		<td><input type="checkbox" id="isPatternDisplayed"></td>
	</tr>
</table>

<table>
	<tr>
		<td>
			<button id="patternDeletionButton" type="button">����</button>
		</td>
		<td>
			<button id="detailInsertionButton" type="button">�߰�</button>
			<button id="detailDeletionButton" type="button">����</button>
		</td>
	</tr>
	<tr>
		<td style="vertical-align: top;">
			<table border="1" id="exhibitionPatternTable">
				<tr>
					<td></td>
					<td>��ȹ����</td>
					<td>����Ÿ��</td>
					<td>���ϼ���</td>
					<td>�������ÿ���</td>
				</tr>
			</table>
		</td>
		<td style="vertical-align: top;">
			<table border="1" id="exhibitionPatternDetailTable">
				<tr>
					<td></td>
					<td>���ϻ�Ÿ��</td>
					<td>���ϻ��̹���</td>
					<td>���ϻ��ؽ�Ʈ</td>
					<td>���ϻ󼼵�����</td>
					<td>�������ÿ���</td>
				</tr>
				<tr>
					<td colspan="6">���õ� ������ �����ϴ�</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
<table align="center">
	<tr>
		<td>
			<button type="button" id="submitButton">����</button>
		</td>
	</tr>
</table>

</body>
</html>