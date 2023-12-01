<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>
<body>

<%
try {
    // JDBC 드라이버 로드
    Class.forName("com.mysql.cj.jdbc.Driver");

    // 데이터베이스 연결
    Connection connection = DriverManager.getConnection("jdbc:mysql://localhost/week10", "haeju", "0930");

    // SQL 쿼리 선언
    String scheduleSql = "SELECT * FROM schedule WHERE user_idx = ?";

    // PreparedStatement 생성
    PreparedStatement preparedStatement = connection.prepareStatement(scheduleSql);

    // 사용자 인덱스 설정 (예시로 1로 설정)
    int userIndex = 1;
    preparedStatement.setInt(1, userIndex);

    // SQL 쿼리 실행
    ResultSet resultSet = preparedStatement.executeQuery();

    // 결과를 리스트에 추가
    List<String> dateList = new ArrayList<>();
    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");

    while (resultSet.next()) {
        // 날짜를 원하는 형식으로 포맷팅하여 리스트에 추가
        String date = dateFormat.format(resultSet.getDate("date"));
        dateList.add("'" + date + "'");
    }

    // JavaScript 코드로 데이터 직접 출력
    out.println("<script>");
    out.println("var dateList = [" + String.join(",", dateList) + "];");
    out.println("console.log(dateList);");
    out.println("</script>");

    // 각종 리소스 닫아주기
    resultSet.close();
    preparedStatement.close();
    connection.close();
} catch (ClassNotFoundException | SQLException e) {
    e.printStackTrace();
}
%>

</body>
</html>
