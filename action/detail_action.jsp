<%@ page language="java" contentType="text/html" pageEncoding="utf-8" %>
<%@ page import="java.sql.*" %>

<%
request.setCharacterEncoding("UTF-8");

String user_idx = request.getParameter("user_idx");
String timeInput = request.getParameter("timeInput")+ ":00";
String eventInput = request.getParameter("eventInput");
String year = request.getParameter("year");
String month = request.getParameter("month");
String day = request.getParameter("day");

Connection connection = null;
PreparedStatement preparedStatement = null;

try {
    // Connection 객체 생성
    connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/week10", "haeju", "0930");

    // INSERT 쿼리 작성
    String insertQuery = "INSERT INTO schedule (user_idx, content, date, time) VALUES (?, ?, ?, ?)";

    // PreparedStatement를 사용하여 SQL 인젝션 방지
    preparedStatement = connection.prepareStatement(insertQuery);
    preparedStatement.setInt(1, Integer.parseInt(user_idx));
    preparedStatement.setString(2, eventInput);
    preparedStatement.setDate(3, java.sql.Date.valueOf(year + "-" + month + "-" + day));
    preparedStatement.setTime(4, java.sql.Time.valueOf(timeInput));

    // 쿼리 실행
    preparedStatement.executeUpdate();


    response.sendRedirect("../jsp/detail.jsp?user_idx=" + user_idx + "&year=" + year + "&month=" + month + "&day=" + day);


} catch (SQLException e) {
    e.printStackTrace(); // 실제 상황에서는 로깅이나 예외 처리를 적절히 수행해야 합니다.
} finally {
    // 사용한 자원 해제
    if (preparedStatement != null) {
        try {
            preparedStatement.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    if (connection != null) {
        try {
            connection.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
%>



<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>
<body>
    <div>
        Received Time: <%= timeInput %>
    </div>
    <div>
        Received Event: <%= eventInput %>
    </div>
    <%= user_idx %>
    <%= year %>
    <%= month %>
    <%= day %>
</body>