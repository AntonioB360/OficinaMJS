<%-- 
    Document   : Cadastro_Clientes
    Created on : 30/04/2026, 23:01:53
    Author     : T
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="pt">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Os seus dados</title>
  <script src="https://cdn.tailwindcss.com"></script>
  <link rel="stylesheet" href="css/Style-CadastroClientes.css">
</head>

<body class="min-h-screen py-8 px-4" style="background-color: #F1F5F9;">
  <!-- CLIENT_BG = #F1F5F9 -->

  <div class="max-w-3xl mx-auto rounded-2xl overflow-hidden shadow-lg" style="background-color: #FFFFFF;">
    <!-- CLIENT_CARD = #FFFFFF -->

    <!-- ===== CABEÇALHO ===== -->
    <div class="header-gradient px-10 py-8 flex items-center gap-4">
      <div
        class="w-12 h-12 rounded-xl flex items-center justify-center flex-shrink-0"
        style="background-color: rgba(255,255,255,0.15);"
      >
        <!-- [CSS PURO] motivo: rgba com opacidade específica não disponível como classe Tailwind padrão -->
        <svg class="w-6 h-6 fill-white" viewBox="0 0 24 24">
          <path d="M12 12c2.7 0 4.8-2.1 4.8-4.8S14.7 2.4 12 2.4 7.2 4.5 7.2 7.2 9.3 12 12 12zm0 2.4c-3.2 0-9.6 1.6-9.6 4.8v2.4h19.2v-2.4c0-3.2-6.4-4.8-9.6-4.8z"/>
        </svg>
      </div>
      <div>
        <h1 class="text-white text-xl font-semibold tracking-tight">Os seus dados</h1>
        <p class="text-sm mt-1" style="color: rgba(255,255,255,0.65);">
          <!-- [CSS PURO] motivo: rgba com opacidade específica não disponível como classe Tailwind padrão -->
          Preencha o formulário para completar o seu registo
        </p>
      </div>
    </div>

    <!-- ===== CORPO ===== -->
    <div class="px-10 py-8">

      <!-- Secção: Informações Pessoais -->
      <p
        class="text-xs font-bold uppercase tracking-widest mb-4 pb-2 border-b-2"
        style="color: #3B82F6; border-color: #DBEAFE;"
      >
        <!-- COLOR_PRIMARY_500 = #3B82F6 | COLOR_INFO_BG = #DBEAFE -->
        Informações Pessoais
      </p>

      <!-- Nome Completo -->
      <div class="mb-4">
        <label class="block text-xs font-semibold mb-1" style="color: #0A2540;">
          <!-- COLOR_TEXT_PRIMARY = #0A2540 -->
          Nome Completo <span style="color: #EF4444;">*</span>
        </label>
        <input
          id="nome"
          type="text"
          placeholder="O seu nome completo"
          autocomplete="off"
          class="input-field w-full rounded-lg border px-3 py-2.5 text-sm transition-colors"
          style="background-color: #F8FAFC; border-color: #E2E8F0; color: #0A2540;"
        />
        <p id="err-nome" class="hidden text-xs mt-1" style="color: #EF4444;">
          Por favor, introduza o seu nome.
        </p>
      </div>

      <!-- Data de Nascimento | Nacionalidade | Sexo -->
      <div class="grid grid-cols-1 sm:grid-cols-3 gap-4 mb-4">

        <div>
          <label class="block text-xs font-semibold mb-1" style="color: #0A2540;">
            Data de Nascimento <span style="color: #EF4444;">*</span>
          </label>
          <input
            id="dataNascimento"
            type="date"
            class="input-field w-full rounded-lg border px-3 py-2.5 text-sm transition-colors"
            style="background-color: #F8FAFC; border-color: #E2E8F0; color: #0A2540;"
          />
          <p id="err-data" class="hidden text-xs mt-1" style="color: #EF4444;">
            Introduza a sua data de nascimento.
          </p>
        </div>

        <div>
          <label class="block text-xs font-semibold mb-1" style="color: #0A2540;">
            Nacionalidade <span style="color: #EF4444;">*</span>
          </label>
          <select
            id="nacionalidade"
            class="input-field w-full rounded-lg border px-3 py-2.5 text-sm transition-colors"
            style="background-color: #F8FAFC; border-color: #E2E8F0; color: #0A2540;"
          >
            <option value="">Selecionar...</option>
            <option value="AO" selected>Angolana</option>
            <option value="PT">Portuguesa</option>
            <option value="BR">Brasileira</option>
            <option value="ZA">Sul-africana</option>
            <option value="FR">Francesa</option>
            <option value="CN">Chinesa</option>
            <option value="US">Norte-americana</option>
            <option value="outro">Outra</option>
          </select>
          <p id="err-nac" class="hidden text-xs mt-1" style="color: #EF4444;">
            Selecione a sua nacionalidade.
          </p>
        </div>

        <div>
          <label class="block text-xs font-semibold mb-1" style="color: #0A2540;">
            Sexo <span style="color: #EF4444;">*</span>
          </label>
          <div class="flex gap-2">
            <button
              id="rb-m"
              type="button"
              onclick="selectSexo('M')"
              class="flex-1 rounded-lg border py-2.5 text-sm font-medium transition-all"
              style="background-color: #F8FAFC; border-color: #E2E8F0; color: #64748B;"
            >Masculino</button>
            <button
              id="rb-f"
              type="button"
              onclick="selectSexo('F')"
              class="flex-1 rounded-lg border py-2.5 text-sm font-medium transition-all"
              style="background-color: #F8FAFC; border-color: #E2E8F0; color: #64748B;"
            >Feminino</button>
          </div>
          <p id="err-sexo" class="hidden text-xs mt-1" style="color: #EF4444;">
            Selecione o seu sexo.
          </p>
        </div>

      </div>

      <hr class="my-6" style="border-color: #E2E8F0;" />

      <!-- Secção: Identificação & Contacto -->
      <p
        class="text-xs font-bold uppercase tracking-widest mb-4 pb-2 border-b-2"
        style="color: #3B82F6; border-color: #DBEAFE;"
      >
        Identificação &amp; Contacto
      </p>

      <!-- BI | Telefone -->
      <div class="grid grid-cols-1 sm:grid-cols-2 gap-4 mb-4">

        <div>
          <label class="block text-xs font-semibold mb-1" style="color: #0A2540;">
            Bilhete de Identidade <span style="color: #EF4444;">*</span>
          </label>
          <input
            id="bi"
            type="text"
            placeholder="000000000LA000"
            maxlength="14"
            oninput="formatBI(this)"
            class="input-field w-full rounded-lg border px-3 py-2.5 text-sm transition-colors"
            style="background-color: #F8FAFC; border-color: #E2E8F0; color: #0A2540;"
          />
          <p id="err-bi" class="hidden text-xs mt-1" style="color: #EF4444;">
            O número de BI introduzido não é válido.
          </p>
        </div>

        <div>
          <label class="block text-xs font-semibold mb-1" style="color: #0A2540;">
            Telefone <span style="color: #EF4444;">*</span>
          </label>
          <input
            id="telefone"
            type="tel"
            placeholder="9XX XXX XXX"
            maxlength="11"
            oninput="formatTelefone(this)"
            class="input-field w-full rounded-lg border px-3 py-2.5 text-sm transition-colors"
            style="background-color: #F8FAFC; border-color: #E2E8F0; color: #0A2540;"
          />
          <p id="err-tel" class="hidden text-xs mt-1" style="color: #EF4444;">
            O número de telefone introduzido não é válido.
          </p>
        </div>

      </div>

      <!-- Email | Endereço -->
      <div class="grid grid-cols-1 sm:grid-cols-2 gap-4 mb-4">

        <div>
          <label class="block text-xs font-semibold mb-1" style="color: #0A2540;">Email</label>
          <input
            id="email"
            type="email"
            placeholder="exemplo@dominio.com"
            class="input-field w-full rounded-lg border px-3 py-2.5 text-sm transition-colors"
            style="background-color: #F8FAFC; border-color: #E2E8F0; color: #0A2540;"
          />
          <p id="err-email" class="hidden text-xs mt-1" style="color: #EF4444;">
            Introduza um endereço de email válido.
          </p>
        </div>

        <div>
          <label class="block text-xs font-semibold mb-1" style="color: #0A2540;">
            Endereço <span style="color: #EF4444;">*</span>
          </label>
          <input
            id="endereco"
            type="text"
            placeholder="Rua, Bairro, Município"
            class="input-field w-full rounded-lg border px-3 py-2.5 text-sm transition-colors"
            style="background-color: #F8FAFC; border-color: #E2E8F0; color: #0A2540;"
          />
          <p id="err-end" class="hidden text-xs mt-1" style="color: #EF4444;">
            Por favor, introduza o seu endereço.
          </p>
        </div>

      </div>

      <hr class="my-6" style="border-color: #E2E8F0;" />

      <!-- ===== BOTÕES ===== -->
      <div class="flex justify-end gap-3">

        <!-- Botão Limpar -->
        <button
          type="button"
          onclick="resetForm()"
          class="inline-flex items-center gap-2 px-5 py-2.5 rounded-lg text-sm font-semibold border transition-all"
          style="background-color: #F1F5F9; color: #64748B; border-color: #E2E8F0;"
          onmouseover="this.style.backgroundColor='#E2E8F0'; this.style.color='#0A2540';"
          onmouseout="this.style.backgroundColor='#F1F5F9'; this.style.color='#64748B';"
        >
          <!-- COLOR_BACKGROUND = #F1F5F9 | COLOR_TEXT_SECONDARY = #64748B -->
          <svg class="w-4 h-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round">
            <polyline points="1 4 1 10 7 10"></polyline>
            <path d="M3.51 15a9 9 0 1 0 .49-5.34L1 10"></path>
          </svg>
          Limpar
        </button>

        <!-- Botão Concluir -->
        <button
          type="button"
          onclick="submitForm()"
          class="inline-flex items-center gap-2 px-5 py-2.5 rounded-lg text-sm font-semibold text-white transition-all"
          style="background-color: #2563EB; box-shadow: 0 2px 8px rgba(37,99,235,0.3);"
          onmouseover="this.style.backgroundColor='#1D4ED8';"
          onmouseout="this.style.backgroundColor='#2563EB';"
        >
          <!-- COLOR_PRIMARY_600 = #2563EB -->
          <svg class="w-4 h-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round">
            <polyline points="20 6 9 17 4 12"></polyline>
          </svg>
          Concluir Registo
        </button>

      </div>
    </div>
  </div>

  <!-- ===== TOAST DE SUCESSO ===== -->
  <div
    id="toast"
    class="toast fixed bottom-6 right-6 flex items-center gap-2 px-5 py-3 rounded-xl text-white text-sm font-semibold z-50"
    style="background-color: #10B981; box-shadow: 0 4px 20px rgba(16,185,129,0.35);"
  >
    <!-- COLOR_SUCCESS = #10B981 -->
    <svg class="w-4 h-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
      <polyline points="20 6 9 17 4 12"></polyline>
    </svg>
    Registo concluído com sucesso!
  </div>

  <script src="scripts/Script-CdastroClientes.js">
   
  </script>
</body>
</html>
