/**
 * Custom Node.js server cho Railway — handle cả GET và POST đến root
 * Vì Railway static file server (nginx) trả 405 cho POST,
 * cần server riêng để Google Identity Services redirect mode hoạt động.
 * 
 * Khi Google redirect về (response_mode=form_post — mặc định),
 * server này nhận POST và trả index.html, GIS script đọc credential.
 * Với response_mode=query, Google GET với ?credential=xxx → cũng OK.
 */
const http = require('http');
const fs = require('fs');
const path = require('path');

const PORT = process.env.PORT || 3000;
const PUBLIC_DIR = path.join(__dirname, 'build', 'web');

const MIME_TYPES = {
  '.html': 'text/html',
  '.js': 'application/javascript',
  '.css': 'text/css',
  '.json': 'application/json',
  '.png': 'image/png',
  '.jpg': 'image/jpeg',
  '.gif': 'image/gif',
  '.svg': 'image/svg+xml',
  '.ico': 'image/x-icon',
  '.woff': 'font/woff',
  '.woff2': 'font/woff2',
  '.txt': 'text/plain',
  '.map': 'application/json',
};

function serveFile(res, filePath) {
  fs.readFile(filePath, (err, content) => {
    if (err) {
      res.writeHead(500, { 'Content-Type': 'text/plain' });
      res.end('Internal Server Error');
      return;
    }
    const ext = path.extname(filePath);
    const contentType = MIME_TYPES[ext] || 'application/octet-stream';
    res.writeHead(200, { 'Content-Type': contentType });
    res.end(content);
  });
}

const server = http.createServer((req, res) => {
  const url = new URL(req.url, `http://${req.headers.host || 'localhost'}`);
  let filePath = path.join(PUBLIC_DIR, 'index.html');

  if (req.method === 'GET') {
    const urlPath = url.pathname === '/' ? '/index.html' : url.pathname;
    const exactPath = path.join(PUBLIC_DIR, urlPath);

    // Security: ensure path is within PUBLIC_DIR
    const resolved = path.resolve(exactPath);
    if (resolved.startsWith(path.resolve(PUBLIC_DIR)) &&
        fs.existsSync(resolved) && fs.statSync(resolved).isFile()) {
      filePath = resolved;
    }
  }

  serveFile(res, filePath);
});

server.listen(PORT, () => {
  console.log(`VanVy English server running on port ${PORT}
  Serving: ${PUBLIC_DIR}
  Ctrl+C to stop`);
});

server.on('error', (err) => {
  console.error('Server error:', err);
  process.exit(1);
});
