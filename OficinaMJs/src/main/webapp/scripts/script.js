/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */

 function togglePassword() {
      const input = document.getElementById('password');
      const icon = document.getElementById('eyeIcon');
      if (input.type === 'password') {
        input.type = 'text';
        icon.innerHTML = '<path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94"/><path d="M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19"/><line x1="1" y1="1" x2="23" y2="23"/>';
      } else {
        input.type = 'password';
        icon.innerHTML = '<path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/>';
      }
    }

    document.getElementById('password').addEventListener('input', function () {
      const val = this.value;
      const statusTxt = document.getElementById('passwordStatus');
      const errorTxt = document.getElementById('passwordError');

      statusTxt.style.display = 'block';
      errorTxt.style.display = 'none';

      // 1. Verificar Sequências (123, abc, etc)
      const hasSequence = /(012|123|234|345|456|567|678|789|abc|bcd|cde)/i.test(val);

      if (hasSequence) {
        statusTxt.innerText = 'Senha Insegura';
        statusTxt.style.color = '#EF4444';
        errorTxt.innerText = 'A senha não deve conter sequências. Use uma mistura de símbolos, números e letras.';
        errorTxt.style.display = 'block';
        return;
      }

      // 2. Lógica de Força
      const hasLetters = /[A-Za-z]/.test(val);
      const hasNumbers = /\d/.test(val);
      const hasSpecial = /[@$!%*#?&]/.test(val);
      const isLongEnough = val.length >= 8;

      if (val.length === 0) {
        statusTxt.style.display = 'none';
      } else if (isLongEnough && hasLetters && hasNumbers && hasSpecial) {
        statusTxt.innerText = 'Forte';
        statusTxt.style.color = '#10B981';
      } else if (val.length >= 6 && (hasLetters || hasNumbers)) {
        statusTxt.innerText = 'Média';
        statusTxt.style.color = '#F59E0B';
      } else {
        statusTxt.innerText = 'Fraca';
        statusTxt.style.color = '#EF4444';
      }
    });

    // Validação final no Submit
    document.getElementById('loginForm').addEventListener('submit', function (e) {
      e.preventDefault();

      const email = document.getElementById('email').value;
      const password = document.getElementById('password').value;
      const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

      const isStrong = /^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$/.test(password);
      const hasSequence = /(012|123|234|345|456|567|678|789|abc|bcd|cde)/i.test(password);

      const emailError = document.getElementById('emailError');
      const passwordError = document.getElementById('passwordError');
      const successMsg = document.getElementById('successMsg');

      emailError.style.display = 'none';
      passwordError.style.display = 'none';
      successMsg.style.display = 'none';

      let valid = true;

      if (!emailRegex.test(email)) {
        emailError.style.display = 'block';
        valid = false;
      }

      if (!isStrong || hasSequence) {
        passwordError.innerText = hasSequence
          ? 'A senha não deve conter sequências numéricas ou alfabéticas.'
          : 'A senha deve ter 8+ caracteres, letras, números e símbolos.';
        passwordError.style.display = 'block';
        valid = false;
      }

      if (valid) {
        successMsg.style.display = 'block';
      }
    });