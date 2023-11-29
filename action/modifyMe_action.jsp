<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true" %>
<%@ page import="java.sql.*" %>

<%
    request.setCharacterEncoding("utf-8");

    String idx = (String) session.getAttribute("idx");
    String name = request.getParameter("name");
    String phone_num = request.getParameter("phone_num");
    String department = request.getParameter("department");
    String position = request.getParameter("position");
    String password = request.getParameter("password");

    // 데이터베이스 연결
    try (Connection connect = DriverManager.getConnection("jdbc:mysql://localhost/week10", "haeju", "0930")) {
        // 회원가입 작업
        String cleanPhoneNumber = phone_num.replaceAll("[^0-9]", "");

        if (password.trim().isEmpty() || name.trim().isEmpty() || phone_num.trim().isEmpty() || cleanPhoneNumber.isEmpty()) {
            session.setAttribute("errorMessage", "항목을 모두 올바르게 채워주세요.");
            response.sendRedirect("../jsp/modifyMe.jsp?idx=" + idx);
        } else {
            // 비밀번호 정규식 확인
            String passwordRegex = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$";
            if (!password.matches(passwordRegex)) {
                session.setAttribute("errorMessage", "비밀번호는 최소 8자 이상, 영문과 숫자를 조합해야 합니다.");
                response.sendRedirect("../jsp/modifyMe.jsp?idx=" + idx);
            } else {
                // 전화번호 길이 확인
                if (cleanPhoneNumber.length() < 10) {
                    session.setAttribute("errorMessage", "전화번호는 10자 이상이어야 합니다.");
                    response.sendRedirect("../jsp/modifyMe.jsp?idx=" + idx);
                } else {
                    String sql = "UPDATE user SET password=?, name=?, phone_num=?, department=?, position=? WHERE idx=?";
                    try (PreparedStatement query = connect.prepareStatement(sql)) {
                        query.setString(1, password);
                        query.setString(2, name);
                        query.setString(3, cleanPhoneNumber);
                        query.setString(4, department);
                        query.setString(5, position);
                        query.setString(6, idx);

                        int rowsAffected = query.executeUpdate();

                        if (rowsAffected > 0) {
                            out.println("정보 수정 성공");
                            session.setAttribute("successMessage", "정보 수정 성공");

                            // 회원가입 성공 또는 실패에 상관없이 페이지를 리다이렉트합니다.
                            session.setAttribute("idx", idx);
                            response.sendRedirect("../jsp/Schedule.jsp");
                        } else {
                            out.println("정보 수정 실패");
                            session.setAttribute("errorMessage", "정보 수정 실패");
                            response.sendRedirect("../jsp/modifyMe.jsp?idx=" + idx);
                        }
                    }
                }
            }
        }
    } catch (SQLException e) {
        e.printStackTrace();
        out.println("실패: " + e.getMessage());
    }
%>

<head>
   <meta charset="UTF-8">
   <meta name="viewport" content="width=device-width, initial-scale=1.0">
   <title>Document</title>
</head>
<body>
   
</body>
<script>
   // JavaScript 변수 선언
   var idx = <%= idx %>;
   var password = '<%= password %>';
   var name = '<%= name %>';
   var phoneNum = '<%= phone_num %>'; // 수정: 변수명을 phoneNum으로 변경
   var position = '<%= position %>';
   var department = '<%= department %>';
   console.log("Received idx:", idx);
   console.log("Received idx:", password);
   console.log("Received idx:", phoneNum);
   console.log("Received idx:", position);
   console.log("Received idx:", department);
</script>
</html>
