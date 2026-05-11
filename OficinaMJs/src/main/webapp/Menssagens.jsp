<%-- 
    Document   : Menssagens
    Created on : 11/05/2026, 23:36:58
    Author     : T
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<!DOCTYPE html>
<html lang="pt">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Mensagens</title>
  <script src="https://cdn.tailwindcss.com"></script>
  <style>
    /* [CSS PURO] motivo: altura total da viewport sem overflow — layout de chat fixo não é coberto pelo Tailwind sem config customizada */
    html, body {
      height: 100%;
      overflow: hidden;
      margin: 0;
      background-color: #F1F5F9; /* CHAT_BG */
    }

    .chat-wrapper {
      height: 100vh;
      display: flex;
      flex-direction: column;
      max-width: 780px;
      margin: 0 auto;
      background-color: #FFFFFF; /* CHAT_CONTAINER */
    }

    /* [CSS PURO] motivo: área de mensagens com scroll e flex inverso para âncora no fundo — flex-col-reverse + overflow não disponível combinado no Tailwind padrão */
    .msg-area {
      flex: 1;
      overflow-y: auto;
      display: flex;
      flex-direction: column;
      padding: 1.25rem 1rem;
      gap: 0.5rem;
    }

    /* [CSS PURO] motivo: scrollbar discreta customizada — não disponível no Tailwind padrão */
    .msg-area::-webkit-scrollbar { width: 4px; }
    .msg-area::-webkit-scrollbar-track { background: transparent; }
    .msg-area::-webkit-scrollbar-thumb { background: #E2E8F0; border-radius: 4px; }

    /* [CSS PURO] motivo: balão de mensagem enviada com border-radius assimétrico — não disponível no Tailwind padrão */
    .bubble-sent {
      background-color: #3B82F6; /* CHAT_SENT_BG */
      color: #FFFFFF;            /* CHAT_SENT_TEXT */
      border-radius: 18px 18px 4px 18px;
      padding: 0.6rem 0.9rem;
      max-width: 68%;
      word-break: break-word;
      font-size: 0.875rem;
      line-height: 1.5;
      align-self: flex-end;
    }

    /* [CSS PURO] motivo: balão de mensagem recebida com border-radius assimétrico oposto */
    .bubble-recv {
      background-color: #E2E8F0; /* CHAT_RECEIVED_BG */
      color: #0A2540;            /* CHAT_RECEIVED_TEXT */
      border-radius: 18px 18px 18px 4px;
      padding: 0.6rem 0.9rem;
      max-width: 68%;
      word-break: break-word;
      font-size: 0.875rem;
      line-height: 1.5;
      align-self: flex-start;
    }

    /* [CSS PURO] motivo: animação de entrada das mensagens — não disponível no Tailwind padrão */
    @keyframes popIn {
      from { opacity: 0; transform: translateY(8px) scale(0.97); }
      to   { opacity: 1; transform: translateY(0) scale(1); }
    }
    .bubble-sent, .bubble-recv { animation: popIn 0.18s ease both; }

    /* [CSS PURO] motivo: textarea com auto-resize via JS precisa de overflow:hidden e resize:none — Tailwind cobre resize mas não a combinação com height:auto */
    .msg-input {
      resize: none;
      overflow: hidden;
      min-height: 40px;
      max-height: 140px;
      overflow-y: auto;
      background-color: #FFFFFF; /* CHAT_INPUT_BG */
      border: 1.5px solid #CBD5F5; /* CHAT_INPUT_BORDER */
      border-radius: 12px;
      padding: 0.6rem 0.85rem;
      font-size: 0.875rem;
      color: #0A2540;
      font-family: inherit;
      width: 100%;
      outline: none;
      transition: border-color 0.18s;
      line-height: 1.5;
    }
    .msg-input:focus {
      border-color: #3B82F6; /* CHAT_INPUT_FOCUS */
      box-shadow: 0 0 0 3px rgba(59,130,246,0.12);
    }
    .msg-input::placeholder { color: #94A3B8; }

    /* [CSS PURO] motivo: popup de anexo com seta decorativa via pseudo-elemento — não disponível no Tailwind padrão */
    .anexo-popup {
      position: absolute;
      bottom: calc(100% + 10px);
      left: 0;
      background-color: #FFFFFF;
      border: 1.5px solid #E2E8F0;
      border-radius: 12px;
      padding: 0.5rem;
      box-shadow: 0 8px 24px rgba(10,37,64,0.12);
      display: none;
      flex-direction: column;
      gap: 2px;
      min-width: 160px;
      z-index: 50;
    }
    .anexo-popup.open { display: flex; }
    .anexo-popup::after {
      content: '';
      position: absolute;
      bottom: -7px;
      left: 14px;
      width: 12px;
      height: 12px;
      background: #FFFFFF;
      border-right: 1.5px solid #E2E8F0;
      border-bottom: 1.5px solid #E2E8F0;
      transform: rotate(45deg);
    }

    /* [CSS PURO] motivo: botão de envio desactivado com opacidade e cursor — combinar opacity + pointer-events + cursor num estado disabled não é coberto limpo pelo Tailwind */
    .btn-send:disabled {
      opacity: 0.35;
      cursor: not-allowed;
    }
    .btn-send:not(:disabled):hover {
      background-color: #1D4ED8;
    }

    /* [CSS PURO] motivo: badge do indicador online com pulse — pseudo-elemento animado não disponível no Tailwind padrão */
    @keyframes pulse-online {
      0%, 100% { transform: scale(1); opacity: 1; }
      50%       { transform: scale(1.5); opacity: 0.5; }
    };
    .dot-online {
      width: 9px;
      height: 9px;
      border-radius: 50%;
      background-color: #10B981; /* COLOR_SUCCESS */
      animation: pulse-online 2.2s ease-in-out infinite;
      flex-shrink: 0;
    }
    .dot-offline {
      width: 9px;
      height: 9px;
      border-radius: 50%;
      background-color: #94A3B8;
      flex-shrink: 0;
    }

    /* [CSS PURO] motivo: contador de caracteres com transição de cor ao aproximar do limite — transição em color não disponível no Tailwind padrão */
    .char-counter {
      font-size: 0.68rem;
      transition: color 0.2s;
    }

    /* [CSS PURO] motivo: preview de anexo com chip removível — layout específico não coberto pelo Tailwind padrão */
    .anexo-chip {
      display: inline-flex;
      align-items: center;
      gap: 6px;
      background-color: #DBEAFE; /* COLOR_INFO_BG */
      border: 1px solid #BFDBFE;
      border-radius: 8px;
      padding: 4px 8px;
      font-size: 0.72rem;
      color: #1D4ED8;
      max-width: 200px;
    }
  </style>
</head>

<body>
<div class="chat-wrapper">

  <!-- ===== CABEÇALHO ===== -->
  <div
    class="flex items-center gap-3 px-4 py-3 border-b flex-shrink-0"
    style="background-color: #FFFFFF; border-color: #E2E8F0;"
  >
    <!-- Avatar -->
    <div
      class="w-10 h-10 rounded-full flex items-center justify-center font-semibold text-sm text-white flex-shrink-0"
      style="background: linear-gradient(135deg, #0A2540 0%, #3B82F6 100%);"
    >
      <!-- [CSS PURO] motivo: gradiente no avatar — LOGIN_BACKGROUND_GRADIENT_START/END da paleta -->
      AF
    </div>

    <!-- Nome e estado -->
    <div class="flex-1 min-w-0">
      <p class="text-sm font-semibold truncate" style="color: #0A2540;">Ana Fernandes</p>
      <div class="flex items-center gap-1.5 mt-0.5" id="estado-wrapper">
        <div class="dot-online" id="dot-estado"></div>
        <span class="text-xs" id="label-estado" style="color: #10B981;">Online</span>
      </div>
    </div>

    <!-- Botão alternar estado (demo) -->
    <button
      type="button"
      onclick="alternarEstado()"
      class="text-xs px-2.5 py-1 rounded-lg border transition-all"
      style="color: #64748B; border-color: #E2E8F0; background-color: #F8FAFC;"
      title="Alternar estado (demo)"
    >Demo</button>
  </div>

  <!-- ===== ÁREA DE MENSAGENS ===== -->
  <div class="msg-area" id="msg-area">

    <!-- Separador de data -->
    <div class="flex items-center gap-3 my-2">
      <div class="flex-1 h-px" style="background-color: #E2E8F0;"></div>
      <span class="text-xs px-2" style="color: #94A3B8;">Hoje</span>
      <div class="flex-1 h-px" style="background-color: #E2E8F0;"></div>
    </div>

    <!-- Mensagens de exemplo -->
    <div class="flex flex-col gap-1" style="align-items: flex-start;">
      <div class="bubble-recv">Bom dia! A viatura já está pronta para levantamento.</div>
      <span class="text-xs px-1" style="color: #94A3B8;">09:14</span>
    </div>

    <div class="flex flex-col gap-1" style="align-items: flex-end;">
      <div class="bubble-sent">Óptimo, obrigado pela informação. Vou lá buscar ao fim da tarde.</div>
      <span class="text-xs px-1" style="color: #94A3B8;">09:16</span>
    </div>

    <div class="flex flex-col gap-1" style="align-items: flex-start;">
      <div class="bubble-recv">Perfeito, estaremos cá até às 18h.</div>
      <span class="text-xs px-1" style="color: #94A3B8;">09:17</span>
    </div>

  </div>

  <!-- ===== ÁREA DE COMPOSIÇÃO ===== -->
  <div class="flex-shrink-0 border-t px-3 py-3" style="background-color: #FFFFFF; border-color: #E2E8F0;">

    <!-- Preview de anexo (oculto por defeito) -->
    <div id="anexo-preview" class="hidden mb-2 flex-wrap gap-2 px-1"></div>

    <div class="flex items-end gap-2">

      <!-- Botão de anexo com popup -->
      <div class="relative flex-shrink-0" id="anexo-wrapper">
        <button
          type="button"
          id="btn-anexo"
          onclick="toggleAnexo(event)"
          class="w-10 h-10 rounded-xl flex items-center justify-center transition-all border"
          style="background-color: #F8FAFC; border-color: #E2E8F0; color: #64748B;"
          onmouseover="this.style.backgroundColor='#DBEAFE'; this.style.color='#3B82F6'; this.style.borderColor='#BFDBFE';"
          onmouseout="this.style.backgroundColor='#F8FAFC'; this.style.color='#64748B'; this.style.borderColor='#E2E8F0';"
          title="Anexar ficheiro"
        >
          <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <path d="M21.44 11.05l-9.19 9.19a6 6 0 0 1-8.49-8.49l9.19-9.19a4 4 0 0 1 5.66 5.66L9.41 17.41a2 2 0 0 1-2.83-2.83l8.49-8.48"/>
          </svg>
        </button>

        <!-- Popup de opções -->
        <div class="anexo-popup" id="anexo-popup">

          <button type="button" onclick="anexarTipo('foto')"
            class="flex items-center gap-3 px-3 py-2 rounded-lg text-sm font-medium transition-all text-left w-full"
            style="color: #0A2540;"
            onmouseover="this.style.backgroundColor='#F1F5F9';"
            onmouseout="this.style.backgroundColor='transparent';"
          >
            <span class="w-7 h-7 rounded-lg flex items-center justify-center flex-shrink-0" style="background-color: #DBEAFE;">
              <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="#3B82F6" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <rect x="3" y="3" width="18" height="18" rx="2"/><circle cx="8.5" cy="8.5" r="1.5"/><polyline points="21 15 16 10 5 21"/>
              </svg>
            </span>
            Foto
          </button>

          <button type="button" onclick="anexarTipo('audio')"
            class="flex items-center gap-3 px-3 py-2 rounded-lg text-sm font-medium transition-all text-left w-full"
            style="color: #0A2540;"
            onmouseover="this.style.backgroundColor='#F1F5F9';"
            onmouseout="this.style.backgroundColor='transparent';"
          >
            <span class="w-7 h-7 rounded-lg flex items-center justify-center flex-shrink-0" style="background-color: #D1FAE5;">
              <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="#10B981" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M12 1a3 3 0 0 0-3 3v8a3 3 0 0 0 6 0V4a3 3 0 0 0-3-3z"/><path d="M19 10v2a7 7 0 0 1-14 0v-2"/><line x1="12" y1="19" x2="12" y2="23"/><line x1="8" y1="23" x2="16" y2="23"/>
              </svg>
            </span>
            Áudio
          </button>

          <button type="button" onclick="anexarTipo('documento')"
            class="flex items-center gap-3 px-3 py-2 rounded-lg text-sm font-medium transition-all text-left w-full"
            style="color: #0A2540;"
            onmouseover="this.style.backgroundColor='#F1F5F9';"
            onmouseout="this.style.backgroundColor='transparent';"
          >
            <span class="w-7 h-7 rounded-lg flex items-center justify-center flex-shrink-0" style="background-color: #FEF3C7;">
              <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="#F59E0B" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/><line x1="16" y1="13" x2="8" y2="13"/><line x1="16" y1="17" x2="8" y2="17"/><polyline points="10 9 9 9 8 9"/>
              </svg>
            </span>
            Documento
          </button>

        </div>
      </div>

      <!-- Campo de texto -->
      <div class="flex-1 flex flex-col gap-1">
        <textarea
          id="msg-input"
          class="msg-input"
          placeholder="Escreva uma mensagem..."
          rows="1"
          maxlength="5000"
          oninput="onInput()"
          onkeydown="onKeyDown(event)"
        ></textarea>

        <!-- Contador de caracteres — só aparece a partir dos 4000 -->
        <div id="char-counter-wrap" class="hidden justify-end pr-1">
          <span id="char-counter" class="char-counter" style="color: #94A3B8;">
            0 / 5000
          </span>
        </div>
      </div>

      <!-- Botão de envio -->
      <button
        type="button"
        id="btn-send"
        onclick="enviarMensagem()"
        disabled
        class="btn-send w-10 h-10 rounded-xl flex items-center justify-center flex-shrink-0 text-white transition-all"
        style="background-color: #2563EB;"
        title="Enviar mensagem"
      >
        <!-- COLOR_PRIMARY_600 = #2563EB -->
        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round">
          <line x1="22" y1="2" x2="11" y2="13"/><polygon points="22 2 15 22 11 13 2 9 22 2"/>
        </svg>
      </button>

    </div>
  </div>
</div>

<!-- Input de ficheiro oculto -->
<input type="file" id="file-input" class="hidden" onchange="onFileSelected()" />

<script>
  var LIMITE = 5000;
  var AVISO_A_PARTIR = 4000;
  var anexoPendente = null;
  var estadoOnline  = true;

  // ─── Auto-resize do textarea ──────────────────────────────────────────────
  function autoResize() {
    var el = document.getElementById('msg-input');
    el.style.height = 'auto';
    el.style.height = Math.min(el.scrollHeight, 140) + 'px';
  }

  // ─── Handler principal do input ───────────────────────────────────────────
  function onInput() {
    autoResize();
    actualizarContador();
    actualizarBtnEnvio();
  }

  // ─── Contador de caracteres ───────────────────────────────────────────────
  function actualizarContador() {
    var val     = document.getElementById('msg-input').value;
    var len     = val.length;
    var wrap    = document.getElementById('char-counter-wrap');
    var counter = document.getElementById('char-counter');

    counter.textContent = len + ' / ' + LIMITE;

    if (len >= AVISO_A_PARTIR) {
      wrap.classList.remove('hidden');
      wrap.classList.add('flex');
      // Cor de aviso progressiva
      if (len >= LIMITE - 100) {
        counter.style.color = '#EF4444'; // COLOR_ERROR
      } else if (len >= AVISO_A_PARTIR) {
        counter.style.color = '#F59E0B'; // COLOR_WARNING
      }
    } else {
      wrap.classList.add('hidden');
      wrap.classList.remove('flex');
    }
  }

  // ─── Activar/desactivar botão de envio ────────────────────────────────────
  function actualizarBtnEnvio() {
    var texto  = document.getElementById('msg-input').value.trim();
    var btn    = document.getElementById('btn-send');
    var activo = texto.length > 0 || anexoPendente !== null;
    btn.disabled = !activo;
  }

  // ─── Envio com Enter (Shift+Enter = nova linha) ───────────────────────────
  function onKeyDown(e) {
    if (e.key === 'Enter' && !e.shiftKey) {
      e.preventDefault();
      enviarMensagem();
    }
  }

  // ─── Enviar mensagem ──────────────────────────────────────────────────────
  function enviarMensagem() {
    var input = document.getElementById('msg-input');
    var texto = input.value.trim();
    if (!texto && !anexoPendente) return;

    var area = document.getElementById('msg-area');

    // Wrapper da mensagem
    var wrapper = document.createElement('div');
    wrapper.className = 'flex flex-col gap-1';
    wrapper.style.alignItems = 'flex-end';

    // Balão
    var balao = document.createElement('div');
    balao.className = 'bubble-sent';

    if (anexoPendente) {
      var chip = document.createElement('span');
      chip.className = 'anexo-chip';
      chip.innerHTML = iconePorTipo(anexoPendente.tipo)
        + '<span style="overflow:hidden;text-overflow:ellipsis;white-space:nowrap;">'
        + anexoPendente.nome
        + '</span>';
      balao.appendChild(chip);
      if (texto) {
        var p = document.createElement('p');
        p.style.marginTop = '6px';
        p.textContent = texto;
        balao.appendChild(p);
      }
    } else {
      balao.textContent = texto;
    }

    // Hora
    var hora = document.createElement('span');
    hora.className = 'text-xs px-1';
    hora.style.color = '#94A3B8';
    hora.textContent = horaActual();

    wrapper.appendChild(balao);
    wrapper.appendChild(hora);
    area.appendChild(wrapper);

    // Limpar estado
    input.value = '';
    input.style.height = 'auto';
    limparAnexo();
    actualizarContador();
    actualizarBtnEnvio();

    // Scroll para o fundo
    area.scrollTop = area.scrollHeight;
  }

  // ─── Popup de anexo ───────────────────────────────────────────────────────
  function toggleAnexo(e) {
    e.stopPropagation();
    var popup = document.getElementById('anexo-popup');
    popup.classList.toggle('open');
  }

  document.addEventListener('click', function(e) {
    var wrapper = document.getElementById('anexo-wrapper');
    if (!wrapper.contains(e.target)) {
      document.getElementById('anexo-popup').classList.remove('open');
    }
  });

  function anexarTipo(tipo) {
    document.getElementById('anexo-popup').classList.remove('open');
    var accept = '';
    if (tipo === 'foto')      accept = 'image/*';
    if (tipo === 'audio')     accept = 'audio/*';
    if (tipo === 'documento') accept = '.pdf,.doc,.docx,.xls,.xlsx,.txt';

    var fi = document.getElementById('file-input');
    fi.accept  = accept;
    fi.dataset.tipo = tipo;
    fi.value   = '';
    fi.click();
  }

  function onFileSelected() {
    var fi   = document.getElementById('file-input');
    var tipo = fi.dataset.tipo;
    if (!fi.files || fi.files.length === 0) return;

    var ficheiro = fi.files[0];
    anexoPendente = { tipo: tipo, nome: ficheiro.name };

    // Mostrar preview
    var preview = document.getElementById('anexo-preview');
    preview.classList.remove('hidden');
    preview.classList.add('flex');
    preview.innerHTML = '<span class="anexo-chip">'
      + iconePorTipo(tipo)
      + '<span style="overflow:hidden;text-overflow:ellipsis;white-space:nowrap;max-width:140px;">' + ficheiro.name + '</span>'
      + '<button type="button" onclick="limparAnexo()" style="margin-left:2px;line-height:1;color:#64748B;" title="Remover">'
      + '<svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/></svg>'
      + '</button>'
      + '</span>';

    actualizarBtnEnvio();
  }

  function limparAnexo() {
    anexoPendente = null;
    var preview = document.getElementById('anexo-preview');
    preview.classList.add('hidden');
    preview.classList.remove('flex');
    preview.innerHTML = '';
    actualizarBtnEnvio();
  }

  // ─── Ícones por tipo de anexo ─────────────────────────────────────────────
  function iconePorTipo(tipo) {
    if (tipo === 'foto') {
      return '<svg width="11" height="11" viewBox="0 0 24 24" fill="none" stroke="#3B82F6" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="3" width="18" height="18" rx="2"/><circle cx="8.5" cy="8.5" r="1.5"/><polyline points="21 15 16 10 5 21"/></svg>';
    }
    if (tipo === 'audio') {
      return '<svg width="11" height="11" viewBox="0 0 24 24" fill="none" stroke="#10B981" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><path d="M12 1a3 3 0 0 0-3 3v8a3 3 0 0 0 6 0V4a3 3 0 0 0-3-3z"/><path d="M19 10v2a7 7 0 0 1-14 0v-2"/></svg>';
    }
    return '<svg width="11" height="11" viewBox="0 0 24 24" fill="none" stroke="#F59E0B" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/></svg>';
  }

  // ─── Hora actual ──────────────────────────────────────────────────────────
  function horaActual() {
    var d = new Date();
    return d.getHours().toString().padStart(2,'0') + ':' + d.getMinutes().toString().padStart(2,'0');
  }

  // ─── Alternar estado online/offline (demo) ────────────────────────────────
  function alternarEstado() {
    estadoOnline = !estadoOnline;
    var dot   = document.getElementById('dot-estado');
    var label = document.getElementById('label-estado');

    if (estadoOnline) {
      dot.className   = 'dot-online';
      label.textContent = 'Online';
      label.style.color = '#10B981'; // COLOR_SUCCESS
    } else {
      dot.className   = 'dot-offline';
      label.textContent = 'Offline';
      label.style.color = '#94A3B8'; // DARK_TEXT_SECONDARY
    }
  }

  // ─── Scroll inicial para o fundo ─────────────────────────────────────────
  window.addEventListener('load', function() {
    var area = document.getElementById('msg-area');
    area.scrollTop = area.scrollHeight;
  });
</script>
</body>
</html>
