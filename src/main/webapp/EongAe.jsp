<script>
	var id = "tester";
	var pass = "tester";
	
	var getId = prompt("아이디를 입력하세요.");
	var getpass = prompt("비밀번호를 입력하세요.");
	
	
	if(id == getId && pass == getpass) {
	    alert("로그인 되었습니다.");
	} else {
	    alert("아이디 혹은 비밀번호가 틀렸습니다.");
	    script.println("location.href = 'asjhdbejf.jsp'");
	}

    var text = prompt("Message");
    document.write("<h3>" + text +"</h3>");
</script>
