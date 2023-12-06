<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true" %>
<%@ page import="java.sql.*" %>

<%
    request.setCharacterEncoding("utf-8");

    String id = request.getParameter("id");
    String name = request.getParameter("name");
    String phone_num = request.getParameter("phone_num");
    String department = request.getParameter("department");
    String position = request.getParameter("position");
    String password = request.getParameter("password");
    session.setAttribute("positionValue", position);

    // 데이터베이스 연결
    try (Connection connect = DriverManager.getConnection("jdbc:mysql://localhost/week10", "haeju", "0930")) {
      //
        // 중복 확인 작업
        String idAction = request.getParameter("checkDuplicate");
        if ("true".equals(idAction)) {
            // 중복 확인 SQL을 정의
            String checkDuplicateSQL = "SELECT COUNT(*) FROM user WHERE id = ?";
            
            // 중복 확인을 수행
            try (PreparedStatement checkDuplicateQuery = connect.prepareStatement(checkDuplicateSQL)) {
                checkDuplicateQuery.setString(1, id);
                try (ResultSet result = checkDuplicateQuery.executeQuery()) {
                    if (result.next()) {
                        int count = result.getInt(1);
                        
                        String idRegex = "^[a-z]+[a-z0-9]{5,19}$";
                        if (!id.matches(idRegex)) {
                            session.setAttribute("duplicateMessage", "아이디 형식이 올바르지 않습니다.");
                        } else if (count > 0) {
                            session.setAttribute("duplicateMessage", "이미 사용 중인 아이디입니다.");
                        } else {
                            session.setAttribute("duplicateMessage", "사용 가능한 아이디입니다.");
                        }
                        session.setAttribute("idValue", id);
                        session.setAttribute("nameValue", name);
                        session.setAttribute("phone_numValue", phone_num);
                        //다 try에 넣어주기....
                        response.sendRedirect("../jsp/signup.jsp");
                    }
                }
            }
        } else {
            // 회원가입 작업
            String signupAction = request.getParameter("signup");
            if (signupAction != null) {
                String cleanPhoneNumber = phone_num.replaceAll("[^0-9]", "");

                if (id.trim().isEmpty() || password.trim().isEmpty() || name.trim().isEmpty() || phone_num.trim().isEmpty() || cleanPhoneNumber.length() < 10) {
                    session.setAttribute("errorMessage", "필수 항목을 모두 채워주세요. 또는 전화번호가 10자 이상이어야 합니다.");
                } else {
                    // 비밀번호 정규식 확인
                    String passwordRegex = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$";
                    if (!password.matches(passwordRegex)) {
                        session.setAttribute("errorMessage", "비밀번호는 최소 8자 이상, 영문과 숫자를 조합해야 합니다.");
                    } else {
                        // 전화번호 길이 확인
                        if (cleanPhoneNumber.length() < 10) {
                            session.setAttribute("errorMessage", "전화번호는 10자 이상이어야 합니다.");
                        } else {
                            // 전화번호 중복 확인 SQL을 정의
                            String checkDuplicatePhoneSQL = "SELECT COUNT(*) FROM user WHERE phone_num = ?";
                            
                            // 전화번호 중복 확인을 수행
                            try (PreparedStatement checkDuplicatePhoneQuery = connect.prepareStatement(checkDuplicatePhoneSQL)) {
                                checkDuplicatePhoneQuery.setString(1, cleanPhoneNumber);
                                try (ResultSet phoneResult = checkDuplicatePhoneQuery.executeQuery()) {
                                    if (phoneResult.next()) {
                                        int phoneCount = phoneResult.getInt(1);
                                        if (phoneCount > 0) {
                                            session.setAttribute("errorMessage", "이미 사용 중인 전화번호입니다.");
                                        } else {
                                            // 데이터를 삽입
                                            String sql = "INSERT INTO user(id, password, name, phone_num, department, position) VALUES (?, ?, ?, ?, ?, ?)";
                                            try (PreparedStatement query = connect.prepareStatement(sql)) {
                                                query.setString(1, id);
                                                query.setString(2, password);
                                                query.setString(3, name);
                                                query.setString(4, cleanPhoneNumber);
                                                query.setString(5, department);
                                                query.setString(6, position);
                                                query.executeUpdate();
                                                out.println("회원가입 성공");
                                                session.setAttribute("successMessage", "회원가입 성공");

                                                // 회원가입 성공 또는 실패에 상관없이 페이지를 리다이렉트합니다.
                                                session.setAttribute("idValue", id);
                                                session.setAttribute("nameValue", name);
                                                session.setAttribute("phone_numValue", phone_num);
                                                session.setAttribute("positionValue", position);
                                                session.setAttribute("departmentValue", department);
                                                response.sendRedirect("../index.jsp");
                                            }
                                        }
                                    }
                                }
                            }
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