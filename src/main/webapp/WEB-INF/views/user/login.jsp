<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@include file="/WEB-INF/views/common/common.jsp"%>    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>memberJoin</title>
</head>
<script type="text/javascript">
	let isDuplicated = true;
	
	$j(document).ready(function() {
		$j("#loginButton").on("click", () => {
			const jUserIdElem = $j("#loginForm input[name='userId']");
			const jUserPwElem = $j("#loginForm input[name='userPw']");
			const userIdInput = jUserIdElem.val();
			const userPwInput = jUserPwElem.val();
			
			if (userIdInput === "") {
				alert("ID를 입력해야 합니다.");
				jUserIdElem.trigger("focus");
				return;
			} else if (userPwInput === "") {
				alert("PW를 입력해야 합니다.");
				jUserPwElem.trigger("focus");
				return;
			}
			
			$j.ajax({
				url: "/user/loginAction.do",
				type: "POST",
				dataType: "json",
				contentType: "application/json; charset=euc-kr",
				data: JSON.stringify({
					userId: userIdInput,
					userPw: userPwInput
				}),
				success: function(data, textStatus, jqXHR) {
					console.log(data);
					console.log(typeof data.validId);
					console.log(typeof data.validPw);
					if (!data.validId) {
						alert("존재하지 않는 ID입니다.");
						jUserIdElem.trigger("focus");
					} else if (!data.validPw) {
						alert("패스워드가 일치하지 않습니다.");
						jUserPwElem.trigger("focus");
					} else {
						window.location.href = "/board/boardList.do";
					}
				},
				error: function(jqXHR, textStatus, errorThrown) {
					alert("통신불량");
					console.error(jqXHR);
					console.error(textStatus);
					console.error(errorThrown);
				}
			});
		});
		
		$j("#joinButton").on("click", () => {
			const success = validate();
			if (success) {
				$j.ajax({
					url: "/user/userJoinAction.do",
					type: "POST",
					dataType: "json",
					contentType: "application/json;euc-kr",
					data: JSON.stringify({
						userId: $j("input[name='userId']").val(),
						userPw: $j("input[name='userPw']").val(),
						userName: $j("input[name='userName']").val(),
						userPhone1: $j("select[name='userPhone1']").val(),
						userPhone2: $j("input[name='userPhone2']").val(),
						userPhone3: $j("input[name='userPhone3']").val(),
						userAddr1: $j("input[name='userAddr1']").val(),
						userAddr2: $j("input[name='userAddr2']").val(),
						userCompany: $j("input[name='userCompany']").val()
					}),
					success: function(data, textStatus, jqXHR) {
						alert("가입완료");
						alert("메세지: " + data.success);
						window.location.href = "/user/loginView.do";
					},
					error: function(jqXHR, textStatus, errorThrown) {
						alert("통신불량");
					}
				});
			} else {
				console.log("failed");
			}
		});
	});
</script>
<body>
<form id="loginForm">
	<table align="center">
		<tr>
			<td align="left">
				<a href="/board/boardList.do">List</a>
			</td>
		</tr>
		<tr>
			<td>
				<table border ="1">
					<tr>
						<td width="120" align="center">
							id
						</td>
						<td width="300">
							<input name="userId" type="text" size="25">
						</td>
					</tr>
					<tr>
						<td width="120" align="center">
							pw
						</td>
						<td width="300">
							<input name="userPw" type="password" size="25">
						</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td align="right">
				<button id="loginButton" type="button">login</button>
			</td>
		</tr>
	</table>
</form>	
</body>
</html>