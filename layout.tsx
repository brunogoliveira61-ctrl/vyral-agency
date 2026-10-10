import type { Metadata } from "next";
import "./globals.css";
export const metadata: Metadata = { title: "VYRAL — Nascidos para viralizar", description: "Plataforma de criadores e conteúdo da VYRAL." };
export default function RootLayout({ children }: Readonly<{ children: React.ReactNode }>) { return <html lang="pt-BR"><body>{children}</body></html>; }
