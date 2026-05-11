<%-- 
    Document   : Login
    Created on : 29/04/2026, 15:11:57
    Author     : T
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="pt">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Login — Auto Tech</title>
  <link rel="stylesheet" href="css/Style-Login.css">
</head>
<body>

  <div class="card">

    <div class="header">
      <div class="logo">
        <svg width="24" height="24" viewBox="0 0 24 24" fill="white" xmlns="http://www.w3.org/2000/svg">
          <path d="M12 4C9.8 4 8 5.8 8 8s1.8 4 4 4 4-1.8 4-4-1.8-4-4-4zm0 10c-4.4 0-8 1.8-8 4v2h16v-2c0-2.2-3.6-4-8-4z"/>
        </svg>
      </div>
      <h1>Bem-vindo de volta</h1>
      <p>Entre na sua conta para continuar</p>
    </div>

    <form id="loginForm">

      <div class="form-group">
        <label for="email">E-mail</label>
        <input type="email" id="email" placeholder="seu@email.com" autocomplete="email" />
        <p class="error-msg" id="emailError">E-mail inválido. Verifique o formato.</p>
      </div>

      <div class="form-group">
        <label for="password">Senha</label>
        <div class="password-wrapper">
          <input type="password" id="password" placeholder="••••••••" autocomplete="current-password" />
          <button type="button" class="toggle-password" onclick="togglePassword()">
            <svg id="eyeIcon" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#64748B" stroke-width="2">
              <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/>
              <circle cx="12" cy="12" r="3"/>
            </svg>
          </button>
        </div>
        <p id="passwordStatus"></p>
        <p class="error-msg" id="passwordError"></p>
      </div>

      <div class="form-footer">
        <label class="remember">
          <input type="checkbox" id="remember" />
          Lembrar-me
        </label>
          <a href="RecuperacaoCredencias.jsp" class="forgot">Esqueceu a senha?</a>
      </div>

      <button type="submit" class="btn-submit">Entrar</button>

      <div class="success-msg" id="successMsg">
        Login realizado com sucesso!
      </div>

    </form>

    <p class="signup-link">
        Não tem uma conta? <a href="Cadastro_Clientes.jsp">Criar conta</a>
    </p>

  </div>

    <script src="scripts/script.js">
   
  </script>

</body>
</html>