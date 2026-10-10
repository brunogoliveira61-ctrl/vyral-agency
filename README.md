# VYRAL — Plataforma inicial

Starter de site institucional + painel operacional para a agência VYRAL.

## O que está incluído
- Site público com identidade visual preta/roxo neon.
- Formulário de candidatura a criador (demonstração front-end).
- Painel de gestão com visão geral, criadores, produtos, vídeos e métricas de exemplo.
- SQL inicial para Supabase: tabelas, RLS e políticas base.
- Instruções para configuração e publicação.

## Importante
Esta é uma base de desenvolvimento, não uma plataforma já publicada nem pronta para receber dados reais.
O formulário e o painel usam dados de demonstração/local. Antes de uso real:
1. Crie o projeto Supabase e configure as variáveis de ambiente.
2. Implemente autenticação real, verificação de e-mail e autorização por papel no servidor.
3. Revise e teste as políticas RLS com contas de administrador, gestor e criador.
4. Adicione política de privacidade, termos e consentimentos adequados à LGPD.
5. Não exponha a chave `service_role` no navegador.
6. Revise os termos atuais da TikTok Shop; este projeto não é integrado à TikTok Shop.

## Rodar localmente
Requer Node.js LTS e npm.

```bash
npm install
npm run dev
```

Abra http://localhost:3000.

## Publicação
Use uma hospedagem cujo plano permita uso comercial. Para publicação comercial, confirme os termos e limites atuais do provedor escolhido. Não há publicação automática incluída.

## Estrutura
- `app/page.tsx`: site público
- `app/dashboard/page.tsx`: painel demonstrativo
- `app/apply/page.tsx`: candidatura demonstrativa
- `app/globals.css`: visual responsivo
- `supabase/schema.sql`: schema inicial e políticas RLS
- `.env.example`: variáveis necessárias quando a integração for adicionada
