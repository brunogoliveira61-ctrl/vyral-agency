import Link from "next/link";
import { ArrowUpRight, CheckCircle2, Clapperboard, Instagram, ShieldCheck, Sparkles, TrendingUp, Users } from "lucide-react";

const features = [
  { icon: Clapperboard, title: "Conteúdo que vende", text: "Briefings claros, vídeos originais e revisão antes de publicar." },
  { icon: TrendingUp, title: "Decisões por dados", text: "Acompanhe visualizações, cliques, pedidos e comissões reportadas." },
  { icon: Users, title: "Criadores em crescimento", text: "Uma operação organizada para criadores e parceiros de marca." },
];

export default function Home() {
  return <main>
    <nav className="nav wrap"><Link href="/" className="brand"><span className="brand-mark">V</span><span>VYRAL</span></Link><div className="nav-links"><a href="#como-funciona">Como funciona</a><a href="#para-marcas">Para marcas</a><Link className="nav-login" href="/dashboard">Painel demo <ArrowUpRight size={15}/></Link></div></nav>
    <section className="hero wrap">
      <div className="eyebrow"><span className="pulse"/> ECOSSISTEMA DE CRIADORES</div>
      <h1>Nascidos para<br/><span className="gradient">viralizar.</span></h1>
      <p className="hero-copy">Criatividade com estratégia. Conteúdo com propósito. Uma operação construída para conectar criadores, produtos e resultados.</p>
      <div className="hero-actions"><Link href="/apply" className="button primary">Quero ser criador <ArrowUpRight size={17}/></Link><a href="#como-funciona" className="button secondary">Conhecer a VYRAL</a></div>
      <div className="hero-proof"><span><CheckCircle2 size={16}/> Conteúdo original</span><span><CheckCircle2 size={16}/> Processo organizado</span><span><CheckCircle2 size={16}/> Foco em resultados</span></div>
      <div className="hero-orb"><div className="orb-v">V</div><div className="orb-ring ring-one"/><div className="orb-ring ring-two"/><div className="orb-dot dot-one"/><div className="orb-dot dot-two"/></div>
    </section>
    <section className="stats wrap"><div><strong>10</strong><span>criadores no grupo inicial</span></div><div><strong>01</strong><span>operação coordenada</span></div><div><strong>∞</strong><span>ideias para testar</span></div></section>
    <section id="como-funciona" className="section wrap"><div className="section-heading"><span className="eyebrow">NOSSO MÉTODO</span><h2>Conteúdo com método.<br/><span className="gradient">Crescimento com dados.</span></h2></div><div className="feature-grid">{features.map(({icon:Icon,title,text})=><article className="feature-card" key={title}><div className="feature-icon"><Icon size={22}/></div><h3>{title}</h3><p>{text}</p></article>)}</div></section>
    <section id="para-marcas" className="cta wrap"><div><span className="eyebrow">FAÇA PARTE DO MOVIMENTO</span><h2>Seu próximo conteúdo<br/>pode começar aqui.</h2><p>É criador? Candidate-se para fazer parte da rede VYRAL. É marca ou vendedor? Entre em contato para conversar sobre oportunidades.</p><div className="hero-actions"><Link href="/apply" className="button primary">Candidatar-me <ArrowUpRight size={17}/></Link><a className="button secondary" href="mailto:contato@vyral.com.br">Contato comercial</a></div></div><div className="cta-symbol"><Sparkles size={60}/><span>VYRAL</span></div></section>
    <footer className="footer wrap"><Link href="/" className="brand"><span className="brand-mark">V</span><span>VYRAL</span></Link><span>NASCIDOS PARA VIRALIZAR.</span><span>© {new Date().getFullYear()} VYRAL. Projeto inicial.</span></footer>
    <div className="notice"><ShieldCheck size={14}/> Site demonstrativo: formulários ainda não enviam dados para um servidor.</div>
  </main>;
}
