<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@include file="/WEB-INF/views/common/common.jsp"%>    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta charset="EUC-KR">
<title>�����ȹǥ �α���</title>
<script type="text/javascript">
let nameInputPrevState = "";
let phoneInputPrevState = "";

$j(document).ready(function() {
	

	$j("#loginButton").on("click", function(e) {
		e.preventDefault();
		
		const isNameValid = validate($j("#nameInput"), [
			{
				regex: "^$",
				message: "�̸��� �Է��� �ּ���.",
				isAcceptablePattern: false
			},
			{
				regex: "[��-����-��]",
				message: "�ʼ��� �߼��� ���յ� ������ ������ �Է��� �ּ���\nex)\n�� (x)\n�� (x)\n�� (o)",
				isAcceptablePattern: false
			},
			{
				regex: "^[��-��]{2,5}$",
				message: "2���ڿ��� 5���� ���� �ѱ۸� �Է��� �ּ���",
				isAcceptablePattern: true
			}
		]);
	
		if (!isNameValid) {
			return;
		}
	
		const isPhoneValid = validate($j("#phoneInput"), [
			{
				regex: "^$",
				message: "�޴�����ȣ�� �Է��� �ּ���.",
				isAcceptablePattern: false
			},
			{
				regex: "^(010\\-\\d{4}\\-\\d{4}|(011|016|017)\\-\\d{3,4}\\-\\d{4})$",
				message: "010/011/016/017�� �����ϴ� 10~11�ڸ� ��ȭ��ȣ"
						+ "�� �Է��� �ּ���.\n010���� �����ϴ� ��ȭ��ȣ�� �� 11�ڸ��� �Է��� �ּ���\nex)\n010-1234-1234 (o)\n010-123-1234 (x)\n016-345-1234 (o)",
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
				alert("�α��� ����! �޽���: " + data.message);
				
				window.location.href = "${pageContext.request.contextPath}/travel/estimateView.do";
			},
			error: function() {
				alert("���� �߻�");
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
		const allowedCharacterRegex = new RegExp("^[��-��]*$");
		
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
			<td>�̸�</td>
			<td><input id="nameInput" type="text" name="name"></td>
		</tr>
		<tr>
			<td>�޴�����ȣ</td>
			<td><input id="phoneInput" type="text" name="phone"></td>
		</tr>
		<tr>
			<td colspan="2" align="center">
				<input type="submit" value="�α���" id="loginButton">
			</td>
		</tr>
	</table>
	<button id="managementPageButton" type="button">�������</button>
</form>
</body>
</html>