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
   <script>

      var duplicateMessage = '<%= session.getAttribute("duplicateMessage") %>';
      var errorMessage = '<%= session.getAttribute("errorMessage") %>';
      var successMessage = '<%= session.getAttribute("successMessage") %>';
      var loginMessage = '<%= session.getAttribute("loginMessage") %>';
      if (successMessage && successMessage!== 'null') {
          alert(successMessage);
          <% session.removeAttribute("successMessage"); %>
      }
      if (duplicateMessage && duplicateMessage !== 'null') {
          alert(duplicateMessage);
          
          <% session.removeAttribute("duplicateMessage"); %>
      }

      if (errorMessage && errorMessage!== 'null') {
          alert(errorMessage);
          <% session.removeAttribute("errorMessage"); %>
      }
      if (loginMessage && loginMessage!== 'null') {
          alert(loginMessage);
          <% session.removeAttribute("loginMessage"); %>
      }

  </script>
</body>
