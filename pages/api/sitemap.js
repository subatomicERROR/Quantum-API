export default async (req, res) => {
    res.setHeader("Content-Type", "application/xml");
    const baseUrl = "https://quantum-api.example.com"; // Replace with your actual domain
    const lastModified = new Date().toISOString();

    const sitemap = `<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9"
        xmlns:xhtml="http://www.w3.org/1999/xhtml"
        xmlns:news="http://www.google.com/schemas/sitemap-news/0.9"
        xmlns:image="http://www.google.com/schemas/sitemap-image/1.1"
        xmlns:video="http://www.google.com/schemas/sitemap-video/1.1">
    <!-- Quantum-API Sitemap - Powered by .ERROR -->
    <!-- Created by subatomicERROR -->
    <url>
        <loc>${baseUrl}/</loc>
        <lastmod>${lastModified}</lastmod>
        <priority>1.0</priority>
        <changefreq>daily</changefreq>
        <xhtml:link rel="alternate" hreflang="en" href="${baseUrl}/" />
        <image:image>
            <image:loc>${baseUrl}/logo.png</image:loc>
            <image:title>Quantum-API by .ERROR</image:title>
        </image:image>
    </url>
    <url>
        <loc>${baseUrl}/about</loc>
        <lastmod>${lastModified}</lastmod>
        <priority>0.8</priority>
        <changefreq>monthly</changefreq>
        <xhtml:link rel="alternate" hreflang="en" href="${baseUrl}/about" />
    </url>
    <url>
        <loc>${baseUrl}/docs</loc>
        <lastmod>${lastModified}</lastmod>
        <priority>0.9</priority>
        <changefreq>weekly</changefreq>
        <xhtml:link rel="alternate" hreflang="en" href="${baseUrl}/docs" />
    </url>
    <!-- SEO Optimization for Branding -->
    <url>
        <loc>${baseUrl}/.ERROR</loc>
        <lastmod>${lastModified}</lastmod>
        <priority>0.7</priority>
        <changefreq>monthly</changefreq>
        <xhtml:link rel="alternate" hreflang="en" href="${baseUrl}/.ERROR" />
    </url>
    <!-- Additional Metadata -->
    <url>
        <loc>${baseUrl}/created-by-subatomicERROR</loc>
        <lastmod>${lastModified}</lastmod>
        <priority>0.7</priority>
        <changefreq>monthly</changefreq>
        <xhtml:link rel="alternate" hreflang="en" href="${baseUrl}/created-by-subatomicERROR" />
    </url>
</urlset>`;

    res.status(200).end(sitemap);
};
