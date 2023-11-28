var passwordInput = document.getElementById("password");
var confirmPasswordInput = document.getElementById("confirmPassword");
var passwordMatchMessage = document.getElementById("passwordMatchMessage");
var passwordErrorMessage = document.getElementById("passwordErrorMessage");

// 비밀번호 일치 여부 및 정규식
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

// 중복 확인 버튼 클릭 시 실행되는 함수
function DuplicateEvent() {
    var id = document.getElementsByName('id')[0].value;
    // AJAX 등을 사용하여 서버로 중복 확인 요청을 보낸 후 결과를 처리하는 코드
    // 여기서는 간단히 query string을 이용하여 GET 요청을 보내는 것으로 가정합니다.
    window.location.href = "../action/signup_action.jsp?checkDuplicate=true&id=" + id;
    // 아래 코드는 제거했습니다.
    // document.forms[0].submit();
}

// 아이디 유효성 검사 함수
function validateId() {
    var idInput = document.getElementsByName('id')[0];
    var idRegex = /^[a-z]+[a-z0-9]{6,19}$/;

    if (!idRegex.test(idInput.value)) {
        document.getElementById('duplicateMessage').innerHTML = '';
        document.getElementById('errorMessage').innerHTML = '사용 불가능한 아이디입니다.';
        document.getElementById('errorMessage').style.color = "red";
        idInput.classList.add('error');
    } else {
        document.getElementById('errorMessage').innerHTML = '';
        idInput.classList.remove('error');
    }
}
