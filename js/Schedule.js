function toggleMenu() {
   console.log('toggleMenu function called');
   var menuBox = document.getElementById('menuBox');
   var currentRight = parseInt(getComputedStyle(menuBox).right);

   // 메뉴의 현재 위치에 따라 다른 위치로 이동
   if (currentRight === 0) {
       menuBox.style.right = '-300px';
   } else {
       menuBox.style.right = '0';
   }
}
var month=null;
function getCurrentDate() {
   var currentDate = new Date();
   var year = currentDate.getFullYear();
   month = currentDate.getMonth() + 1; 
   var day = currentDate.getDate();
   return year + '-' + (month < 10 ? '0' + month : month) + '-' + (day < 10 ? '0' + day : day);
}

function setCurrentDate() {
   var currentDateElement = document.getElementById('currentDate');
   var yearElement = document.getElementById('year');

   var currentDate = getCurrentDate();
   var year = new Date().getFullYear(); // 현재 년도 가져오기

   // 엘리먼트의 내용 설정
   currentDateElement.textContent = currentDate;
   yearElement.textContent = year;
}

function changeYear(offset) {
   // 현재 연도를 가져오기
   var currentYear = parseInt(document.getElementById('year').innerText);

   // 새로운 연도 계산
   var newYear = currentYear + offset;

   // 연도 업데이트
   document.getElementById('year').innerText = newYear;
}

setCurrentDate();

function redrawTable() {
       // 기존의 표 내용을 모두 지움
       table.innerHTML = '';

       // 5행 반복
       var a = 1;
       var daysInMonth = getDaysInMonth(selectedMonth);
       var numRows = (daysInMonth <= 28) ? 4 : 5; // 28일 이하인 경우에는 4행, 그 이상일 경우에는 5행
       for (var i = 1; i <= numRows; i++) {
           // 새로운 행 생성
           var row = table.insertRow();

           for (var j = 1; j <= 7; j++) {
               var cell = row.insertCell();
               if (a <= daysInMonth) {
                   cell.textContent = a;
                   a++;
                   cell.style.fontFamily = 'EASTARJET-Medium';
                   var currentDate = new Date();
                   var day = currentDate.getDate()+1;
                   cell.style.backgroundColor = '#cddce8';
                   if (a === day) {
                       cell.style.backgroundColor = '#5caceb';
                   }
   
                   cell.addEventListener('click', function () {
                       if (selectedMonth) {
                           //alert('클릭한 셀: ' + this.textContent + ', 선택한 달: ' + selectedMonth);
                           showPopup();
                       }
                   });
               }
           }
       }
}

var selectedMember = null; 
function updateCondition(memberName) {
      selectedMember = memberName;
      console.log(selectedMember);
      if (selectedMember.trim() !== '내 일정 보기'){
         document.getElementById('memberName').innerHTML=selectedMember+" 팀원의 일정";
      }
      else if(selectedMember.trim() == '내 일정 보기'){
        console.log("야");
        document.getElementById('memberName').innerHTML='';
      }
}

document.addEventListener('DOMContentLoaded', function () {
   function showPopup() { 
       window.open("detail.html", "a", "width=400, height=400, left=100, top=50, scrollbars=yes"); 
   }




   var memberButtons = document.querySelectorAll('.member');
   var monthButtonContainer = document.getElementById('monthButtonBox');
   var table = document.getElementById('myTable');

   var selectedMonth = month;
   

   function redrawTable() {


       table.innerHTML = '';

       var a = 1;
       var daysInMonth = getDaysInMonth(selectedMonth);
       var numRows = (daysInMonth <= 28) ? 4 : 5; 
       // 28일 이하인 경우에는 4행, 그 이상일 경우에는 5행
       for (var i = 1; i <= numRows; i++) {
           var row = table.insertRow();

           for (var j = 1; j <= 7; j++) {
               var cell = row.insertCell();
               if (a <= daysInMonth) {
                   cell.textContent = a;
                   a++;
                   cell.style.fontFamily = 'EASTARJET-Medium';
                   var currentDate = new Date();
                   var day = currentDate.getDate()+1;
                   cell.style.backgroundColor = '#cddce8';
                   if (a === day) {
                       cell.style.backgroundColor = '#5caceb';
                   }
   
                   cell.addEventListener('click', function () {
                       if (selectedMonth) {
                           //alert('클릭한 셀: ' + this.textContent + ', 선택한 달: ' + selectedMonth);
                           if(selectedMember==null||selectedMember=='내 일정 보기'){
                              showPopup();
                           }
                           else{
                              window.open("detail_member.html", "a", "width=400, height=400, left=100, top=50, scrollbars=yes");

                           }
                       }
                   });
               }
           }
       }
   }

   function getDaysInMonth(month) {
       // 1, 3, 5, 7, 8, 10, 12월은 31일까지
       if ([1, 3, 5, 7, 8, 10, 12].includes(month)) {
           return 31;
       }
       // 4, 6, 9, 11월은 30일까지
       else if ([4, 6, 9, 11].includes(month)) {
           return 30;
       } else {
           return 28;
       }
   }

   for (var i = 1; i <= 12; i++) {
       var button = document.createElement('button');
       button.textContent = i;
       button.id = 'button' + i;
       button.classList.add('monthButton');

       button.addEventListener('click', function () {
           // 모든 월 버튼에 대한 스타일 초기화
           var allButtons = document.querySelectorAll('.monthButton');
           allButtons.forEach(function (btn) {
               btn.classList.remove('selectedButton');
           });

           // 현재 클릭한 버튼에 스타일 추가
           this.classList.add('selectedButton');

           var clickedMonth = parseInt(this.textContent);
           console.log('클릭한 버튼:', clickedMonth);

           // 클릭한 버튼의 값을 전역 변수에 저장
           selectedMonth = clickedMonth;

           // 표를 다시 그리는 함수 호출
           redrawTable();
       });
       monthButtonContainer.appendChild(button);

       if (i === selectedMonth) {
           button.click();
       }
   }
   redrawTable();


});
