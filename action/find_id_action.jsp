<%@ page language="java" contentType="text/html" pageEncoding="utf-8" %>
<!-- 데이터베이스 탐색 라이브러리 -->
<%@ page import="java.sql.DriverManager"%>
<!-- 데이터베이스 연결 라이브러리 -->
<%@ page import="java.sql.Connection"%>
<!-- SQL 전송 라이브러리 -->
<%@ page import="java.sql.PreparedStatement"%>
<!-- 데어터 받아오기 라이브러리 -->
<%@ page import="java.sql.ResultSet"%>
<!-- 리스트 라이브러리 -->
<%@ page import="java.util.ArrayList"%>
<%
   // JSP 영역
   request.setCharacterEncoding("utf-8");
   String nameValue = request.getParameter("name");
   String phonenumValue = request.getParameter("phone_num");
   String cleanPhoneNumber = phonenumValue.replaceAll("[^0-9]", "");

   // 커넥터 파링 찾는 부분
   Class.forName("com.mysql.jdbc.Driver");
   // 데이터베이스 연결
   Connection connect = DriverManager.getConnection("jdbc:mysql://localhost/week10", "haeju", "0930");
   // SQL 만들기
   String sql = "SELECT * FROM user WHERE name=? AND phone_num=?";
   PreparedStatement query = connect.prepareStatement(sql);
   query.setString(1, nameValue);
   query.setString(2, cleanPhoneNumber);

   // SQL 전송
   ResultSet result = query.executeQuery();

   // 데이터 정제
   String name = null;
   String phone_num = null;
   String id = null;

   if (result.next()) {
       name = result.getString("name");
       phone_num = result.getString("phone_num");
       id = result.getString("id");
   }

   // 리다이렉션 조건 확인
   if (name == null || phone_num == null) {
      session.setAttribute("finderrorMessage", "정보가 존재하지 않습니다.");
      response.sendRedirect("../jsp/find_id.jsp");
  } else {
      session.setAttribute("loginMessage", "id: " + id);
      response.sendRedirect("../index.jsp");
  }
%>


<head>
   <meta charset="UTF-8">
   <meta name="viewport" content="width=device-width, initial-scale=1.0">
   <title>아이디 찾기</title>
   <script>
      var id = '<%= name %>';
      var pw = '<%= phone_num %>';
      console.log(id);
      console.log(pw);
      var id1 = '<%= nameValue %>';
      var pw1 = '<%= phonenumValue %>';
      console.log(id1);
      console.log(pw1);
   </script>
</head>
<body>
   <!-- 기타 내용 -->
</body>