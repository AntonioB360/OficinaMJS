/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */


document.getElementById('password').addEventListener('input', function() {
    const val = this.value;
    const statusTxt = document.getElementById('passwordStatus');
    const errorTxt = document.getElementById('passwordError');
    
    statusTxt.classList.remove('hidden');
    errorTxt.classList.add('hidden');

    // 1. Verificar Sequências (123, abc, etc)
    const hasSequence = /(012|123|234|345|456|567|678|789|abc|bcd|cde)/i.test(val);

    if (hasSequence) {
        statusTxt.innerText = "Senha Insegura";
        statusTxt.className = "text-xs font-bold mt-2 uppercase text-red-500";
        errorTxt.innerText = "A senha não deve conter sequências. Use uma mistura de símbolos, números e letras.";
        errorTxt.classList.remove('hidden');
        return;
    }

    // 2. Lógica de Força
    const hasLetters = /[A-Za-z]/.test(val);
    const hasNumbers = /\d/.test(val);
    const hasSpecial = /[@$!%*#?&]/.test(val);
    const isLongEnough = val.length >= 8;

    if (val.length === 0) {
        statusTxt.classList.add('hidden');
    } else if (isLongEnough && hasLetters && hasNumbers && hasSpecial) {
        statusTxt.innerText = "Forte";
        statusTxt.className = "text-xs font-bold mt-2 uppercase text-green-400";
    } else if (val.length >= 6 && (hasLetters || hasNumbers)) {
        statusTxt.innerText = "Média";
        statusTxt.className = "text-xs font-bold mt-2 uppercase text-yellow-500";
    } else {
        statusTxt.innerText = "Fraca";
        statusTxt.className = "text-xs font-bold mt-2 uppercase text-red-400";
    }
});

// Validação final no Submit
document.getElementById('loginForm').addEventListener('submit', function(e) {
    const email = document.getElementById('email').value;
    const password = document.getElementById('password').value;
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    
    // Critério final: Senha forte
    const isStrong = /^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$/.test(password);
    const hasSequence = /(012|123|234|345|456|567|678|789|abc|bcd|cde)/i.test(password);

    let valid = true;

    if (!emailRegex.test(email)) {
        document.getElementById('emailError').classList.remove('hidden');
        valid = false;
    }

    if (!isStrong || hasSequence) {
        document.getElementById('passwordError').classList.remove('hidden');
        valid = false;
    }

    if (!valid) e.preventDefault();
});