var passwordInput = document.getElementById("password");
var confirmPasswordInput = document.getElementById("confirmPassword");
var passwordMatchMessage = document.getElementById("passwordMatchMessage");
var passwordErrorMessage = document.getElementById("passwordErrorMessage");

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