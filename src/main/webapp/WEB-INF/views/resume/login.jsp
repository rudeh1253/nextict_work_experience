<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@include file="/WEB-INF/views/common/common.jsp"%>    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta charset="EUC-KR">
<title>Login</title>
<script type="text/javascript">
	$j(document).ready(function() {
		$j("#enterMainButton").on("click", function() {
			const name = $j("input[name='name']").val();
			const phone = $j("input[name='phone']").val();
			
			if (!validateName() || !validatePhone()) {
				return;
			}
			
			$j.ajax({
				url: "/resume/loginAction.do",
				type: "POST",
				contentType: "application/json;charset=euc-kr",
				dataType: "json",
				data: JSON.stringify({
					name: name,
					phone: phone
				}),
				success: function(data, textStatus, jqXHR) {
					console.log(textStatus);
					console.log(jqXHR);
					
					alert("로그인 되었습니다. 메시지: " + data.success);
					
					window.location.href = "/resume/mainView.do";
				},
				error: function(jqXHR, textStatus, errorThrown) {
					console.error(jqXHR);
					console.error(textStatus);
					console.error(errorThrown);
					alert("에러 발생");
				}
			});
		});
		
		function validateName() {
			const jElem = $j("input[name='name']");
			const name = jElem.val();
			
			if (!name || name.length === 0) {
				alert("이름을 입력해 주세요");
				jElem.trigger("focus");
				return false;
			}
			
			const regexForKor = new RegExp("^[가-힝]+$");
			if (!regexForKor.test(name)) {
				alert("이름 형식이 맞지 않습니다. (초성, 중성이 모두 입력된 한글 형식이어야 합니다)\n예시: 홍길동");
				jElem.trigger("focus");
				return false;
			}
			return true;
		}
		
		const allowedPhoneStarts = new Set();
		allowedPhoneStarts.add("010");
		allowedPhoneStarts.add("011");
		allowedPhoneStarts.add("016");
		allowedPhoneStarts.add("017");
		allowedPhoneStarts.add("019");
		
		function validatePhone() {
			const jElem = $j("input[name='phone']");
			const phone = jElem.val();
			
			if (!phone || phone.length === 0) {
				alert("연락처를 입력해 주세요.")
				jElem.trigger("focus");
				return false;
			}
			
			if ((phone.length !== 10
					&& phone.length !== 11)
					|| !allowedPhoneStarts.has(phone.substring(0, 3))) {
				alert("연락처 형식이 맞지 않습니다.\n"
						+ "(010/011/016/017/019로 시작하는 10자리 혹은 11자리 숫자여야 합니다.) 예시: 0164671234\n"
						+ "010으로 시작할 경우 11자리 숫자여야 합니다. 예시: 01012341234");
				jElem.trigger("focus");
				return false;
			}
			
			if (phone.substring(0, 3) === "010" && phone.length !== 11) {
				alert("010으로 시작할 경우 11자리 숫자여야 합니다. 예시: 01012341234");
				jElem.trigger("focus");
				return false;
			}
			
			return true;
		}
		
		$j("input[name='name']").on("keyup blur", function(e) {
			const regexForNotKorean = new RegExp("[^ㄱ-힝]", "g");
			
			const v = $j(this).val();
			if (regexForNotKorean.test(v)) {
				$j(this).val(v.replaceAll(regexForNotKorean, ""));
			}
		});
		
		$j("input[name='phone']").on("keyup blur", function(e) {
			const v = $j(this).val();
			
			let replaced = v.replaceAll(new RegExp("[^0-9]+", "g"), "");
			
			if (replaced.length > 11) {
				replaced = replaced.substring(0, 11);
			}
			
			$j(this).val(replaced);
		});
	});
</script>
</head>
<body>
	<table align="center">
		<tr>
			<td>
				<table border ="1">
					<tr>
						<td width="120" align="center">
							이름
						</td>
						<td width="300">
							<input name="name" type="text" size="35">
						</td>
					</tr>
					<tr>
						<td width="120" align="center">
							휴대폰번호
						</td>
						<td width="300">
							<input name="phone" type="number" size="35">
						</td>
					</tr>
					<tr align="center">
						<td colspan="2">
							<button type="button" id="enterMainButton">입사지원</button>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
</body>
</html>