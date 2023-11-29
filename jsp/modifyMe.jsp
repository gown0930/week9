<%@ page language="java" contentType="text/html" pageEncoding="utf-8" %>
<%@ page import="java.sql.*" %>
<%
   String idx = request.getParameter("idx");
    // idx를 사용하여 필요한 작업 수행
    Connection connect = null;
    PreparedStatement preparedStatement = null;
    ResultSet resultSet = null;

    // 변수 선언
    String id = null;
    String password = null;
    String name = null;
    String phoneNum = null;
    String position = null;
    String department = null;


    try {
        // 데이터베이스 연결
        connect = DriverManager.getConnection("jdbc:mysql://localhost/week10", "haeju", "0930");

        // SQL 문 실행
        String sql = "SELECT id, password, name, phone_num, position, department FROM user WHERE idx = ?";
        preparedStatement = connect.prepareStatement(sql);
        preparedStatement.setString(1, idx);
        resultSet = preparedStatement.executeQuery();

        // 결과 처리
        if (resultSet.next()) {
            id = resultSet.getString("id");
            password = resultSet.getString("password");
            name = resultSet.getString("name");
            phoneNum = resultSet.getString("phone_num");
            position = resultSet.getString("position");
            department = resultSet.getString("department");

        } else {
            out.println("사용자 정보를 찾을 수 없습니다.");
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        // 연결 종료
        if (resultSet != null) resultSet.close();
        if (preparedStatement != null) preparedStatement.close();
        if (connect != null) connect.close();
    }
%>
   <head>
      <meta charset="UTF-8"> 
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <title>내 정보 수정</title>
      <link rel="stylesheet" type="text/css" href="../css/modifyMe.css">
   </head>
   <body>
      <div id="header">Schedule Calendar</div>
      <div id="imformBox">
         <form action="../action/modifyMe_action.jsp" method="post">
             <div id="title">내 정보 수정</div>
             <div id="id" name="id"></div>
     
             <div id="duplicateMessage" class="message"></div>
             <input type="password" name="password" class="signup" id="password" placeholder="비밀번호" oninput="checkPasswordMatch()" required>
             <input type="password" class="signup" id="confirmPassword" placeholder="비밀번호 확인" oninput="checkPasswordMatch()" required>
             <p id="passwordMatchMessage" class="message"></p>
             <span id="passwordErrorMessage" class="message"></span>
     
             <input type="text" name="name" id="name" class="signup" placeholder="이름" required>
     
             <input type="text" name="phone_num" id="phone" class="signup" placeholder="전화번호" oninput="formatPhoneNumber()" maxlength="13" required>
             <div class="selectBox">
                 <div for="department">부서</div>
                 <input type="radio" id="개발" name="department" value="개발" required>
                 <label for="devDept">개발</label>
                 <input type="radio" id="디자인" name="department" value="디자인" required>
                 <label for="designDept">디자인</label>
             </div>
     
             <div class="selectBox">
                 <div for="position">직급</div>
                 <input type="radio" id="팀장" name="position" value="팀장" required>
                 <label for="teamLead">팀장</label>
                 <input type="radio" id="팀원" name="position" value="팀원" required>
                 <label for="teamMember">팀원</label>
             </div>
             <div id="errorMessage" class="message"></div>
             <div id="buttonBox">
                 <button type="submit" id="submit" class="out">저장</button>
             </div>
         </form>
         <div id="buttonBox">
            <button type="button" onclick="window.location.href='Schedule.jsp'" class="out">취소</button>
         </div>
     </div>

         <script src="../js/modifyMe.js"></script>
         <script>

            var errorMessage = '<%= session.getAttribute("errorMessage") %>';
            if (errorMessage && errorMessage!== 'null') {
               alert(errorMessage);
               <% session.removeAttribute("errorMessage"); %>
            }

            var idx = <%= idx %>;
            var id = '<%= id %>';
            var password = '<%= password %>';
            var name = '<%= name %>';
            var phoneNum = '<%= phoneNum %>';
            var position = '<%= position %>';
            var department = '<%= department %>';

            var passwordInput = document.getElementById("password");
            var confirmPasswordInput = document.getElementById("confirmPassword");
            var passwordMatchMessage = document.getElementById("passwordMatchMessage");
            var passwordErrorMessage = document.getElementById("passwordErrorMessage");


            // 여기에서 변수를 사용하여 필요한 작업을 수행할 수 있습니다.
            console.log("Received idx:", idx);
            console.log("ID:", id);
            console.log("Password:", password);
            console.log("Name:", name);
            console.log("Phone Number:", phoneNum);
            console.log("Position:", position);
            console.log("Department:", department);
         
            // JSP 변수에서 값을 가져와 innerHTML로 설정
            document.getElementById("id").innerHTML = id;
            document.getElementById("password").value = password;
            document.getElementById("confirmPassword").value = password;
            document.getElementById("name").value = name;
            document.getElementById("phone").value = phoneNum;

            var radioBtn = document.getElementById(department);
            if (radioBtn) {
               radioBtn.checked = true;
            }
            var radioBtn = document.getElementById(position);
            if (radioBtn) {
               radioBtn.checked = true;
            }


            //비밀번호 일치 여부 및 정규식
            function checkPasswordMatch() {
               var password = passwordInput.value;
               var confirmPassword = confirmPasswordInput.value;

               validatePasswordMatch(password, confirmPassword);
               validatePasswordRegex(password);
            }

            function validatePasswordMatch(password, confirmPassword) {
               if (password === confirmPassword) {
                  passwordMatchMessage.textContent = "비밀번호가 일치합니다.";
                  passwordMatchMessage.style.color = "green";
               } else {
                  passwordMatchMessage.textContent = "비밀번호가 일치하지 않습니다.";
                  passwordMatchMessage.style.color = "red";
               }
            }

            function validatePasswordRegex(password) {
               var passwordRegex = /^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$/;
               if (!passwordRegex.test(password)) {
                  passwordErrorMessage.textContent = '비밀번호는 최소 8자 이상, 영문과 숫자를 조합해야 합니다.';
                  passwordErrorMessage.style.color = "red";
               } else {
                  passwordErrorMessage.textContent = '';
               }
            }

            
            function formatPhoneNumber() {
                var phoneNumber = document.getElementById('phone').value;
    
                // 정규식을 사용하여 형식에 맞게 변환
                phoneNumber = phoneNumber.replace(/[^0-9]/g, ''); // 숫자 이외의 문자 제거
                var formattedPhoneNumber = phoneNumber.replace(/(\d{3})(\d{4})(\d{4})/, '$1-$2-$3');
   
                // 변환된 전화번호를 다시 입력 폼에 설정
                document.getElementById('phone').value = formattedPhoneNumber;
             }
         </script>
   </body>
