<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@include file="/WEB-INF/views/common/common.jsp"%>    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta charset="EUC-KR">
<title>여행계획표 로그인</title>
<script type="text/javascript">
let nameInputPrevState = "";
let phoneInputPrevState = "";

$j(document).ready(function() {
	

	$j("#loginButton").on("click", function(e) {
		e.preventDefault();
		
		const isNameValid = validate($j("#nameInput"), [
			{
				regex: "^$",
				message: "이름을 입력해 주세요.",
				isAcceptablePattern: false
			},
			{
				regex: "[ㄱ-ㅎㅏ-ㅣ]",
				message: "초성과 중성이 결합된 완전한 음절을 입력해 주세요\nex)\nㄱ (x)\nㅢ (x)\n가 (o)",
				isAcceptablePattern: false
			},
			{
				regex: "^[가-힝]{2,5}$",
				message: "2글자에서 5글자 사이 한글만 입력해 주세요",
				isAcceptablePattern: true
			}
		]);
	
		if (!isNameValid) {
			return;
		}
	
		const isPhoneValid = validate($j("#phoneInput"), [
			{
				regex: "^$",
				message: "휴대폰번호를 입력해 주세요.",
				isAcceptablePattern: false
			},
			{
				regex: "^(010\\-\\d{4}\\-\\d{4}|(011|016|017)\\-\\d{3,4}\\-\\d{4})$",
				message: "010/011/016/017로 시작하는 10~11자리 전화번호"
						+ "를 입력해 주세요.\n010으로 시작하는 전화번호는 총 11자리로 입력해 주세요\nex)\n010-1234-1234 (o)\n010-123-1234 (x)\n016-345-1234 (o)",
				isAcceptablePattern: true
			}
		]);
		
		if (!isPhoneValid) {
			return;
		}
		
		$j.ajax({
			url: "/travel/loginAction.do",
			type: "POST",
			contentType: "application/json;charset=euc-kr",
			dataType: "json",
			data: JSON.stringify({
				userName: $j("#nameInput").val(),
				userPhone: $j("#phoneInput").val()
			}),
			success: function(data, textStatus, jqXHR) {
				console.log(data);
				alert("로그인 성공! 메시지: " + data.message);
				
				window.location.href = "${pageContext.request.contextPath}/travel/estimateView.do";
			},
			error: function() {
				alert("에러 발생");
			}
		});
	});
	
	function validate(jElem, validations) {
		const value = jElem.val();
		
		for (let validation of validations) {
			if (new RegExp(validation.regex).test(value) !== validation.isAcceptablePattern) {
				alert(validation.message);
				jElem.trigger("focus");
				return false;
			}
		}
		
		return true;
	}

	$j("#nameInput").on("keyup change", function(e) {
		const allowedCharacterRegex = new RegExp("^[ㄱ-힝]*$");
		
		if (!allowedCharacterRegex.test(e.target.value)) {
			e.target.value = nameInputPrevState;
		}
		
		nameInputPrevState = e.target.value;
	});
	
	$j("#phoneInput").on("keyup change", function(e) {
		if (phoneInputPrevState === e.target.value) {
			return;
		}
		
		const allowedCharacterRegex = new RegExp("^((0|01|010|011|016|017|019)(\\-[0-9]{0,4}|\\-[0-9]{3,4}\\-[0-9]{0,4})?)?$");
		if (!allowedCharacterRegex.test(e.target.value)) {
			e.target.value = e.target.value.replaceAll(new RegExp("[^0-9]", "g"), "");
			const val = e.target.value;
			if (val.length < 3) {
				e.target.value = val;
			} else if (val.length < 7) {
				e.target.value = val.substring(0, 3) + "-" + val.substring(3);
			} else if (val.length < 11) {
				e.target.value = val.substring(0, 3) + "-" + val.substring(3, 7) + "-" + val.substring(7);
			} else {
				e.target.value = val.substring(0, 3) + "-" + val.substring(3, 7) + "-" + val.substring(7, 11);
			}
		}
		
		phoneInputPrevState = e.target.value;
	});
	
	$j("#managementPageButton").on("click", function() {
		window.location.href = "${pageContext.request.contextPath}/travel/scheduleManagementView.do";
	})
});
</script>
</head>
<body>
<form id="loginForm">
	<table border="1" align="center">
		<tr>
			<td>이름</td>
			<td><input id="nameInput" type="text" name="name"></td>
		</tr>
		<tr>
			<td>휴대폰번호</td>
			<td><input id="phoneInput" type="text" name="phone"></td>
		</tr>
		<tr>
			<td colspan="2" align="center">
				<input type="submit" value="로그인" id="loginButton">
			</td>
		</tr>
	</table>
	<button id="managementPageButton" type="button">여행관리</button>
</form>
</body>
</html>