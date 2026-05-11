<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="pt">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
        <title>Pagamento — Auto Tech</title>
        <script src="https://cdn.tailwindcss.com"></script>
        <script>
            tailwind.config = {
                theme: {
                    extend: {
                        colors: {
                            primary: {500: '#3B82F6', 600: '#2563EB'},
                            secondary: '#06B6D4',
                            brand: '#0A2540',
                            surface: '#FFFFFF',
                            base: '#F8FAFC',
                            border: '#E2E8F0',
                            muted: '#64748B',
                            success: {DEFAULT: '#10B981', hover: '#059669', bg: '#D1FAE5'},
                            warning: {DEFAULT: '#F59E0B', bg: '#FEF3C7'},
                            error: {DEFAULT: '#EF4444', bg: '#FEE2E2'},
                            info: {DEFAULT: '#3B82F6', bg: '#DBEAFE'},
                        },
                        fontFamily: {
                            sans: ['DM Sans', 'sans-serif'],
                            mono: ['JetBrains Mono', 'monospace'],
                        },
                        boxShadow: {
                            card: '0 4px 24px 0 rgba(10,37,64,0.08)',
                            'card-lg': '0 8px 40px 0 rgba(10,37,64,0.12)',
                        },
                        borderRadius: {xl2: '1rem', xl3: '1.25rem'},
                    }
                }
            }
        </script>
        <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap" rel="stylesheet"/>

        <link rel="stylesheet" href="css/Style-PagamentoExterno.css"
    </head>
    <body class="flex items-center justify-center py-10 px-4 font-sans">

        <div class="w-full max-w-md">

            <!-- Header -->
            <div class="text-center mb-6">
                <div class="inline-flex items-center gap-2 bg-white/10 backdrop-blur-sm text-white px-4 py-2 rounded-full text-sm font-medium mb-3">
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="1" y="4" width="22" height="16" rx="2"/><line x1="1" y1="10" x2="23" y2="10"/></svg>
                    Sistema de Pagamento
                </div>
                <h1 class="text-white text-2xl font-bold tracking-tight">Finalizar Pagamento</h1>
                <p class="text-white/60 text-sm mt-1">Escolha o método de pagamento preferido</p>
            </div>

            <!-- Card container -->
            <div class="bg-surface rounded-xl3 shadow-card-lg overflow-hidden">

                <!-- Tabs -->
                <div class="flex border-b border-border">
                    <button id="tab-card" onclick="switchTab('card')"
                            class="flex-1 flex items-center justify-center gap-2 py-4 text-sm font-semibold transition-all duration-200 border-b-2 border-primary-500 text-primary-500">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="1" y="4" width="22" height="16" rx="2"/><line x1="1" y1="10" x2="23" y2="10"/></svg>
                        Cartão Visa
                    </button>
                    <button id="tab-ref" onclick="switchTab('ref')"
                            class="flex-1 flex items-center justify-center gap-2 py-4 text-sm font-semibold transition-all duration-200 border-b-2 border-transparent text-muted hover:text-brand">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/><line x1="16" y1="13" x2="8" y2="13"/><line x1="16" y1="17" x2="8" y2="17"/></svg>
                        Referência
                    </button>
                </div>

                <div class="p-6">

                    <!-- ========================== -->
                    <!-- ABA 1: CARTÃO              -->
                    <!-- ========================== -->
                    <div id="panel-card" class="tab-panel active">

                        <!-- Card preview -->
                        <div class="card-preview mb-6">
                            <div class="flex justify-between items-start mb-6 relative z-10">
                                <div class="chip"></div>
                                <svg width="48" height="30" viewBox="0 0 48 30" fill="none">
                                <circle cx="18" cy="15" r="14" fill="#EB001B" opacity="0.9"/>
                                <circle cx="30" cy="15" r="14" fill="#F79E1B" opacity="0.9"/>
                                <path d="M24 4.5a14 14 0 0 1 0 21 14 14 0 0 1 0-21z" fill="#FF5F00" opacity="0.9"/>
                                </svg>
                            </div>
                            <p id="preview-number" class="font-mono text-lg tracking-widest text-white/90 mb-4 relative z-10">•••• •••• •••• ••••</p>
                            <div class="flex justify-between items-end relative z-10">
                                <div>
                                    <p class="text-white/40 text-xs uppercase tracking-wider mb-1">Titular</p>
                                    <p id="preview-name" class="text-white font-medium text-sm tracking-wide">NOME DO TITULAR</p>
                                </div>
                                <div class="text-right">
                                    <p class="text-white/40 text-xs uppercase tracking-wider mb-1">Validade</p>
                                    <p id="preview-expiry" class="text-white font-medium text-sm font-mono">MM/AA</p>
                                </div>
                            </div>
                        </div>

                        <form id="cardForm" novalidate class="space-y-4">

                            <!-- Número do cartão -->
                            <div>
                                <label class="block text-xs font-semibold text-brand uppercase tracking-wider mb-1.5">Número do Cartão</label>
                                <input id="cardNumber" type="text" maxlength="19" placeholder="XXXX XXXX XXXX XXXX"
                                       class="w-full px-4 py-3 border border-border rounded-xl2 text-brand text-sm font-mono bg-base transition-all"
                                       oninput="formatCardNumber(this)" />
                                <p id="err-cardNumber" class="hidden mt-1.5 text-xs text-error-DEFAULT flex items-center gap-1">
                                    <svg width="12" height="12" viewBox="0 0 24 24" fill="currentColor"><path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm1 15h-2v-2h2v2zm0-4h-2V7h2v6z"/></svg>
                                    Número inválido — deve ter 16 dígitos.
                                </p>
                            </div>

                            <!-- VCC + Validade em linha -->
                            <div class="grid grid-cols-2 gap-4">
                                <div>
                                    <label class="block text-xs font-semibold text-brand uppercase tracking-wider mb-1.5">CVV</label>
                                    <input id="cvv" type="text" maxlength="3" placeholder="•••"
                                           class="w-full px-4 py-3 border border-border rounded-xl2 text-brand text-sm font-mono bg-base transition-all"
                                           oninput="this.value=this.value.replace(/\D/g,'')" />
                                    <p id="err-cvv" class="hidden mt-1.5 text-xs text-error-DEFAULT">CVV deve ter 3 dígitos.</p>
                                </div>
                                <div>
                                    <label class="block text-xs font-semibold text-brand uppercase tracking-wider mb-1.5">Validade</label>
                                    <input id="expiry" type="month"
                                           class="w-full px-4 py-3 border border-border rounded-xl2 text-brand text-sm bg-base transition-all" />
                                    <p id="err-expiry" class="hidden mt-1.5 text-xs text-error-DEFAULT">Data expirada ou inválida.</p>
                                </div>
                            </div>

                            <!-- Nome titular -->
                            <div>
                                <label class="block text-xs font-semibold text-brand uppercase tracking-wider mb-1.5">Nome do Titular</label>
                                <input id="cardName" type="text" placeholder="Ex: MARIA DA SILVA"
                                       class="w-full px-4 py-3 border border-border rounded-xl2 text-brand text-sm bg-base transition-all uppercase"
                                       oninput="updatePreviewName(this.value)" />
                                <p id="err-cardName" class="hidden mt-1.5 text-xs text-error-DEFAULT">Apenas letras e espaços são permitidos.</p>
                            </div>

                            <!-- Valor (readonly - fornecido pelo backend) -->
                            <div>
                                <label class="block text-xs font-semibold text-brand uppercase tracking-wider mb-1.5">
                                    Valor a Pagar
                                    <span class="ml-1 text-muted font-normal normal-case tracking-normal">(definido pelo sistema)</span>
                                </label>
                                <!-- TODO: Backend deve preencher o atributo value deste input com o valor da OS -->
                                <div class="relative">
                                    <span class="absolute left-4 top-1/2 -translate-y-1/2 text-muted text-sm font-semibold">AOA</span>
                                    <input id="amount" type="text" value="45.750,00" readonly
                                           class="w-full pl-14 pr-4 py-3 border border-border rounded-xl2 text-brand text-sm font-mono bg-[#F1F5F9] cursor-not-allowed font-semibold" />
                                    <span class="absolute right-3 top-1/2 -translate-y-1/2">
                                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="#94A3B8" stroke-width="2"><rect x="3" y="11" width="18" height="11" rx="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>
                                    </span>
                                </div>
                            </div>

                            <button type="submit"
                                    class="w-full mt-2 py-3.5 bg-primary-500 hover:bg-primary-600 disabled:opacity-50 disabled:cursor-not-allowed text-white font-semibold rounded-xl2 transition-all duration-200 flex items-center justify-center gap-2 text-sm shadow-md">
                                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg>
                                Confirmar Pagamento
                            </button>

                        </form>

                        <!-- Feedback de sucesso -->
                        <div id="card-success" class="hidden mt-4 p-4 bg-success-bg border border-success-DEFAULT rounded-xl2 text-center">
                            <svg class="mx-auto mb-2" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#10B981" stroke-width="2.5"><polyline points="20 6 9 17 4 12"/></svg>
                            <p class="text-success-DEFAULT font-semibold text-sm">Pagamento realizado com sucesso!</p>
                        </div>
                    </div>

                    <!-- ========================== -->
                    <!-- ABA 2: REFERÊNCIA          -->
                    <!-- ========================== -->
                    <div id="panel-ref" class="tab-panel">

                        <div class="space-y-4">

                            <!-- Valor (readonly - fornecido pelo backend) -->
                            <div>
                                <label class="block text-xs font-semibold text-brand uppercase tracking-wider mb-1.5">
                                    Valor
                                    <span class="ml-1 text-muted font-normal normal-case tracking-normal">(definido pelo sistema)</span>
                                </label>
                                <!-- TODO: Backend deve preencher o atributo value deste input com o valor da OS -->
                                <div class="relative">
                                    <span class="absolute left-4 top-1/2 -translate-y-1/2 text-muted text-sm font-semibold">AOA</span>
                                    <input type="text" value="45.750,00" readonly
                                           class="w-full pl-14 pr-4 py-3 border border-border rounded-xl2 text-brand text-sm font-mono bg-[#F1F5F9] cursor-not-allowed font-semibold" />
                                </div>
                            </div>

                            <!-- Entidade -->
                            <div>
                                <label class="block text-xs font-semibold text-brand uppercase tracking-wider mb-1.5">Entidade</label>
                                <input type="text" value="0023453" disabled
                                       class="w-full px-4 py-3 border border-border rounded-xl2 text-muted text-sm font-mono bg-[#F1F5F9] cursor-not-allowed" />
                            </div>

                            <!-- Referência -->
                            <div>
                                <label class="block text-xs font-semibold text-brand uppercase tracking-wider mb-1.5">Referência</label>
                                <!-- TODO: Backend deve preencher o value deste campo com a referência gerada -->
                                <div class="relative">
                                    <input id="refNumber" type="text" value="" readonly placeholder="Clique em Gerar Referência"
                                           class="w-full px-4 py-3 border border-border rounded-xl2 text-brand text-sm font-mono bg-[#F1F5F9] cursor-not-allowed tracking-widest" />
                                    <button id="copyBtn" onclick="copyRef()" class="hidden absolute right-3 top-1/2 -translate-y-1/2 text-primary-500 hover:text-primary-600 transition-colors" title="Copiar referência">
                                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="9" y="9" width="13" height="13" rx="2"/><path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1"/></svg>
                                    </button>
                                </div>
                            </div>

                            <!-- Info block -->
                            <div class="bg-info-bg border border-info-DEFAULT/20 rounded-xl2 p-4 flex gap-3">
                                <svg class="flex-shrink-0 mt-0.5" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#3B82F6" stroke-width="2"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
                                <p class="text-xs text-brand/70 leading-relaxed">
                                    Após gerar a referência, efectue o pagamento no Multicaixa ou através do seu banco. A referência é válida por <strong>48 horas</strong>.
                                </p>
                            </div>

                            <!-- Botão Gerar Referência -->
                            <!-- TODO: Backend deve verificar se já existe referência ativa para esta OS.
                                 Se existir → chamar blockRefButton() ao carregar a página.
                                 Se não existir → botão fica ativo por padrão. -->
                            <button id="genRefBtn" onclick="generateReference()"
                                    class="w-full py-3.5 bg-success-DEFAULT hover:bg-success-hover disabled:opacity-50 disabled:cursor-not-allowed text-white font-semibold rounded-xl2 transition-all duration-200 flex items-center justify-center gap-2 text-sm shadow-md">
                                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 5v14M5 12h14"/></svg>
                                <span id="genRefLabel">Gerar Referência</span>
                            </button>

                            <!-- Estado: referência gerada -->
                            <div id="ref-success" class="hidden p-4 bg-success-bg border border-success-DEFAULT rounded-xl2 text-center">
                                <svg class="mx-auto mb-2" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#10B981" stroke-width="2.5"><polyline points="20 6 9 17 4 12"/></svg>
                                <p class="text-success-DEFAULT font-semibold text-sm">Referência gerada com sucesso!</p>
                                <p class="text-muted text-xs mt-1">Válida por 48 horas</p>
                            </div>

                        </div>
                    </div>

                </div>

                <!-- Footer -->
                <div class="px-6 py-4 bg-base border-t border-border flex items-center justify-center gap-2">
                    <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="#64748B" stroke-width="2"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg>
                    <span class="text-xs text-muted">Transação segura e encriptada · PayExpress © 2025</span>
                </div>

            </div>
        </div>

        <script src="scripts/Script-PagamentoExterno.js">

        </script>

    </body>
</html>