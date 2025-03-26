import type { Metadata } from "next";
import { Inter } from "next/font/google";
import "./globals.css";

const inter = Inter({
  variable: "--font-inter",
  subsets: ["latin"],
  display: "swap", // Ensures faster rendering
});

export const metadata: Metadata = {
  title: "Quantum-API | Next-Gen AI-Powered Web Solutions",
  description:
    "Quantum-API delivers cutting-edge AI & Quantum Computing capabilities. Leverage the power of next-gen AI-driven applications with seamless integration.",
  keywords: [
    "Quantum Computing",
    "AI API",
    "Next.js",
    "Quantum AI",
    "FastAPI",
    "Machine Learning",
    "Quantum-API",
    "PennyLane",
  ].join(", "),
  authors: [{ name: "subatomicERROR", url: "https://github.com/subatomicERROR" }],
  openGraph: {
    title: "Quantum-API | AI & Quantum Computing Powerhouse",
    description:
      "Experience the future of AI & Quantum Computing with Quantum-API. Seamless API integration with cutting-edge technology.",
    url: "https://quantum-api.yourdomain.com",
    type: "website",
    images: [
      {
        url: "https://quantum-api.yourdomain.com/og-image.jpg",
        width: 1200,
        height: 630,
        alt: "Quantum-API - AI & Quantum Computing",
      },
    ],
  },
  twitter: {
    card: "summary_large_image",
    site: "@subatomicERROR",
    title: "Quantum-API | AI & Quantum Computing Powerhouse",
    description:
      "Quantum-API integrates next-gen AI with Quantum Computing for seamless, powerful applications.",
    images: ["https://quantum-api.yourdomain.com/og-image.jpg"],
  },
  metadataBase: new URL("https://quantum-api.yourdomain.com"),
  viewport: "width=device-width, initial-scale=1, maximum-scale=5, viewport-fit=cover",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en">
      <head>
        {/* Preconnect & Prefetch for Faster Performance */}
        <link rel="preconnect" href="https://fonts.gstatic.com" crossOrigin="anonymous" />
        <link rel="prefetch" href="/og-image.jpg" as="image" />

        {/* Favicon & Web Manifest */}
        <link rel="icon" href="/favicon.ico" sizes="32x32" type="image/x-icon" />
        <link rel="apple-touch-icon" href="/apple-touch-icon.png" sizes="180x180" />
        <link rel="manifest" href="/site.webmanifest" />
      </head>
      <body className={`${inter.variable} antialiased bg-black text-white`}>
        {children}
      </body>
    </html>
  );
}
