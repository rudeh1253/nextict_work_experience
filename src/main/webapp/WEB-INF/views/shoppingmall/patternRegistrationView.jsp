<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@include file="/WEB-INF/views/common/common.jsp"%>    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta charset="EUC-KR">
<title>기획전 상단 패턴 등록</title>

<script type="text/javascript">
let patterns = [];

const literals = {
		exhibitionName: "기획전명",
		patternType: "패턴타입",
		patternOrder: "패턴순서",
		isPatternDisplayed: "패턴전시여부",
		patternDetailType: "패턴상세타입",
		patternDetailImage: "패턴상세이미지",
		patternDetailText: "패턴상세텍스트",
		patternDetailMovie: "패턴상세동영상",
		addition: "추가",
		deletion: "삭제",
		noPatternRegistered: "등록된 패턴이 없습니다",
		noPatternDetails: "등록된 패턴 상세가 없습니다",
		pleaseInputPatternOrder: "패턴 순서를 입력해 주세요",
		pleaseInputNumber: "숫자를 입력해 주세요",
		pleaseLetNoDuplicatePatternOrderExist: "패턴 순서는 겹치지 않게 해 주세요",
		success: "성공!"
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

<button type="button" id="addPatternButton">추가</button>
<table border="1">
	<tr>
		<td>기획전명</td>
		<td><input id="exhibitionName" data-exhibition-idx="${exhibitionIdx}" type="text" value="${exhibitionName}" disabled></td>
	</tr>
	<tr>
		<td>패턴타입</td>
		<td>
			<select id="patternTypeSelection">
				<c:forEach var="patternType" items="${patternTypeSelections}">
					<option value="${patternType.key}">${patternType.value}</option>
				</c:forEach>
			</select>
		</td>
	</tr>
	<tr>
		<td>패턴 순서</td>
		<td><input type="number" id="patternOrder"></td>
	</tr>
	<tr>
		<td>패턴 전시여부</td>
		<td><input type="checkbox" id="isPatternDisplayed"></td>
	</tr>
</table>

<table>
	<tr>
		<td>
			<button id="patternDeletionButton" type="button">삭제</button>
		</td>
		<td>
			<button id="detailInsertionButton" type="button">추가</button>
			<button id="detailDeletionButton" type="button">삭제</button>
		</td>
	</tr>
	<tr>
		<td style="vertical-align: top;">
			<table border="1" id="exhibitionPatternTable">
				<tr>
					<td></td>
					<td>기획전명</td>
					<td>패턴타입</td>
					<td>패턴순서</td>
					<td>패턴전시여부</td>
				</tr>
			</table>
		</td>
		<td style="vertical-align: top;">
			<table border="1" id="exhibitionPatternDetailTable">
				<tr>
					<td></td>
					<td>패턴상세타입</td>
					<td>패턴상세이미지</td>
					<td>패턴상세텍스트</td>
					<td>패턴상세동영상</td>
					<td>패턴전시여부</td>
				</tr>
				<tr>
					<td colspan="6">선택된 패턴이 없습니다</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
<table align="center">
	<tr>
		<td>
			<button type="button" id="submitButton">저장</button>
		</td>
	</tr>
</table>

</body>
</html>