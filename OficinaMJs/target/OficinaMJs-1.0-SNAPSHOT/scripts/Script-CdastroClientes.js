/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */


   let sexoSelecionado = '';

    function selectSexo(val) {
      sexoSelecionado = val;

      // Repõe os dois botões para o estado neutro
      ['rb-m', 'rb-f'].forEach(id => {
        const btn = document.getElementById(id);
        btn.style.backgroundColor = '#F8FAFC';
        btn.style.borderColor    = '#E2E8F0';
        btn.style.color          = '#64748B'; // COLOR_TEXT_SECONDARY
      });

      // Activa o seleccionado — CLIENT_HOVER (#DBEAFE) + COLOR_PRIMARY_500 (#3B82F6) + COLOR_PRIMARY_600 (#2563EB)
      const active = document.getElementById(val === 'M' ? 'rb-m' : 'rb-f');
      active.style.backgroundColor = '#DBEAFE';
      active.style.borderColor     = '#3B82F6';
      active.style.color           = '#2563EB';

      hideError('err-sexo');
    }

    function formatTelefone(input) {
      let v = input.value.replace(/\D/g, '').slice(0, 9);
      if (v.length > 6)      v = v.slice(0, 3) + ' ' + v.slice(3, 6) + ' ' + v.slice(6);
      else if (v.length > 3) v = v.slice(0, 3) + ' ' + v.slice(3);
      input.value = v;
      if (input.value.length > 0) validateTelefone();
    }

    function formatBI(input) {
      input.value = input.value.toUpperCase().replace(/[^0-9A-Z]/g, '');
      if (input.value.length > 0) validateBI();
    }

    function validateTelefone() {
      const raw   = document.getElementById('telefone').value.replace(/\s/g, '');
      const valid = /^9\d{8}$/.test(raw);
      setFieldState('telefone', 'err-tel', valid || raw.length === 0);
      return valid;
    }

    function validateBI() {
      const v     = document.getElementById('bi').value.trim();
      const valid = /^\d{9}[A-Z]{2}\d{3}$/.test(v);
      setFieldState('bi', 'err-bi', valid || v.length === 0);
      return valid;
    }

    function validateEmail() {
      const v = document.getElementById('email').value.trim();
      if (v === '') { setFieldState('email', 'err-email', true); return true; }
      const valid = /^[^\s@]+@[^\s@]+\.[^\s@]{2,}$/.test(v);
      setFieldState('email', 'err-email', valid);
      return valid;
    }

    function setFieldState(inputId, errId, isValid) {
      const input = document.getElementById(inputId);
      const err   = document.getElementById(errId);
      if (isValid) {
        input.classList.remove('error');
        input.style.borderColor     = '#E2E8F0';
        input.style.backgroundColor = '#F8FAFC';
        err.classList.add('hidden');
      } else {
        input.classList.add('error');
        err.classList.remove('hidden');
      }
    }

    function hideError(id) { document.getElementById(id).classList.add('hidden'); }
    function showError(id)  { document.getElementById(id).classList.remove('hidden'); }

    function submitForm() {
      let valid = true;

      const nome = document.getElementById('nome').value.trim();
      if (!nome) { setFieldState('nome', 'err-nome', false); valid = false; }
      else         setFieldState('nome', 'err-nome', true);

      const data = document.getElementById('dataNascimento').value;
      if (!data) { setFieldState('dataNascimento', 'err-data', false); valid = false; }
      else         setFieldState('dataNascimento', 'err-data', true);

      const nac = document.getElementById('nacionalidade').value;
      if (!nac) { showError('err-nac'); valid = false; }
      else        hideError('err-nac');

      if (!sexoSelecionado) { showError('err-sexo'); valid = false; }
      else                    hideError('err-sexo');

      const biVal = document.getElementById('bi').value.trim();
      if (!biVal || !/^\d{9}[A-Z]{2}\d{3}$/.test(biVal)) { setFieldState('bi', 'err-bi', false); valid = false; }
      else setFieldState('bi', 'err-bi', true);

      const telRaw = document.getElementById('telefone').value.replace(/\s/g, '');
      if (!/^9\d{8}$/.test(telRaw)) { setFieldState('telefone', 'err-tel', false); valid = false; }
      else setFieldState('telefone', 'err-tel', true);

      if (!validateEmail()) valid = false;

      const end = document.getElementById('endereco').value.trim();
      if (!end) { setFieldState('endereco', 'err-end', false); valid = false; }
      else        setFieldState('endereco', 'err-end', true);

      if (!valid) return;

      const toast = document.getElementById('toast');
      toast.classList.add('show');
      setTimeout(() => toast.classList.remove('show'), 3500);
      setTimeout(() => resetForm(), 400);
    }

    function resetForm() {
      ['nome', 'dataNascimento', 'bi', 'telefone', 'email', 'endereco'].forEach(id => {
        const el = document.getElementById(id);
        if (!el) return;
        el.value = '';
        el.classList.remove('error');
        el.style.borderColor     = '#E2E8F0';
        el.style.backgroundColor = '#F8FAFC';
      });

      document.getElementById('nacionalidade').value = '';
      sexoSelecionado = '';

      ['rb-m', 'rb-f'].forEach(id => {
        const btn = document.getElementById(id);
        btn.style.backgroundColor = '#F8FAFC';
        btn.style.borderColor     = '#E2E8F0';
        btn.style.color           = '#64748B';
      });

      ['err-nome','err-data','err-nac','err-sexo','err-bi','err-tel','err-email','err-end']
        .forEach(id => hideError(id));
    }

    document.getElementById('email').addEventListener('blur', validateEmail);
    document.getElementById('telefone').addEventListener('blur', validateTelefone);
    document.getElementById('bi').addEventListener('blur', validateBI);


