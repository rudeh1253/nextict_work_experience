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
					
					alert("�α��� �Ǿ����ϴ�. �޽���: " + data.success);
					
					window.location.href = "/resume/mainView.do";
				},
				error: function(jqXHR, textStatus, errorThrown) {
					console.error(jqXHR);
					console.error(textStatus);
					console.error(errorThrown);
					alert("���� �߻�");
				}
			});
		});
		
		function validateName() {
			const jElem = $j("input[name='name']");
			const name = jElem.val();
			
			if (!name || name.length === 0) {
				alert("�̸��� �Է��� �ּ���");
				jElem.trigger("focus");
				return false;
			}
			
			const regexForKor = new RegExp("^[��-��]+$");
			if (!regexForKor.test(name)) {
				alert("�̸� ������ ���� �ʽ��ϴ�. (�ʼ�, �߼��� ��� �Էµ� �ѱ� �����̾�� �մϴ�)\n����: ȫ�浿");
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
				alert("����ó�� �Է��� �ּ���.")
				jElem.trigger("focus");
				return false;
			}
			
			if ((phone.length !== 10
					&& phone.length !== 11)
					|| !allowedPhoneStarts.has(phone.substring(0, 3))) {
				alert("����ó ������ ���� �ʽ��ϴ�.\n"
						+ "(010/011/016/017/019�� �����ϴ� 10�ڸ� Ȥ�� 11�ڸ� ���ڿ��� �մϴ�.) ����: 0164671234\n"
						+ "010���� ������ ��� 11�ڸ� ���ڿ��� �մϴ�. ����: 01012341234");
				jElem.trigger("focus");
				return false;
			}
			
			if (phone.substring(0, 3) === "010" && phone.length !== 11) {
				alert("010���� ������ ��� 11�ڸ� ���ڿ��� �մϴ�. ����: 01012341234");
				jElem.trigger("focus");
				return false;
			}
			
			return true;
		}
		
		$j("input[name='name']").on("keyup blur", function(e) {
			const regexForNotKorean = new RegExp("[^��-��]", "g");
			
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
							�̸�
						</td>
						<td width="300">
							<input name="name" type="text" size="35">
						</td>
					</tr>
					<tr>
						<td width="120" align="center">
							�޴�����ȣ
						</td>
						<td width="300">
							<input name="phone" type="number" size="35">
						</td>
					</tr>
					<tr align="center">
						<td colspan="2">
							<button type="button" id="enterMainButton">�Ի�����</button>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
</body>
</html>