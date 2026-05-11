<%-- 
    Document   : Notificações
    Created on : 11/05/2026, 23:06:06
    Author     : T
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="pt">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Notificações</title>
  <script src="https://cdn.tailwindcss.com"></script>
  <style>
    /* [CSS PURO] motivo: animação de entrada dos cards com translateY — não disponível no Tailwind padrão */
    @keyframes slideIn {
      from { opacity: 0; transform: translateY(10px); }
      to   { opacity: 1; transform: translateY(0); }
    }
    .card-notif { animation: slideIn 0.22s ease both; }

    /* [CSS PURO] motivo: animação de saída ao eliminar — Tailwind não cobre keyframes de saída com translateX + opacity */
    @keyframes slideOut {
      from { opacity: 1; transform: translateX(0); max-height: 120px; margin-bottom: 0.75rem; }
      to   { opacity: 0; transform: translateX(40px); max-height: 0; margin-bottom: 0; }
    }
    .card-removing {
      animation: slideOut 0.28s ease forwards;
      overflow: hidden;
      pointer-events: none;
    }

    /* [CSS PURO] motivo: ponto de notificação não lida com pulse — pseudo-elemento e animação não disponíveis no Tailwind padrão */
    @keyframes pulse-dot {
      0%, 100% { transform: scale(1); opacity: 1; }
      50%       { transform: scale(1.4); opacity: 0.6; }
    }
    .dot-unread {
      width: 8px;
      height: 8px;
      border-radius: 50%;
      background-color: #3B82F6; /* COLOR_PRIMARY_500 */
      animation: pulse-dot 2s ease-in-out infinite;
      flex-shrink: 0;
    }

    /* [CSS PURO] motivo: scrollbar customizada — não disponível no Tailwind padrão */
    .notif-list::-webkit-scrollbar { width: 4px; }
    .notif-list::-webkit-scrollbar-track { background: transparent; }
    .notif-list::-webkit-scrollbar-thumb { background: #E2E8F0; border-radius: 4px; }

    /* [CSS PURO] motivo: transição de opacidade no botão de acção oculto — Tailwind group-hover não cobre opacity + pointer-events combinados */
    .card-notif .actions { opacity: 0; transition: opacity 0.18s ease; pointer-events: none; }
    .card-notif:hover .actions { opacity: 1; pointer-events: auto; }
  </style>
</head>

<body class="min-h-screen py-8 px-4" style="background-color: #F1F5F9;">
<!-- NOTIF_BG = #F1F5F9 -->

<div class="max-w-2xl mx-auto">

  <!-- ===== CABEÇALHO ===== -->
  <div class="flex items-center justify-between mb-6">
    <div class="flex items-center gap-3">
      <h1 class="text-xl font-semibold" style="color: #0A2540;">Notificações</h1>
      <!-- Contador de não lidas -->
      <span
        id="badge-count"
        class="text-xs font-bold px-2 py-0.5 rounded-full text-white"
        style="background-color: #3B82F6;"
      >0</span>
      <!-- COLOR_PRIMARY_500 = #3B82F6 -->
    </div>

    <button
      id="btn-mark-all"
      type="button"
      onclick="marcarTodasLidas()"
      class="text-xs font-semibold px-3 py-1.5 rounded-lg transition-all"
      style="color: #3B82F6; background-color: #DBEAFE;"
      onmouseover="this.style.backgroundColor='#BFDBFE';"
      onmouseout="this.style.backgroundColor='#DBEAFE';"
    >
      Marcar todas como lidas
    </button>
    <!-- COLOR_INFO_BG = #DBEAFE -->
  </div>

  <!-- ===== FILTROS ===== -->
  <div class="flex gap-2 mb-5 flex-wrap" id="filtros">
    <button class="filtro active" data-tipo="todos"      onclick="filtrar(this)">Todas</button>
    <button class="filtro"        data-tipo="info"       onclick="filtrar(this)">Informação</button>
    <button class="filtro"        data-tipo="sucesso"    onclick="filtrar(this)">Sucesso</button>
    <button class="filtro"        data-tipo="aviso"      onclick="filtrar(this)">Aviso</button>
    <button class="filtro"        data-tipo="erro"       onclick="filtrar(this)">Erro</button>
  </div>

  <style>
    /* [CSS PURO] motivo: estilos dos filtros com estado activo usando COLOR_PRIMARY_500/600 e COLOR_INFO_BG — combinar border + background + cor no estado activo não é coberto limpo pelo Tailwind sem JIT config */
    .filtro {
      font-size: 0.75rem;
      font-weight: 600;
      padding: 0.35rem 0.9rem;
      border-radius: 9999px;
      border: 1.5px solid #E2E8F0;
      background-color: #FFFFFF;
      color: #64748B;
      cursor: pointer;
      transition: all 0.15s ease;
    }
    .filtro:hover { border-color: #3B82F6; color: #3B82F6; }
    .filtro.active {
      background-color: #3B82F6;
      border-color: #3B82F6;
      color: #FFFFFF;
    }
  </style>

  <!-- ===== LISTA DE NOTIFICAÇÕES ===== -->
  <div id="lista" class="notif-list" style="max-height: 70vh; overflow-y: auto; padding-right: 2px;"></div>

  <!-- ===== ESTADO VAZIO ===== -->
  <div id="estado-vazio" class="hidden flex-col items-center justify-center py-20 text-center">
    <!-- Ilustração SVG inline -->
    <svg class="mb-6" width="120" height="100" viewBox="0 0 120 100" fill="none" xmlns="http://www.w3.org/2000/svg">
      <!-- Círculo de fundo -->
      <circle cx="60" cy="50" r="46" fill="#DBEAFE" opacity="0.5"/>
      <!-- Sino -->
      <path d="M60 18c-1.7 0-3 1.3-3 3v2.2C47.5 25 41 32.2 41 41v10l-4 6h46l-4-6V41c0-8.8-6.5-16-15-17.8V21c0-1.7-1.3-3-3-3z" fill="#BFDBFE" stroke="#3B82F6" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
      <!-- Base do sino -->
      <path d="M54 57c0 3.3 2.7 6 6 6s6-2.7 6-6" fill="#BFDBFE" stroke="#3B82F6" stroke-width="1.5" stroke-linecap="round"/>
      <!-- Linha riscada (vazio) -->
      <line x1="36" y1="78" x2="84" y2="78" stroke="#CBD5E1" stroke-width="2" stroke-linecap="round"/>
      <line x1="44" y1="84" x2="76" y2="84" stroke="#CBD5E1" stroke-width="2" stroke-linecap="round"/>
    </svg>

    <p class="text-base font-semibold mb-1" style="color: #0A2540;">Sem notificações</p>
    <p class="text-sm" style="color: #64748B;">Está tudo em dia. Novas notificações aparecem aqui.</p>
  </div>

</div>

<script>
  // ─── Dados de exemplo ─────────────────────────────────────────────────────
  const dadosIniciais = [
    {
      id: 1, tipo: 'info', lida: false,
      titulo: 'Actualização do sistema',
      descricao: 'Uma nova versão da plataforma está disponível.',
      tempo: 'há 2 min'
    },
    {
      id: 2, tipo: 'sucesso', lida: false,
      titulo: 'Pagamento confirmado',
      descricao: 'A ordem de serviço #1042 foi paga com sucesso.',
      tempo: 'há 15 min'
    },
    {
      id: 3, tipo: 'aviso', lida: false,
      titulo: 'Revisão pendente',
      descricao: 'O veículo KA-45-31 tem revisão agendada para amanhã.',
      tempo: 'há 1 h'
    },
    {
      id: 4, tipo: 'erro', lida: true,
      titulo: 'Falha no envio',
      descricao: 'Não foi possível enviar o recibo ao cliente João Silva.',
      tempo: 'há 3 h'
    },
    {
      id: 5, tipo: 'info', lida: true,
      titulo: 'Novo cliente registado',
      descricao: 'Maria Fernanda foi adicionada à base de dados.',
      tempo: 'há 5 h'
    },
    {
      id: 6, tipo: 'sucesso', lida: false,
      titulo: 'Ordem de serviço concluída',
      descricao: 'A OS #1039 foi marcada como concluída pela equipa.',
      tempo: 'ontem'
    },
    {
      id: 7, tipo: 'aviso', lida: true,
      titulo: 'Stock em falta',
      descricao: 'O filtro de óleo (ref. FO-220) está abaixo do mínimo.',
      tempo: 'ontem'
    },
  ];

  // ─── Paleta por tipo (NOTIF_* da paleta.md) ───────────────────────────────
  const estiloTipo = {
    info:    { cor: '#3B82F6', bg: '#DBEAFE', icone: infoIcon()    }, // NOTIF_INFO + NOTIF_INFO_BG
    sucesso: { cor: '#10B981', bg: '#D1FAE5', icone: sucessoIcon() }, // NOTIF_SUCCESS + NOTIF_SUCCESS_BG
    aviso:   { cor: '#F59E0B', bg: '#FEF3C7', icone: avisoIcon()   }, // NOTIF_WARNING + NOTIF_WARNING_BG
    erro:    { cor: '#EF4444', bg: '#FEE2E2', icone: erroIcon()    }, // NOTIF_ERROR + NOTIF_ERROR_BG
  };

  function infoIcon() {
    return `<svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#3B82F6" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>`;
  }
  function sucessoIcon() {
    return `<svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#10B981" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"/></svg>`;
  }
  function avisoIcon() {
    return `<svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#F59E0B" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"/><line x1="12" y1="9" x2="12" y2="13"/><line x1="12" y1="17" x2="12.01" y2="17"/></svg>`;
  }
  function erroIcon() {
    return `<svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#EF4444" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><line x1="15" y1="9" x2="9" y2="15"/><line x1="9" y1="9" x2="15" y2="15"/></svg>`;
  }

  // ─── Estado ───────────────────────────────────────────────────────────────
  let notificacoes  = [...dadosIniciais];
  let filtroActivo  = 'todos';

  // ─── Render ───────────────────────────────────────────────────────────────
  function render() {
    const lista = document.getElementById('lista');
    const vazio = document.getElementById('estado-vazio');

    const visiveis = filtroActivo === 'todos'
      ? notificacoes
      : notificacoes.filter(n => n.tipo === filtroActivo);

    if (visiveis.length === 0) {
      lista.innerHTML = '';
      vazio.classList.remove('hidden');
      vazio.classList.add('flex');
    } else {
      vazio.classList.add('hidden');
      vazio.classList.remove('flex');
      lista.innerHTML = visiveis.map((n, i) => renderCard(n, i)).join('');
    }

    actualizarBadge();
    actualizarBtnMarcar();
  }

  // Funções auxiliares extraídas para evitar template literals aninhados (backtick dentro de backtick)
  // que o parser do NetBeans não suporta correctamente

  function renderPontoDot(lida) {
    if (lida) return '';
    return '<div class="dot-unread"></div>';
  }

  function renderTituloClass(lida) {
    return lida ? 'font-normal' : 'font-semibold';
  }

  function renderBtnMarcarLida(id, lida) {
    if (lida) return '';
    return '<button'
      + ' type="button"'
      + ' title="Marcar como lida"'
      + ' onclick="marcarLida(' + id + ')"'
      + ' class="w-7 h-7 rounded-lg flex items-center justify-center transition-all"'
      + ' style="background-color: #DBEAFE; color: #3B82F6;"'
      + ' onmouseover="this.style.backgroundColor=\'#BFDBFE\';"'
      + ' onmouseout="this.style.backgroundColor=\'#DBEAFE\';"'
      + '>'
      + '<svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"/></svg>'
      + '</button>';
  }

  function renderCard(n, i) {
    var est        = estiloTipo[n.tipo];
    var borderCor  = n.lida ? '#E2E8F0' : '#DBEAFE';
    var tempoCor   = n.lida ? '#94A3B8' : est.cor;
    var delay      = (i * 0.04) + 's';

    return '<div'
      + ' id="card-' + n.id + '"'
      + ' class="card-notif flex items-start gap-4 rounded-xl px-4 py-4 mb-3 cursor-pointer transition-all relative"'
      + ' style="background-color: #FFFFFF; border: 1.5px solid ' + borderCor + '; animation-delay: ' + delay + ';"'
      + ' onclick="marcarLida(' + n.id + ')"'
      + '>'

      // Ponto de não lida
      + '<div class="absolute right-4 top-4 flex items-center">'
      + renderPontoDot(n.lida)
      + '</div>'

      // Ícone do tipo
      + '<div class="w-9 h-9 rounded-xl flex items-center justify-center flex-shrink-0 mt-0.5" style="background-color: ' + est.bg + ';">'
      + est.icone
      + '</div>'

      // Conteúdo
      + '<div class="flex-1 min-w-0 pr-6">'
      + '<p class="text-sm mb-0.5 ' + renderTituloClass(n.lida) + '" style="color: #0A2540;">' + n.titulo + '</p>'
      + '<p class="text-xs leading-relaxed" style="color: #64748B;">' + n.descricao + '</p>'
      + '<p class="text-xs mt-1.5" style="color: ' + tempoCor + ';">' + n.tempo + '</p>'
      + '</div>'

      // Acções (visíveis ao hover via CSS)
      + '<div class="actions absolute right-3 bottom-3 flex items-center gap-1" onclick="event.stopPropagation();">'
      + renderBtnMarcarLida(n.id, n.lida)
      + '<button'
      + ' type="button"'
      + ' title="Eliminar"'
      + ' onclick="eliminar(' + n.id + ')"'
      + ' class="w-7 h-7 rounded-lg flex items-center justify-center transition-all"'
      + ' style="background-color: #FEE2E2; color: #EF4444;"'
      + ' onmouseover="this.style.backgroundColor=\'#FECACA\';"'
      + ' onmouseout="this.style.backgroundColor=\'#FEE2E2\';"'
      + '>'
      + '<svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><polyline points="3 6 5 6 21 6"/><path d="M19 6l-1 14H6L5 6"/><path d="M10 11v6"/><path d="M14 11v6"/><path d="M9 6V4h6v2"/></svg>'
      + '</button>'
      + '</div>'

      + '</div>';
  }

  // ─── Acções ───────────────────────────────────────────────────────────────
  function marcarLida(id) {
    notificacoes = notificacoes.map(n => n.id === id ? { ...n, lida: true } : n);
    render();
  }

  function eliminar(id) {
    const card = document.getElementById('card-' + id);
    if (!card) return;
    card.classList.add('card-removing');
    setTimeout(() => {
      notificacoes = notificacoes.filter(n => n.id !== id);
      render();
    }, 280);
  }

  function marcarTodasLidas() {
    notificacoes = notificacoes.map(n => ({ ...n, lida: true }));
    render();
  }

  function filtrar(btn) {
    document.querySelectorAll('.filtro').forEach(b => b.classList.remove('active'));
    btn.classList.add('active');
    filtroActivo = btn.dataset.tipo;
    render();
  }

  function actualizarBadge() {
    const naoLidas = notificacoes.filter(n => !n.lida).length;
    const badge    = document.getElementById('badge-count');
    badge.textContent = naoLidas;
    badge.style.display = naoLidas === 0 ? 'none' : 'inline-block';
  }

  function actualizarBtnMarcar() {
    const btn      = document.getElementById('btn-mark-all');
    const naoLidas = notificacoes.filter(n => !n.lida).length;
    btn.style.display = naoLidas === 0 ? 'none' : 'inline-block';
  }

  // ─── Init ─────────────────────────────────────────────────────────────────
  render();
</script>
</body>
</html>