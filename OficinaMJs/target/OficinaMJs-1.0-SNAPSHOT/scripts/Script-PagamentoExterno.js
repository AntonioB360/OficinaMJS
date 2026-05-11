/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */

// ─── TAB SWITCHER ─────────────────────────────────────────────
    function switchTab(tab) {
      const panels = { card: 'panel-card', ref: 'panel-ref' };
      const tabs   = { card: 'tab-card',   ref: 'tab-ref'   };

      Object.keys(panels).forEach(k => {
        document.getElementById(panels[k]).classList.remove('active');
        const t = document.getElementById(tabs[k]);
        t.classList.remove('border-primary-500', 'text-primary-500');
        t.classList.add('border-transparent', 'text-muted');
      });

      document.getElementById(panels[tab]).classList.add('active');
      const active = document.getElementById(tabs[tab]);
      active.classList.remove('border-transparent', 'text-muted');
      active.classList.add('border-primary-500', 'text-primary-500');
    }

    // ─── CARD NUMBER MASK ─────────────────────────────────────────
    function formatCardNumber(input) {
      let val = input.value.replace(/\D/g, '').substring(0, 16);
      input.value = val.replace(/(.{4})/g, '$1 ').trim();
      const digits = val.padEnd(16, '•');
      document.getElementById('preview-number').textContent =
        digits.substring(0,4) + ' ' + digits.substring(4,8) + ' ' + digits.substring(8,12) + ' ' + digits.substring(12,16);
    }

    // ─── PREVIEW UPDATES ──────────────────────────────────────────
    function updatePreviewName(val) {
      const el = document.getElementById('preview-name');
      el.textContent = val.toUpperCase().trim() || 'NOME DO TITULAR';
    }

    document.getElementById('expiry').addEventListener('change', function() {
      const el = document.getElementById('preview-expiry');
      if (this.value) {
        const [y, m] = this.value.split('-');
        el.textContent = m + '/' + y.slice(2);
      } else {
        el.textContent = 'MM/AA';
      }
    });

    // ─── CARD FORM VALIDATION ─────────────────────────────────────
    function showErr(id, show) {
      const el = document.getElementById('err-' + id);
      const input = document.getElementById(id);
      el.classList.toggle('hidden', !show);
      input.classList.toggle('error', show);
    }

    document.getElementById('cardForm').addEventListener('submit', function(e) {
      e.preventDefault();

      const number = document.getElementById('cardNumber').value.replace(/\s/g, '');
      const cvv    = document.getElementById('cvv').value;
      const expiry = document.getElementById('expiry').value;
      const name   = document.getElementById('cardName').value.trim();

      const now    = new Date();
      const minMonth = `${now.getFullYear()}-${String(now.getMonth()+1).padStart(2,'0')}`;

      let valid = true;

      // Número (16 dígitos + Luhn)
      const validNumber = number.length === 16 && luhn(number);
      showErr('cardNumber', !validNumber);
      if (!validNumber) valid = false;

      // CVV
      const validCvv = /^\d{3}$/.test(cvv);
      showErr('cvv', !validCvv);
      if (!validCvv) valid = false;

      // Validade
      const validExpiry = expiry && expiry >= minMonth;
      showErr('expiry', !validExpiry);
      if (!validExpiry) valid = false;

      // Nome
      const validName = /^[A-Za-zÀ-ÿ\s]+$/.test(name) && name.length > 0;
      showErr('cardName', !validName);
      if (!validName) valid = false;

      if (valid) {
        document.getElementById('card-success').classList.remove('hidden');
        this.querySelectorAll('input').forEach(i => i.disabled = true);
        this.querySelector('button[type=submit]').disabled = true;
      }
    });

    // ─── LUHN ALGORITHM ───────────────────────────────────────────
    function luhn(num) {
      let sum = 0;
      let alt = false;
      for (let i = num.length - 1; i >= 0; i--) {
        let n = parseInt(num[i]);
        if (alt) { n *= 2; if (n > 9) n -= 9; }
        sum += n;
        alt = !alt;
      }
      return sum % 10 === 0;
    }

    // ─── REFERÊNCIA ───────────────────────────────────────────────
    let hasActiveRef = false;

    // TODO: Backend deve chamar esta função ao carregar, se já houver referência ativa:
    // blockRefButton('123 456 789'); ← passa a referência existente como argumento
    function blockRefButton(existingRef) {
      hasActiveRef = true;
      const btn = document.getElementById('genRefBtn');
      btn.disabled = true;
      btn.classList.remove('bg-success-DEFAULT', 'hover:bg-success-hover');
      btn.classList.add('bg-border', 'cursor-not-allowed');
      document.getElementById('genRefLabel').textContent = 'Referência já gerada';

      if (existingRef) {
        document.getElementById('refNumber').value = existingRef;
        document.getElementById('copyBtn').classList.remove('hidden');
        document.getElementById('ref-success').classList.remove('hidden');
      }
    }

    function generateReference() {
      if (hasActiveRef) return;

      const btn = document.getElementById('genRefBtn');
      btn.disabled = true;
      document.getElementById('genRefLabel').textContent = 'A gerar...';

      // TODO: Backend deve gerar a referência via API e chamar:
      // document.getElementById('refNumber').value = '<REFERENCIA_GERADA>';
      // Simulação para demonstração:
      setTimeout(() => {
        const ref = generateFakeRef();
        document.getElementById('refNumber').value = ref;
        document.getElementById('copyBtn').classList.remove('hidden');
        document.getElementById('ref-success').classList.remove('hidden');
        blockRefButton(ref);
      }, 1500);
    }

    function generateFakeRef() {
      return Array.from({length: 3}, () => Math.floor(100 + Math.random()*900)).join(' ');
    }

    function copyRef() {
      const val = document.getElementById('refNumber').value;
      navigator.clipboard.writeText(val).then(() => {
        const btn = document.getElementById('copyBtn');
        btn.innerHTML = '<svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#10B981" stroke-width="2.5"><polyline points="20 6 9 17 4 12"/></svg>';
        setTimeout(() => {
          btn.innerHTML = '<svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="9" y="9" width="13" height="13" rx="2"/><path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1"/></svg>';
        }, 1500);
      });
    }

    // Set min date for expiry
    const now = new Date();
    document.getElementById('expiry').min =
      `${now.getFullYear()}-${String(now.getMonth()+1).padStart(2,'0')}`;
