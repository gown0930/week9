<%@ page language="java" contentType="text/html" pageEncoding="utf-8" %>
<head>
   <meta charset="UTF-8">
   <meta name="viewport" content="width=device-width, initial-scale=1.0">
   <link rel="stylesheet" type="text/css" href="css/login.css">
   <title>로그인</title>
</head>
<body>
   <div id="header">Schedule Calendar</div>
   <div id="loginbox">
       <div id="title">로그인</div>
       <form action="action/login_action.jsp" method="post">
         <!-- 데이터를 HTTP 요청의 본문에 넣어 서버로 전송하는거(보안 굿~) -->
         <input type="text" id="id" name="id" class="login" placeholder="아이디" required oninvalid="setCustomValidity('아이디를 입력하세요.')" oninput="setCustomValidity('')">
         <input type="password" id="password" name="password" class="login" placeholder="비밀번호" required oninvalid="setCustomValidity('비밀번호를 입력하세요.')" oninput="setCustomValidity('')">
     
         <input type="submit" value="로그인" id="login" class="out">
       </form>
       <div id="bottombox">
           <a href="jsp/signup.jsp" class="bottom">회원가입</a>
           <a href="jsp/find_id.jsp" class="bottom">아이디 찾기</a>
           <a href="jsp/find_password.jsp" class="bottom">비밀번호 찾기</a>
       </div>
   </div>
   
</body>
