const http = require('http');
const https = require('https');
const fs = require('fs');
const path = require('path');

const PORT = process.env.PORT || 8080;
const PROXY_TARGET = 'https://metargeral.vercel.app';

const MIME_TYPES = {
    '.html': 'text/html; charset=utf-8',
    '.js': 'application/javascript; charset=utf-8',
    '.css': 'text/css; charset=utf-8',
    '.json': 'application/json; charset=utf-8',
    '.png': 'image/png',
    '.jpg': 'image/jpeg',
    '.svg': 'image/svg+xml',
    '.ico': 'image/x-icon',
    '.mp3': 'audio/mpeg',
    '.wav': 'audio/wav'
};

const server = http.createServer((req, res) => {
    // Enable CORS for local flexibility
    res.setHeader('Access-Control-Allow-Origin', '*');
    res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS');
    res.setHeader('Access-Control-Allow-Headers', 'Content-Type');

    if (req.method === 'OPTIONS') {
        res.writeHead(204);
        res.end();
        return;
    }

    if (req.url.startsWith('/api/')) {
        const targetUrl = PROXY_TARGET + req.url;

        const options = {
            method: req.method,
            headers: {
                'User-Agent': 'PortalGerenteDNIZ/1.0',
                'Accept': 'application/json',
                'Host': 'metargeral.vercel.app'
            }
        };

        const proxyReq = https.request(targetUrl, options, (proxyRes) => {
            res.writeHead(proxyRes.statusCode, {
                'Content-Type': proxyRes.headers['content-type'] || 'application/json; charset=utf-8',
                'Access-Control-Allow-Origin': '*',
                'Cache-Control': 'no-store, no-cache, must-revalidate'
            });
            proxyRes.pipe(res);
        });

        proxyReq.on('error', (err) => {
            console.error('Erro no Proxy METAR:', err.message);
            res.writeHead(502, { 'Content-Type': 'application/json; charset=utf-8' });
            res.end(JSON.stringify({ status: false, message: 'Erro de proxy: ' + err.message }));
        });

        req.pipe(proxyReq);
        return;
    }

    let urlPath = req.url.split('?')[0];
    if (urlPath === '/' || urlPath === '/index.html') {
        urlPath = 'index.html';
    } else {
        urlPath = urlPath.replace(/^\/+/, '');
    }

    const filePath = path.join(__dirname, urlPath);

    // Security check to prevent directory traversal
    if (!filePath.startsWith(__dirname)) {
        res.writeHead(403);
        res.end('Acesso negado');
        return;
    }

    fs.readFile(filePath, (err, content) => {
        if (err) {
            res.writeHead(404, { 'Content-Type': 'text/plain; charset=utf-8' });
            res.end('Arquivo não encontrado: ' + urlPath);
            return;
        }
        const ext = path.extname(filePath).toLowerCase();
        const contentType = MIME_TYPES[ext] || 'application/octet-stream';
        res.writeHead(200, { 'Content-Type': contentType });
        res.end(content);
    });
});

server.listen(PORT, () => {
    console.log('======================================================');
    console.log('  PORTAL GERENTE DNIZ - PAINEL OPERACIONAL PERMANENTE ');
    console.log(`  Acesse no navegador: http://localhost:${PORT}/`);
    console.log('======================================================');
});
