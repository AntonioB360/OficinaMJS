<%-- 
    Document   : RecuperacaoCredencias
    Created on : 11/05/2026, 22:40:27
    Author     : T
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="pt">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Recuperar Acesso</title>
  <script src="https://cdn.tailwindcss.com"></script>
  <style>
    /* [CSS PURO] motivo: gradiente de fundo LOGIN_BACKGROUND_GRADIENT_START (#0A2540) → LOGIN_BACKGROUND_GRADIENT_END (#3B82F6) não disponível como classe Tailwind padrão */
    .login-bg {
      background: linear-gradient(135deg, #0A2540 0%, #3B82F6 100%);
      min-height: 100vh;
    }

    /* [CSS PURO] motivo: ring de foco com cor exata LOGIN_INPUT_FOCUS (#3B82F6) e opacidade personalizada não coberta pelo Tailwind padrão */
    .input-tel:focus {
      outline: none;
      border-color: #3B82F6;
      box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.18);
    }

    /* [CSS PURO] motivo: estado de erro usando COLOR_ERROR (#EF4444) no border e COLOR_ERROR_BG (#FEE2E2) no background num único seletor */
    .input-tel.error {
      border-color: #EF4444;
      background-color: #FEE2E2;
    }
    .input-tel.error:focus {
      box-shadow: 0 0 0 3px rgba(239, 68, 68, 0.15);
    }

    /* [CSS PURO] motivo: estado de sucesso usando COLOR_SUCCESS (#10B981) — não há utilitário Tailwind padrão para border + background combinados neste estado */
    .input-tel.success {
      border-color: #10B981;
      background-color: #D1FAE5;
    }

    /* [CSS PURO] motivo: animação de shake para feedback de erro — keyframe não disponível no Tailwind padrão */
    @keyframes shake {
      0%, 100% { transform: translateX(0); }
      20%       { transform: translateX(-6px); }
      40%       { transform: translateX(6px); }
      60%       { transform: translateX(-4px); }
      80%       { transform: translateX(4px); }
    };
    .shake { animation: shake 0.35s ease; }

    /* [CSS PURO] motivo: transição suave de opacidade e altura para mensagem de erro — Tailwind não cobre height:0→auto animado */
    .msg-error {
      max-height: 0;
      overflow: hidden;
      opacity: 0;
      transition: max-height 0.25s ease, opacity 0.25s ease;
    }
    .msg-error.visible {
      max-height: 40px;
      opacity: 1;
    }

    /* [CSS PURO] motivo: efeito de loading no botão com animação de spin customizada no pseudo-elemento */
    .btn-loading {
      pointer-events: none;
      opacity: 0.8;
    }
  </style>
</head>

<body class="login-bg flex items-center justify-center px-4 py-12">

  <!-- LOGIN_CARD_BG = #FFFFFF -->
  <div class="w-full max-w-sm rounded-2xl shadow-2xl overflow-hidden" style="background-color: #FFFFFF;">

    <!-- Topo do card com ícone -->
    <div class="flex flex-col items-center pt-10 pb-6 px-8">

      <!-- Ícone -->
      <div class="w-14 h-14 rounded-2xl flex items-center justify-center mb-5" style="background-color: #DBEAFE;">
        <!-- COLOR_INFO_BG = #DBEAFE -->
        <svg class="w-7 h-7" viewBox="0 0 24 24" fill="none" stroke="#3B82F6" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
          <!-- COLOR_PRIMARY_500 = #3B82F6 -->
          <rect x="5" y="11" width="14" height="10" rx="2" ry="2"></rect>
          <path d="M8 11V7a4 4 0 0 1 8 0v4"></path>
        </svg>
      </div>

      <h1 class="text-xl font-semibold text-center" style="color: #0A2540;">
        <!-- COLOR_TEXT_PRIMARY = #0A2540 -->
        Recuperar acesso
      </h1>
      <p class="text-sm text-center mt-2 leading-relaxed" style="color: #64748B;">
        <!-- COLOR_TEXT_SECONDARY = #64748B -->
        Introduza o seu número de telefone.<br/>Enviaremos um código para repor o acesso.
      </p>

    </div>

    <!-- Formulário -->
    <div class="px-8 pb-10">

      <div class="mb-5">
        <label class="block text-xs font-semibold mb-2" style="color: #0A2540;">
          Número de Telefone
        </label>

        <!-- Input com prefixo -->
        <div class="flex rounded-xl border transition-all overflow-hidden" id="input-wrapper" style="border-color: #CBD5F5; background-color: #F8FAFC;">
          <!-- LOGIN_INPUT_BORDER = #CBD5F5 -->

          <!-- Prefixo +244 -->
          <div class="flex items-center px-3 border-r text-sm font-semibold flex-shrink-0" style="border-color: #CBD5F5; color: #0A2540; background-color: #F1F5F9;">
            +244
          </div>

          <input
            id="telefone"
            type="tel"
            placeholder="9XX XXX XXX"
            maxlength="11"
            oninput="handleInput(this)"
            class="input-tel flex-1 px-3 py-3 text-sm bg-transparent border-none transition-all"
            style="color: #0A2540;"
          />
        </div>

        <!-- Mensagem de erro -->
        <div class="msg-error" id="err-tel">
          <p class="text-xs mt-2" style="color: #EF4444;">
            Introduza um número de telefone válido.
          </p>
        </div>
      </div>

      <!-- Botão Enviar -->
      <button
        id="btn-enviar"
        type="button"
        onclick="submitForm()"
        class="w-full py-3 rounded-xl text-sm font-semibold text-white transition-all"
        style="background-color: #2563EB;"
        onmouseover="this.style.backgroundColor='#1D4ED8';"
        onmouseout="this.style.backgroundColor='#2563EB';"
      >
        <!-- COLOR_PRIMARY_600 = #2563EB -->
        Enviar código
      </button>

      <!-- Link voltar -->
      <div class="text-center mt-6">
        <a
          href="Login.jsp"
          class="text-xs font-medium transition-colors"
          style="color: #64748B;"
          onmouseover="this.style.color='#0A2540';"
          onmouseout="this.style.color='#64748B';"
        >
          ← Voltar ao início de sessão
        </a>
      </div>

    </div>
  </div>

  <!-- Estado: código enviado (oculto por defeito) -->
  <div
    id="success-state"
    class="hidden w-full max-w-sm rounded-2xl shadow-2xl overflow-hidden text-center px-8 py-12"
    style="background-color: #FFFFFF;"
  >
    <div class="w-14 h-14 rounded-2xl flex items-center justify-center mx-auto mb-5" style="background-color: #D1FAE5;">
      <!-- COLOR_SUCCESS_BG = #D1FAE5 -->
      <svg class="w-7 h-7" viewBox="0 0 24 24" fill="none" stroke="#10B981" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
        <!-- COLOR_SUCCESS = #10B981 -->
        <polyline points="20 6 9 17 4 12"></polyline>
      </svg>
    </div>
    <h2 class="text-xl font-semibold mb-2" style="color: #0A2540;">Código enviado</h2>
    <p class="text-sm leading-relaxed" style="color: #64748B;">
      Verifique as mensagens do número<br/>
      <span id="numero-confirmado" class="font-semibold" style="color: #0A2540;"></span>
    </p>
    <button
      type="button"
      onclick="voltarForm()"
      class="mt-8 text-xs font-medium transition-colors"
      style="color: #64748B;"
      onmouseover="this.style.color='#0A2540';"
      onmouseout="this.style.color='#64748B';"
    >
      ← Usar outro número
    </button>
  </div>

  <script>
    function handleInput(input) {
      // Formata enquanto digita: 9XX XXX XXX
      let v = input.value.replace(/\D/g, '').slice(0, 9);
      if (v.length > 6)      v = v.slice(0, 3) + ' ' + v.slice(3, 6) + ' ' + v.slice(6);
      else if (v.length > 3) v = v.slice(0, 3) + ' ' + v.slice(3);
      input.value = v;

      // Feedback visual em tempo real após o utilizador ter escrito suficiente
      const raw = v.replace(/\s/g, '');
      if (raw.length === 9) {
        setValid(/^9\d{8}$/.test(raw));
      } else {
        // Enquanto digita, limpa sem mostrar erro
        clearState();
      }
    }

    function setValid(isValid) {
      const input   = document.getElementById('telefone');
      const errMsg  = document.getElementById('err-tel');
      const wrapper = document.getElementById('input-wrapper');

      if (isValid) {
        input.classList.remove('error');
        input.classList.add('success');
        // [CSS PURO] — cores de sucesso aplicadas via JS para manter consistência com a classe .success
        wrapper.style.borderColor = '#10B981'; // COLOR_SUCCESS
        errMsg.classList.remove('visible');
      } else {
        input.classList.remove('success');
        input.classList.add('error');
        wrapper.style.borderColor = '#EF4444'; // COLOR_ERROR
        errMsg.classList.add('visible');
        // Shake no wrapper
        wrapper.classList.remove('shake');
        void wrapper.offsetWidth; // reflow para reiniciar animação
        wrapper.classList.add('shake');
      }
    }

    function clearState() {
      const input   = document.getElementById('telefone');
      const wrapper = document.getElementById('input-wrapper');
      const errMsg  = document.getElementById('err-tel');
      input.classList.remove('error', 'success');
      wrapper.style.borderColor = '#CBD5F5'; // LOGIN_INPUT_BORDER
      errMsg.classList.remove('visible');
    }

    function submitForm() {
      const raw = document.getElementById('telefone').value.replace(/\s/g, '');
      const valido = /^9\d{8}$/.test(raw);

      if (!valido) {
        setValid(false);
        return;
      }

      // Feedback de loading no botão
      const btn = document.getElementById('btn-enviar');
      btn.textContent = 'A enviar...';
      btn.classList.add('btn-loading');

      // Simula envio
      setTimeout(() => {
        const form    = document.querySelector('.w-full.max-w-sm:not(#success-state)');
        const success = document.getElementById('success-state');
        const numero  = document.getElementById('telefone').value;

        document.getElementById('numero-confirmado').textContent = '+244 ' + numero;

        form.classList.add('hidden');
        success.classList.remove('hidden');
      }, 1200);
    }

    function voltarForm() {
      const form    = document.querySelector('.w-full.max-w-sm:not(#success-state)');
      const success = document.getElementById('success-state');
      const btn     = document.getElementById('btn-enviar');

      document.getElementById('telefone').value = '';
      clearState();
      btn.textContent = 'Enviar código';
      btn.classList.remove('btn-loading');

      success.classList.add('hidden');
      form.classList.remove('hidden');
    }
  </script>
</body>
</html>
